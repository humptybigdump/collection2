function dy = dynamic_ode(t,y,simobj,modelobj)
global transfer

clc
disp("Solving... "+round(t/simobj.tspan(end)*100)+"%")


nKINEM = 7*length(modelobj.bodyobj);
nKINET = 6*length(modelobj.bodyobj);
f = zeros(nKINEM+nKINET,1);
% Normalize q
for i1=1:length(modelobj.bodyobj)
 y(((i1-1)*7+4):((i1-1)*7+7)) = y(((i1-1)*7+4):((i1-1)*7+7))/norm(y(((i1-1)*7+4):((i1-1)*7+7)));
end


for i1=1:length(modelobj.bodyobj)
    % Kinematics
    v       = y((nKINEM+(i1-1)*6+1):(nKINEM+(i1-1)*6+3));
    omega_k = y((nKINEM+(i1-1)*6+4):(nKINEM+(i1-1)*6+6));
    f((i1-1)*7+1:i1*7)  = [v;
        0.5*[0         -omega_k.';
        omega_k        -CrossMat(omega_k)]*y(((i1-1)*7+4):((i1-1)*7+7))];
    % Kinematic Constraint
    % f(i1*7) = y((i1-1)*7+4)^2+y((i1-1)*7+5)^2+y((i1-1)*7+6)^2+y((i1-1)*7+7)^2-1;
    % Kinetics
    f((nKINEM+6*(i1-1)+1):(nKINEM+6*(i1-1)+6)) = [zeros(3,1);
        -CrossMat(omega_k)*modelobj.bodyobj(i1).J*omega_k];
end
f((nKINEM+1):(nKINEM+nKINET)) = f((nKINEM+1):(nKINEM+nKINET)) + modelobj.calculateForceAndTorque(t,y);
dy = f;

g      = simulation.calculateg(modelobj,t,y);
gDot   = simulation.calculategDot(modelobj,t,y);
gDdot  = simulation.calculategDdot(modelobj,t,y,dy);

transfer.t      = t;
transfer.g      = g;
transfer.gDot   = gDot;
transfer.gDdot  = gDdot;
end