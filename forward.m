function [p,dttp,data] = forward(v,h,dt,t,Lpml,f0,source,Sloc,Rloc)

v = padarray(v,[Lpml,Lpml],"replicate","both");
[nz,nx] = size(v);
Rloc = Rloc + Lpml;
Sloc = Sloc + Lpml;

p    = zeros(nz*nx,length(t));
dttp = zeros(nz*nx,length(t));
data = zeros(length(t),size(Rloc,1));
S    = zeros(nz,nx);

[dzz,dxx,dz,dx,~] = fdopt(v,h);
p0 = zeros(numel(v),1);
p1 = zeros(numel(v),1);
x3 = zeros(numel(v),1);
x2 = zeros(numel(v),1);
x1 = zeros(numel(v),1);
z3 = zeros(numel(v),1);
z2 = zeros(numel(v),1);
z1 = zeros(numel(v),1);

[Ex,Ez,Exdx,Ezdz,Q1x,Q2x,Q1z,Q2z] = PML(h,v,dt,Lpml,f0);

for i = 2 : length(t)+1

    for j = 1 : size(Sloc,1)
        S(Sloc(j,1) , Sloc(j,2)) = source(i-1,j);
    end

    px  =  dx*p1;
    pz  =  dz*p1;
    pxx = dxx*p1;
    pzz = dzz*p1;

    x3 = Q1x.*x3 + Q2x.*(-Ex.^2.*Exdx.*px);
    x2 = Q1x.*x2 + Q2x.*(Ex.^2.*pxx + 2*Ex.*Exdx.*px + x3);
    x1 = Q1x.*x1 + Q2x.*(-2*Ex.*pxx - Exdx.*px + x2);

    z3 = Q1z.*z3 + Q2z.*(-Ez.^2.*Ezdz.*pz);
    z2 = Q1z.*z2 + Q2z.*(Ez.^2.*pzz + 2*Ez.*Ezdz.*pz + z3);
    z1 = Q1z.*z1 + Q2z.*(-2*Ez.*pzz - Ezdz.*pz + z2);

    p2 = 2*p1 - p0 + dt^2*v(:).^2.*(pxx + pzz + x1 + z1 + S(:));

    dttp(:,i-1) = (p2 - 2*p1 + p0)/dt^2;

    p(:,i-1) = p1;

    ptemp = reshape(p1,nz,nx);
    for j = 1 : size(Rloc,1)
        data(i-1,j) = ptemp(Rloc(j,1), Rloc(j,2));
    end

    p0 = p1;
    p1 = p2;

end


p = reshape(p,nz,nx,size(p,2));
p = p(Lpml+1:end-Lpml,Lpml+1:end-Lpml,:);

dttp = reshape(dttp,nz,nx,size(dttp,2));
dttp = dttp(Lpml+1:end-Lpml,Lpml+1:end-Lpml,:);

end