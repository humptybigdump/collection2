% function to explicite Euler forward
function thetanew_l=euler_th(theta_l,q,ibtyp_u,qb_u,ibtyp_l,qb_l,istyp,thr,ths,dz,dt_l,dim)

thetanew_l=zeros(dim,1);
i=1;;
 if ibtyp_u == 1
      thetanew_l(i)=theta_l(i)+dt_l/(1*dz(i))*(q(i)-qb_u);    
 elseif ibtyp_u == 2
      thetanew_l(i)=thetab_u;
 end


 % intermediate Theta at intermediate at inner nodes
for i=2:dim-1
  thetanew_l(i)=theta_l(i)+dt_l/(dz(i-1))*(q(i)-q(i-1));
end
 
%lower boundary
   i=dim;
   if ibtyp_l == 1
      thetanew_l(i)=theta(i)+dt/(dz)*(qb_l-q(i-1));
   elseif ibtyp_l == 2
      thetanew_l(i)=theta_l;
   elseif ibtyp_l == 3
      thetanew_l(i)=thetanew_l(i-1);
   end
   % check definition
   for i =1: dim
      if thetanew_l(i) > ths(istyp(i))
         thetanew_l(i)= ths(istyp(i))*0.99;
      elseif thetanew_l(i) < thr(istyp(i))
         thetanew_l(i) = thr(istyp(i))*1.1;
      end 
   end
   
   
end
