function [dzz,dxx,dz,dx,dxz] = fdopt(u,h)

[nz,nx] = size(u);
n  = numel(u);
u  = ones(nz,nx);
u = padarray(u,[2,2],0,'both');

vec = @(a) a(:);

dz  = spdiags([vec(-u(5:end,3:end-2)), vec(8*u(4:end-1,3:end-2)), vec(-8*u(2:end-3,3:end-2)), vec(u(1:end-4,3:end-2))] , [-2,-1,1,2]         , n,n)/(h*12);
dx  = spdiags([vec(-u(3:end-2,5:end)), vec(8*u(3:end-2,4:end-1)), vec(-8*u(3:end-2,2:end-3)), vec(u(3:end-2,1:end-4))] , [-2*nz,-nz,nz,2*nz] , n,n)/(h*12);
dxz = dx*dz;

dzz = spdiags([vec(-u(1:end-4,3:end-2)), vec(16*u(2:end-3,3:end-2)), vec(-30*u(3:end-2,3:end-2)), vec(16*u(4:end-1,3:end-2)), vec(-u(5:end,3:end-2))] , [2,1,0,-1,-2]        , n,n)/(h^2*12);
dxx = spdiags([vec(-u(3:end-2,1:end-4)), vec(16*u(3:end-2,2:end-3)), vec(-30*u(3:end-2,3:end-2)), vec(16*u(3:end-2,4:end-1)), vec(-u(3:end-2,5:end))] , [2*nz,nz,0,-nz,-2*nz] , n,n)/(h^2*12);

end