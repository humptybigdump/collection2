% ------------------------------------------------------
function [sol,dsol,d2sol,d3sol,d4sol]=exact_solution(alpha,Lx,Ta,time,xvec)
%
% usage: [sol,dsol,d2sol,d3sol,d4sol]=exact_solution(alpha,Lx,Ta,time,xvec)
%
% computes the analytical solution to the heat equation 
% (obtained through separation of variables) for the case
% with inhomogeneous Dirichlet b.c. at one end (where: T=Ta) 
% and homogeneous neumann b.c. at the other. the length of the  
% space interval is [0,Lx].
% also returns as "dsol" the 1st derivative of the solution. 
% also returns as "d2sol" the 2nd derivative of the solution. 
% also returns as "d3sol" the third derivative of the solution. 
% also returns as "d4sol" the 4th derivative of the solution. 
%
nterms=max(100,length(xvec)); %<-the number of terms to retain 
                             %in the series expansion
%
sol=Ta*ones(size(xvec));
dsol=zeros(size(xvec));
d2sol=zeros(size(xvec));
d3sol=zeros(size(xvec));
d4sol=zeros(size(xvec));
for nt=1:nterms
  Bn=4*Ta*(sin(pi*nt)-1)/((2*nt-1)*pi);
  sol=sol+Bn*exp(-alpha*time*(pi*(2*nt-1)/(2*Lx))^2).*...
      sin((2*nt-1)*pi*xvec/(2*Lx));
  %
  dsol=dsol  +Bn*exp(-alpha*time*(pi*(2*nt-1)/(2*Lx))^2).*...
        cos((2*nt-1)*pi*xvec/(2*Lx))*((2*nt-1)*pi/(2*Lx));
  %
  d2sol=d2sol+Bn*exp(-alpha*time*(pi*(2*nt-1)/(2*Lx))^2).*...
        -sin((2*nt-1)*pi*xvec/(2*Lx))*((2*nt-1)*pi/(2*Lx))^2;
  %
  d3sol=d3sol+Bn*exp(-alpha*time*(pi*(2*nt-1)/(2*Lx))^2).*...
        -cos((2*nt-1)*pi*xvec/(2*Lx))*((2*nt-1)*pi/(2*Lx))^3;
  %
  d4sol=d4sol+Bn*exp(-alpha*time*(pi*(2*nt-1)/(2*Lx))^2).*...
        sin((2*nt-1)*pi*xvec/(2*Lx))*((2*nt-1)*pi/(2*Lx))^4;
end
% ------------------------------------------------------
