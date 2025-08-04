function g = gEq(x,modelobj)
y = [x;zeros(6*length(modelobj.bodyobj),1)];
g = [];
for i1=1:length(modelobj.jointobj)
    g  = [g; modelobj.jointobj(i1).calculateConstraint(modelobj,0,y)];
end
if length(modelobj.jointobj) == 1 && modelobj.jointobj(1).type == "none"
    g = 0;
end
end