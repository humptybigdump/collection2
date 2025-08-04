(* ::Package:: *)

BeginPackage["FEM`dynamics`"]   (* written by A.Niemunis  5.10.2021 for dydactic purposes only *)


x::usage="a spatial coordinate as a global variable "; 

g::usage="a global variable for graphics from the element. 
            This graphics is generated as a side effect and need not be used."; 
            
Kglob::usage="total stiffness matrix , a global variable ";
Mglob::usage="total mass matrix, a global variable ";
Cglob::usage="total damping matrix, a global variable "; 

Ub1::usage="a global variable of size{ndofs,3}  contains  
             Ub1[[All,1]] = displacements U (and possibly their spatial derivatives) in all DOFs   
             Ub1[[All,2]]  = velocities dU (and possibly their spatial derivatives) in all DOFs  
             Ub1[[All,3]] =  accelerations ddU (and possibly their spatial derivatives) in all DOFs   
          all at time t_n+1 "   ;

Ub::usage="a global variable of size {ndofs,3} contains  
             Ub[[All,1]] = displacements U (and possibly their spatial derivatives) in all DOFs   
             Ub[[All,2]]  = velocities dU (and possibly their spatial derivatives) in all DOFs  
             Ub[[All,3]] =  accelerations ddU (and possibly their spatial derivatives) in all DOFs  
          all at time t_n ";   

dUb::usage="a global variable of size ndofs  contains displacement increment from t_n  to t_n+1"  ;

UbE::usage="a global variable of size {ndofs,3}  contains  extrapolators of 
             Ub[[All,1]] = displacements U (and possibly their spatial derivatives) in all DOFs   
             Ub[[All,2]]  = velocities dU (and possibly their spatial derivatives) in all DOFs  
             Ub[[All,3]] =  accelerations ddU (and possibly their spatial derivatives) in all DOFs  
        The extrapolators are  approximations of the respoecive values at t_n+1 calculated using the values from t_n only.
         Only two extrapolators are used in GN, but which two depends on the time-algorithm. 
 "; 
                
Fb::usage="a global variable of size ndofs   contains total external load  for each DOF.  
Fb is time-dependent and will be calculated in each increment.
 "  ;


Uhist::usage = " stores the subsequent results { Ub1 , Ub2 }  , a global variable 
        Each component, for example Ub1,  consists of 
             Ub1[[All,1]] = displacements U (and possibly their spatial derivatives) in all DOFs   
             Ub1[[All,2]]  = velocities dU (and possibly their spatial derivatives) in all DOFs  
             Ub1[[All,3]] =  accelerations ddU (and possibly their spatial derivatives) in all DOFs   
"; 


getElement::usage=" {Kelem, Melem, Celem} = getElement[ elementData ] 
                    returns element matrices K,M,C  from a single 1D truss element 
                    Arguments in elementData are: {type , nN , h, EA , rhoA  }
                     type= T2 = two-node elelment with C0 continuity 1 DOF per node
                           T2H = two-node elelment with C1 continuity (Hermite-Element, but truss not beam) 2 DOFs per node
                           TN  = spectral  element with nN Gau\[SZ]-Lobatto nodes 1 DOF per node
                     h= element length, 
                     EA = elastic stiffness,
                     rhoA = mass density,
                     nN = number of nodes per element to be defined for type=TN " ;
                     
getLobattoShapes::usage="{points, weights, Ns, Nsp } = getLobattoShapes[nN_,   h_] 
                    returns Lobatto nN points and shapes and their derivatives  as functions of global x. Arguments: 
                    nN number of nodes (=Lobatto points) per element (inklusive end points with x=-1 and x=1) 
                    h= element length     ";
                    
eIntegrate::usage=" eIntegrate[ f  , points,  weights,  h  ] returns integrated f . Arguments: 
                    f = function of x to be  integrated over x from -1 to 1  and scaled with Jacobian h/2
                    points = Lobatto points, 
                    weights = weighting factors,  
                    h= element length   ";
                    
 eInt::usage=" eIntegrate[ f  ,  h  ] returns integrated f (numerically with two GPs). Arguments: 
                    f = function of x to be  numerically  integrated over x from -1 to 1  and scaled with Jacobian h/2 
                    h= element length   ";    
                                   
aggregateElements::usage=" {ndofs  nBC1, nBC2} = aggregateElements[type, nN, nelem, Kelem,Melem, Celem, lumpedMass]  
              Aggregates elements assuming all of them are identical. 
               Contributions aggregated from all elements are written into global the matrices Kglob, Mglob,Cglob. 
              The results directly output are :  
               ndofs = total number of DOFs 
               BC1 = the DOF-position of the  displacement  of the first node 
               BC2   the DOF-position of the  displacement  of the last node   
               Arguments: 
              type= T2 = two-node elelment with C0 continuity
                           T2H = two-node elelment with C1 continuity (Hermite-Element, but truss not beam)
                           TN  = spectral  element with many Gau\[SZ]-Lobatto nodes 
              h   = element length, 
              nelem = number of elements,   
              Kelem,Melem,Celem = element matrices obtained from getElement[] 
              lumpedMass = True if the total  mass matrix Mglob should be diagonalized  
"; 

smoothPulse::usage=" smoothPulse[t, tPeriod]  a unit time function used in  a   BC (a prescribed disturbance) "; 

smoothWave::usage=" smoothWave[t, tPeriod]   a unit time function used in a  BC  (a prescribed disturbance) ";    

initialize::usage=" MatrInv = initialize[   meshBC  , newmark  ,tempo] initializes global variables and returns 
inverse global system matrix MatrInv according to the time-method indicated by method inside the list newmark.   
The following argumemts should be prescribed: 
meshBC = {nelem, ndofs, BC1, BC2} = number of elements, number of DOFs, and global DOF numbers for displacement-type BC
newmark ={b1,b2,a,method}  = beta1 , beta2 for GN-method, and alpha for HTT method
                              method is the type of time-algorithm; so far one of:  GN22acc    GN22disp   GN22dispStress    HHTdisp 
tempo = {dt,tPeriod, tE} = time increment, period of the initial disturbance,  end duration of the calculation  
The implemented time-algorithms are 
   GN22acc           generalized Newmark driven by acceleration as the main unknown  \[IndentingNewLine]   GN22disp          generalized Newmark driven by displacement as the main unknown\[IndentingNewLine]   GN22dispStress    generalized Newmark driven by displacement as the main unknown; out-of-balance forces from stress like in nonL mat. \[IndentingNewLine]   HHTdisp           Hilbert-Hughes-Taylor driven by displacement as the main unknown\[IndentingNewLine]   HTdispStress     Hilbert-Hughes-Taylor driven by displacement as the main unknown; out-of-balance forces from stress like in nonL mat. \[IndentingNewLine] Note that the combination  of   TN -element with  GN22dispStress  or  HHTdispStress  is not implemented as yet 
"  ;  

increment::usage="increment[ t,   meshBC, newmark, tempo ] performs a single time increment and updates Uhist 
The following argumemts should be prescribed: 
t = current time 
meshBC = {nelem, ndofs, BC1, BC2} = number of elements, number of DOFs, and global DOF numbers for displacement-type BC
newmark ={b1,b2,a,method}  = beta1 , beta2 for GN-method, and alpha for HTT method
                              method is the type of time-algorithm; so far one of:  GN22acc    GN22disp   GN22dispStress    HHTdisp 
tempo = {dt,tPeriod, tE} = time increment, period of the initial disturbance,  end duration of the calculation  
The implemented time-algorithms are 
   GN22acc           generalized Newmark driven by acceleration as the main unknown  \[IndentingNewLine]   GN22disp          generalized Newmark driven by displacement as the main unknown\[IndentingNewLine]   GN22dispStress    generalized Newmark driven by displacement as the main unknown; out-of-balance forces from stress like in nonL mat. \[IndentingNewLine]   HHTdisp           Hilbert-Hughes-Taylor driven by displacement as the main unknown\[IndentingNewLine]   HTdispStress     Hilbert-Hughes-Taylor driven by displacement as the main unknown; out-of-balance forces from stress like in nonL mat. \[IndentingNewLine] Note that the combination  of   TN -element with  GN22dispStress  or  HHTdispStress  is not implemented as yet 
 " ;              


Begin["`Private`"] 
getLobattoShapes[nN_,   h_] := Module[{ points, weights , a, Ns, Nsp,eq,  apoly, unknowns,i,j,solu,powers}, 
points  = x/.Solve[ D[ LegendreP[nN-1,x]  ,x ] ==0,x]//N//Chop  ; (* zero points of Lobatto polynom *)
points = Join[points, {-1,1}] // Sort; 
weights = Array[0&,nN]; 
Do[  weights[[i]] = 2/(nN(nN-1)) / (LegendreP[nN-1,points[[i]] ]  )^2, {i,1,nN} ];
unknowns =  a[#]   & /@ Range[0,nN-1]   ;
powers  = {1} ~Join~(      x^# & /@ Range[1,nN-1] ) ;
 apoly = unknowns.powers ;   
Ns=  (eq = Array[0&, nN] );  
Do[
Do[eq[[ i]]  =( apoly /. x-> points[[i]] )  ==  KroneckerDelta[i,j] , {i,1,nN} ];
solu = Solve[eq  , unknowns][[1]]  ; 
Ns[[j]] = apoly /. solu ; 
,{j,1,nN} ];
 Nsp = D[Ns,x] * 2/h; 
{points, weights, Ns, Nsp } //N  (* x is a global variable *)
]; (*---------------------------------------------------------------------*)

eIntegrate[ f_  , points_,  weights_,  h_   ] := Module[{nN,k,int} , 
nN = Length[weights] ; 
 int = Sum[   weights[[k]] *f//. x-> points[[k]]   , {k,1,nN}]  ;   
int *h/2
 ]; (*---------------------------------------------------------------------*)
 
eInt[ f_  ,  h_   ] := Module[{ wGP = {1,1}, GPs ={-1 , 1} /Sqrt[3],  int} , 
 int = Sum[   wGP[[k]] *f //. x-> GPs[[k]]   , {k,1,2 }]  ;   
int *h/2
 ]; (*---------------------------------------------------------------------*) 

getElement[ elementData_]:= Module[{Ns,Nsp,n1,nb1,n2,nb2,points,weights,Kelem,Melem,Celem, type, nN, h, EA, rhoA}, 
 {type,  nN, h,  EA, rhoA }  = elementData; 
If[ type == "T2",   (*truss element C0 continuity *)
Ns={1-x/h,x/h};Nsp={-1/h,1/h}; 
g = GraphicsRow[  { Plot[Ns , {x,0,h}] ,   Plot[ (Nsp*h/2)// Evaluate, {x,0,h} ] }]; 
Kelem=EA*Integrate[Outer[Times,Nsp,Nsp],{x,0,h}];
Melem=rhoA*Integrate[Outer[Times,Ns,Ns],{x,0,h}]; 
];
If[ type == "T2H",   (*hermitian truss element   C1 continuity *)
n1 =  (-1  +   x) (-1+  x) (2 + x)/4 ;   nb1 = 5  (-1+  x)^2 (1+   x) /4 ;
n2 = -  (-2+  x) (1+  x) (1 + x) /4;   nb2 = 5/4(-1+  x) (1 + x)^2 ; 
Ns = {n1,nb1,n2,nb2};
Nsp = {1/4* (-1+x)^2+ (-1+x) (2+x)/2, 5/4 *(-1+x)^2+5/2* (-1+x) (1+x),  (2-x) (1+x)/2 -1/4*(1+x)^2, 5/2* (-1+x) (1+x)+ 5/4* (1+x)^2}*2/h;
g = GraphicsRow[  { Plot[Ns , {x,-1,1}] ,   Plot[ (Nsp*h/2)// Evaluate, {x,-1,1} ] }] ; 
Kelem=EA*Integrate[Outer[Times,Nsp,Nsp],{x,-1,1}]*h/2 ;
Melem=rhoA*Integrate[Outer[Times,Ns,Ns],{x,-1,1}] * h/2 ; 
];
If[ type == "TN",   (*spectral truss element with many Gau\[SZ]-Lobatto nodes and C0 continuity *)
{points, weights, Ns, Nsp } =  getLobattoShapes[nN,h]  ; 
g = GraphicsRow[  ( Plot[Ns[[#]] , {x,-1,1}] & /@ Range[nN]  )// Evaluate ]  ;   
Kelem=EA*eIntegrate[Outer[Times,Nsp,Nsp],   points, weights,h] ;
Melem=rhoA*eIntegrate[Outer[Times,Ns,Ns],    points, weights,h ] ;
];
 Celem = 0*Kelem + 0*Melem; (*Rayleigh damping*)
{Kelem, Melem, Celem, Nsp // Simplify } 
]; (*---------------------------------------------------------------------*)

aggregateElements[elementData_,   nelem_, Kelem_, Melem_, Celem_, lumpedMass_ ] := Module[{type,  nN, h,  EA, rhoA, ndofs,e,o,nBC1,nBC2}, 
 {type,  nN, h,  EA, rhoA }  = elementData; 
nBC1 = 1; 
If[ type == "T2", 
 ndofs=nelem+1; 
  nBC2= ndofs; 
Kglob=(Mglob=Array[0&,{ndofs, ndofs}]);Cglob = Kglob; 
Do[Kglob[[e;;e+1,e;;e+1]]+=Kelem;
   Mglob[[e;;e+1,e;;e+1]]+=Melem;
    Cglob[[e;;e+1,e;;e+1]]+=Celem;
   ,{e,1,nelem} ];
 ];
If[ type == "T2H", 
ndofs=(nelem+1)*2 ; 
nBC2= ndofs-1; 
Kglob=(Mglob=Array[0&,{ndofs, ndofs}]); Cglob = Kglob; 
Do[Kglob[[2*e -1 ;; 2*e +2     ,  2*e -1;;2*e+2]]+=Kelem;
Mglob[[2*e -1 ;; 2*e +2     ,  2*e -1;;2*e+2]]+=Melem;
Cglob[[2*e -1 ;; 2*e +2     ,  2*e -1;;2*e+2]]+=Celem;
,{e,1,nelem} ]; 
]; 
If[ type == "TN", 
ndofs= 1+nelem* (nN-1); 
 nBC2= ndofs; 
Kglob=(Mglob=Array[0&,{ndofs, ndofs}]); Cglob = Kglob; 
Do[ o = (nN-1)*(e-1) ; 
Kglob[[o+1;;o+nN    ,  o+1;;o+nN]]+=Kelem;
Mglob[[o+1;;o+nN    ,  o+1;;o+nN]]+=Melem;
Cglob[[o+1;;o+nN    ,  o+1;;o+nN]]+=Celem;
,{e,1,nelem}];
  ]; 
If[lumpedMass,Mglob=DiagonalMatrix[Plus@@#&/@Mglob]]; 
{nelem, ndofs , nBC1, nBC2} 
]; (*---------------------------------------------------------------------*)

smoothPulse[t_, tPeriod_] := If[ t< tPeriod, 1000* 0.25*(1-Cos[2*Pi*t /tPeriod])^2 , 0 
];  (*---------------------------------------------------------------------*)

smoothWave[t_, tPeriod_] :=  If[ t< tPeriod,  1000* Sin[2*Pi*t/tPeriod]*(1-((t -tPeriod/2)/(tPeriod/2))^6)^2, 0 (*apodization*)
] ;   (*---------------------------------------------------------------------*)

initialize[  meshBC_ , newmark_ ,tempo_] := Module[ {b1,b2,a,nelem,ndofs,nBC1,nBC2,MatrInv,dt,tPeriod,tE,method }, 
{nelem,ndofs, nBC1,nBC2 } = meshBC; 
{b1,b2,a,method} = newmark; 
{dt,tPeriod,tE} = tempo; 

Ub1 =  Array[ 0&, {ndofs,3}]; (* U,dU,ddU at time t_n+1 *)
Ub=  Array[ 0&, {ndofs,3}];   (* U,dU,ddU at time t_n *)
dUb =  Array[ 0&,  ndofs ];
UbE=  Array[ 0&, {ndofs,3}];   (* UE,dUE,ddUE extrapolators *)
Fb  = Array[0&, ndofs] ;    
Fbint = Array[0&, ndofs] ;        
Uhist = { Ub1 };   
Kglob[[nBC2,nBC2]]+=  Kglob[[1,1]]*10^6;    (*a support via penalty *) 
If[method =="GN22acc", MatrInv =  Inverse[  Mglob  + b1*dt*Cglob + dt^2 *b2/2  * Kglob ] ]; (* if acceleration is the primary unknown *)
If[method =="GN22disp", MatrInv = Inverse[  Mglob *2/(b2*dt^2) +  Cglob *2 *b1/(b2*dt) +  Kglob ];  ]; (* if acceleration is the primary unknown *)(* if displ. driven *)
If[method =="GN22dispStress", MatrInv = Inverse[  Mglob *2/(b2*dt^2) +  Cglob *2 *b1/(b2*dt) +  Kglob ];  ]; (* if acceleration is the primary unknown *)(* if displ. driven *)
If[method =="HHTdisp", MatrInv = Inverse[   Mglob *2/(b2*dt^2) +  (1+a) *Cglob *2 *b1/(b2*dt) + (1+a) *Kglob ] ]; 
If[method =="HHTdispStress", MatrInv = Inverse[   Mglob *2/(b2*dt^2) +  (1+a) *Cglob *2 *b1/(b2*dt) + (1+a) *Kglob ] ]; 
MatrInv 
] ; (*---------------------------------------------------------------------*)

increment[ MatrInv_, t_,   meshBC_, newmark_, tempo_, elementData_,  Belem_ ] := Module[
                        {nelem, ndofs, nBC1, nBC2,b1,b2,a,dt,tPeriod,tE,  type,  nN, h,  EA, rhoA , method,FbE, Fbint, ndofn ,stress,o ,Ubaux}, 
{nelem, ndofs, nBC1,nBC2 } = meshBC;
{b1,b2,a,method} = newmark; 
{dt,tPeriod,tE} = tempo; 
{type,  nN, h,  EA, rhoA } = elementData ; 

Ub = Uhist[[-1]]; 
Fb[[ nBC1 ]] = smoothWave[t  , tPeriod]; 
If[method == "GN22acc", 
Fb[[ nBC1 ]] = smoothWave[t  , tPeriod]; 
UbE[[All,1 ]] =     Ub[[All,1 ]]  + dt* Ub[[All,2 ]] + dt^2*(1-b2)/2*  Ub[[All,3 ]]  ; 
UbE[[All,2 ]] =     Ub[[All,2 ]]  + dt*(1-b1)* Ub[[All,3 ]]  ; 
Fb[[ nBC1 ]] = smoothWave[t , tPeriod]; 
Ub1[[All,3]] = MatrInv.( Fb - Kglob. UbE[[All,1]] - Cglob.   UbE[[All,2]] ) ; 
Ub1[[nBC2 ,3]] = 0;  (* correction for unprecise penalty *)
Ub1[[All,1]]  = UbE[[All,1]] + dt^2 *b2 / 2 *  Ub1[[All,3]] ;
Ub1[[All,2]] =  UbE[[All,2]] + dt  *b1 * Ub1[[All,3]] ;
];
If[method == "GN22disp", 
Fb[[ nBC1 ]] = smoothWave[t  , tPeriod]; 
UbE[[All,1 ]] =     Ub[[All,1 ]]  ; 
UbE[[All,2 ]] =    (b2 - 2 *b1)/b2*  Ub[[All,2 ]]  + (b2- b1)/b2*dt* Ub[[All,3 ]]  ; 
UbE[[All,3 ]] =      - 2 /(b2*dt)*  Ub[[All,2 ]]  + (b2- 1)/b2* Ub[[All,3 ]]  ; 
dUb[[All]] = MatrInv.( Fb - Kglob. UbE[[All,1]] - Cglob.   UbE[[All,2]]  - Mglob.  UbE[[All,3]] ) ;
dUb[[nBC2]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,1]] = UbE[[All,1]] + dUb[[All]];
Ub1[[All,2]]  = UbE[[All,2]] +2 *b1/(b2*dt) * dUb[[All]];
Ub1[[All,3]] =  UbE[[All,3]] + 2 /(b2*dt^2)  *dUb[[All]]  ;
];

If[method == "GN22dispStress", 
If[type=="TN" , Print[" TN with GN22dispStress not implemented as yet"]; Abort[] ] ; 
Fb[[ nBC1 ]] = smoothWave[t  , tPeriod];  
UbE[[All,1 ]] =     Ub[[All,1 ]]  ; 
UbE[[All,2 ]] =    (b2 - 2 *b1)/b2*  Ub[[All,2 ]]  + (b2- b1)/b2*dt* Ub[[All,3 ]]  ; 
UbE[[All,3 ]] =      - 2 /(b2*dt)*  Ub[[All,2 ]]  + (b2- 1)/b2* Ub[[All,3 ]]  ; 

FbE = Cglob.   UbE[[All,2]]  + Mglob.  UbE[[All,3]] ;  (* contribution from extrapolators *) 
If[type=="T2H", ndofn=2 ];   If[type=="T2", ndofn=1 ];  (* dofs per node *)    
Fbint = Array[0&, ndofs];  (* internal forces*)   
Do[ o = (ie-1)*ndofn  ; 
uele = UbE[[ o+1 ;; o+2*ndofn, 1]] ; 
stress = EA* Belem .  uele;  (* stress is a scalar function of x here *)
Fbint[[ o+1 ;; o+2*ndofn ]] += eInt[ Belem *stress , h ]; 
,{ie,1,nelem} ]; 
dUb[[All]] = MatrInv.( Fb - Fbint - FbE ) ;
dUb[[nBC2]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,1]] = UbE[[All,1]] + dUb[[All]];
Ub1[[All,2]]  = UbE[[All,2]] +2 *b1/(b2*dt) * dUb[[All]];
Ub1[[All,3]] =  UbE[[All,3]] + 2 /(b2*dt^2)  *dUb[[All]]  ;
];

If[method =="HHTdisp",
Fb[[ nBC1 ]] = smoothWave[t + a*dt , tPeriod]; 
UbE[[All,1 ]] =     Ub[[All,1 ]]  ; 
UbE[[All,2 ]] =    (b2 - 2 *b1)/b2*  Ub[[All,2 ]]  + (b2- b1)/b2*dt* Ub[[All,3 ]]  ; 
UbE[[All,3 ]] =      - 2 /(b2*dt)*  Ub[[All,2 ]]  + (b2- 1)/b2* Ub[[All,3 ]]  ; 
dUb[[All]] = MatrInv.( Fb - Kglob. ((1+a)  UbE[[All,1]] - a*  Ub[[All,1 ]])
                                           - Cglob.  ((1+a) UbE[[All,2]]  -a* Ub[[All,2 ]]   ) 
                                           - Mglob. ( UbE[[All,3]]                            ) );
dUb[[nBC2]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,1]] = UbE[[All,1]] + dUb[[All]]; 
Ub1[[nBC2,1]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,2]]  = UbE[[All,2]] +2 *b1/(b2*dt) * dUb[[All]];
Ub1[[All,3]] =  UbE[[All,3]] + 2 /(b2*dt^2)  *dUb[[All]]  ; 
];


 
If[method =="HHTdispStress",
If[type=="TN" , Print[" TN with HHTdispStress not implemented as yet"]; Abort[] ] ; 
Fb[[ nBC1 ]] = smoothWave[t + a*dt , tPeriod]; 
UbE[[All,1 ]] =     Ub[[All,1 ]]  ; 
UbE[[All,2 ]] =    (b2 - 2 *b1)/b2*  Ub[[All,2 ]]  + (b2- b1)/b2*dt* Ub[[All,3 ]]  ; 
UbE[[All,3 ]] =      - 2 /(b2*dt)*  Ub[[All,2 ]]  + (b2- 1)/b2* Ub[[All,3 ]]  ; 


FbE = Cglob.  ((1+a) UbE[[All,2]]  -a* Ub[[All,2 ]] )  + Mglob.  UbE[[All,3]]   ;    (* contribution from extrapolators *) 
If[type=="T2H", ndofn=2 ];   If[type=="T2", ndofn=1 ];  (* dofs per node *)    
Fbint = Array[0&, ndofs];  (* internal forces*)  
Ubaux =  (1+a)  UbE[[All,1]] - a*  Ub[[All,1 ]] ;  
Do[ o = (ie-1)*ndofn  ; 
uele = Ubaux[[ o+1 ;; o+2*ndofn]] ; 
stress = EA* Belem .  uele;  (* stress is a scalar function of x here *)
Fbint[[ o+1 ;; o+2*ndofn ]] += eInt[ Belem *stress , h ]; 
,{ie,1,nelem} ]; 

dUb[[All]] = MatrInv.( Fb - Fbint - FbE ) ;

dUb[[nBC2]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,1]] = UbE[[All,1]] + dUb[[All]]; 
Ub1[[nBC2,1]] = 0;  (* correction for unprecise penalty at the last node *)
Ub1[[All,2]]  = UbE[[All,2]] +2 *b1/(b2*dt) * dUb[[All]];
Ub1[[All,3]] =  UbE[[All,3]] + 2 /(b2*dt^2)  *dUb[[All]]  ; 
];


AppendTo[Uhist, Ub1];
];  (*---------------------------------------------------------------------*)




End[]
EndPackage[  ];

$Context = "FEM`dynamics`";

Protect[aggregateElements, getElement , eIntegrate, getLobattoShapes    ];
 
 Print[ " You  are in the context dynamics. It provides: 
          aggregateElements, getElement , eIntegrate, getLobattoShapes 
 "   ]; 

