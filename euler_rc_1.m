% function to explicite Euler forward
function psinew_l=euler_rc(psi_l,psi_u,c_l,q,ibtyp_u,qb_u,psi_pot,ibtyp_l,qb_l,dz,dt_l,k_l,stor_l,dim)

psinew_l=zeros(dim,1);
psi_lim=1.1;
i=1;
if ibtyp_u == 1 % in case of flux boundary condition
%    if c_l(i) <=0
%        c_l(i) 
%    end
    psinew_l(i)=psi_l(i)+dt_l/(c_l(i)*1*dz(i))*(q(i)-qb_u); % qb_u is flux at upper boundary
    if psinew_l(i) >=0. % in case of saturation at upper node
       psinew_l(i)=psi_pot; % set psi to zero if upper element is saturated
    end;    
elseif ibtyp_u == 2 % in case of Dirichlet condition
   psinew_l(i)=psi_u;
   q(i)=-1.*k_l(i)*(psi_l(i+1)-psi_l(i))/(-1.*dz(i));
end
    

 % intermediate Theta at intermediate at inner nodes
for i=2:dim-1
%    if psi_l(i) >=0
%        display(psi_l); 
%    end
    if abs(psi_l(i)) >= psi_lim   
      psinew_l(i)=psi_l(i)+dt_l/(c_l(i)*dz(i))*(q(i)-q(i-1));
    else
     psinew_l(i)=psi_l(i)+dt_l/(stor_l(1)*dz(i)*dz(i))*(q(i)-q(i-1));
    end

     if psinew_l(i) >= 0
          %psinew_l(i)=0.;
          bla=1;
     end 
end
 
%lower boundary
i=dim;
if ibtyp_l == 1
%    if c_l(i) <=0
%       c_l(i) 
%    end
    if abs(psi_l(i)) >= psi_lim   
     psinew_l(i)=psi_l(i)+dt_l/(c_l(i)*dz(i-1)*dz(i-1))*(qb_l-q(i-1));
    else
     psinew_l(i)=psi_l(i)+dt_l/(stor_l(1)*dz(i-1)*dz(i-1))*(qb_l-q(i-1));
    end
elseif ibtyp_l == 2
    %theta_new(i)=theta_l;
    psinew_l(i)=psi_l(i);
elseif ibtyp_l == 3
    %theta_new(i)=theta_new(i-1);
    psinew_l(i)=psi_l(i)+dt_l/(c_l(i)*dz(i-1))*qb_l;
end
