function [wake] = GetWakeStreamline( fld,prf,NW )
%GETWAKESTREAMLINE  calculates the nodes on the wake streamline and the dead air region. 
%                   uses Newton method to find points with psi=psi0
%                   NW: number of wake nodes



%        calculate first wake tangent vector
%           -> mean of tangent vectors of first and N-th panel 
e1=prf.panels.e(:,1);
eN=prf.panels.e(:,end-1);
s=0.5*transpose(eN-e1);

%    calculate TE midpoint as first wake node
x1=[prf.panels.X(1,1) prf.panels.Y(1,1)]; 
xN=[prf.panels.X(1,end) prf.panels.Y(1,end)];

xTE= (x1+xN)/2 + 0.0001*s; % Midpoint of TE
psi0=fld.psi0;
%psi0=evaluateInviscFieldSol(xTE,fld,prf);

% starting step size of wake equals the Panel length of first panel
h=0.5*( prf.panels.L(1) + prf.panels.L(prf.N-1) );

% Calculate the constant grading factor with a fixed number of nodes and a fixed length
%   -> set length of wake equal to airfoil chord 
grading=Grading(h,prf.c,NW);

% initial guess second wake point -> use previous direction
guess= xTE + h*s;

xw=zeros(NW,2); xw(1,:)=xTE;
sw=zeros(1,NW);
lw=zeros(1,NW-1);


for i=1:NW-1 % loop over all wake nodes
    xw(i+1,:)=guess;
  
    %------------- iterate to find Loadingpoint with exact psi=psi0  -------
    res=1;k=0; dpmin=2;noConv=false;
    while res>1e-6 && k<40 % prevent endless loop
        
        % evaluate the streamfunction psi at current point
        psi= evaluateInviscFieldSol(xw(i+1,:),fld,prf);
        
        % get the gradient of psi at current point
        [dg_dx,dg_dy]=GradPsi(xw(i+1,1), xw(i+1,2),prf);
        dpsi_dx=-dg_dx*fld.gamma;
        dpsi_dy=-dg_dy*fld.gamma;

        ht=norm(xw(i+1,:)-xw(i,:));
        
        % Newton-Method

        J=[dpsi_dx, dpsi_dy; 2*(xw(i+1,1)-xw(i,1)), 2*(xw(i+1,2)-xw(i,2))];
        f=[psi-psi0, ht^2-h^2];

        dx=  (f(2)*J(1,2) - f(1)*J(2,2))/( J(1,1)*J(2,2)- J(1,2)*J(2,1) );
        dy=  (f(1)*J(2,1) - f(2)*J(1,1))/( J(1,1)*J(2,2)- J(1,2)*J(2,1) );
        
        
        % relativ difference
        dp= abs((psi-psi0)/psi0);
        if dp<dpmin
           dpmin=dp; % minimum deviation of psi
           xmin=xw(i+1,:);
        end
        
        res=max(abs(f./[psi0,h]));
        % refresh for new iteration
        xw(i+1,:)= xw(i+1,:) + [dx, dy];
        
        % if Newtonmethod does not converge or converges to wrong solution
        if xw(i+1,1)<xw(i,1) || abs(xw(i+1,2)-xw(i,2)) > 0.5*h
           noConv=true; break 
        end
        
        k=k+1;
    end

    if noConv || dpmin>0.008 
        % in case of divergence or to big deviation of psi0 -> try intersection method
        [xI, psiI]=Intersection(fld,prf,guess,h,psi0);
        if abs((psiI-psi0)/psi0)<0.008 
           xw(i+1,:)= xI; 
        else
           xw(i+1,:)=guess; 
        end
    else
        xw(i+1,:)= xmin;
    end
    
    % save point, panel length and arc length
    lw(i)=norm(xw(i+1,:)-xw(i,:));
    delta=xw(i+1,:)-xw(i,:);
    guess= xw(i+1,:) + grading*delta;
    sw(i+1)=sw(i) + lw(i);
    h=lw(i)*grading;
    
    clear nearest
end


%tangential vectors

ew=transpose(xw(2:end,:)-xw(1:end-1,:)); ew=[ew(1,:)./lw; ew(2,:)./lw];
nw=[-ew(2,:);ew(1,:)];

% normal vector of node -> mean value of panel normal vectors
nwn=(nw(:,1:end-1)+nw(:,2:end))/2;
nwn=[nw(:,1),nwn, nw(:,end)];

% save in struct
wake.theta=atan2(ew(1,:),-ew(2,:));
wake.x=xw(:,1);
wake.y=xw(:,2);
wake.e=ew;
wake.n=nw;
wake.L=lw;
wake.s=sw;
wake.nn=nwn;
wake.N=NW;


% Trailing edge Gap
if prf.sharpTE
    wake.gap=zeros(size(wake.x));
else
    % Calculate the dead air region behind the blunt trailing edge for downstream wakepoints
    AN=prf.ScrossT.*prf.panels.L(end); % TE gap section
    % Length of dead air region is estimated by 2.5*AN
    ZN=1-wake.s/(2.5*AN); 
    xp1=prf.nodes.X(2)-prf.nodes.X(1);
    xpN=prf.nodes.X(end)-prf.nodes.X(end-1);
    yp1=prf.nodes.Y(2)-prf.nodes.Y(1);
    ypN=prf.nodes.Y(end)-prf.nodes.Y(end-1);
    Cross= (xp1*ypN-yp1*xpN)/sqrt( (xp1^2+yp1^2)*(xpN^2+ypN^2) );
    D=Cross/sqrt(1-Cross^2);
    D=max(D,-3/2.5);
    D=min(D, 3/2.5);
    A= 3 + 2.5*D;
    B=-2 - 2.5*D;
    wg=zeros(size(wake.x));
    % only if wg>0 there is a dead air at current node, otherwise the approximation gives negative values
    wg(ZN>0)= AN* (A+B*ZN(ZN>0)).*ZN(ZN>0).^2;
    wake.gap=wg;
end

end

