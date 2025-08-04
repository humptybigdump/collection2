classdef force
    properties
        name = "void_force"
        type = "none"
        g    = 9.81;
        gdir = [0;0;-1];
        im1
        im2
        c    = 1;
        d    = 1;
        F0   = 0;
        l0   = 0;
        color = [0.6 0.6 0.6];
        initialVertices
        str0
        patch
        visible = true;
    end
    methods
        function FT = calculateForceAndTorque(forceobj,modelobj,t,y)
            FT = zeros(6*length(modelobj.bodyobj),1);
            switch forceobj.type
                case "none"
                case "gravity"
                    for i1=1:length(modelobj.bodyobj)
                        FT((6*(i1-1)+1):(6*(i1-1)+3)) = modelobj.bodyobj(i1).m*forceobj.g*forceobj.gdir/norm(forceobj.gdir);
                    end
                case "springdamper"
                    r1  = modelobj.markerobj(forceobj.im1).getPosition(modelobj,y);
                    r2  = modelobj.markerobj(forceobj.im2).getPosition(modelobj,y);
                    v1  = modelobj.markerobj(forceobj.im1).getVelocity(modelobj,y);
                    v2  = modelobj.markerobj(forceobj.im2).getVelocity(modelobj,y);
                    dr = norm(r2-r1);
                    if dr>0
                      ib1 = modelobj.markerobj(forceobj.im1).ib;
                      ib2 = modelobj.markerobj(forceobj.im2).ib;
                                           
                      % Calculate the Forces and Torques
                      Fc  = (forceobj.c*(dr-forceobj.l0)-forceobj.F0)*(r2-r1)/dr;
                      Fd  = (forceobj.d*(v2-v1));
                      if ib1>0 % Application body
                        rs1 = modelobj.bodyobj(ib1).getPosition(ib1,y); 
                        % Force (inertial frame)
                        FT((6*(ib1-1)+1):(6*(ib1-1)+3)) =   Fc+Fd;
                        % Torque (body frame)
                        FT((6*(ib1-1)+4):(6*(ib1-1)+6)) =   QuadRotation(cross((r1-rs1), Fc+Fd).', ...
                                                            [y(((ib1-1)*7+4)) -y(((ib1-1)*7+5):((ib1-1)*7+7)).']).';
                      end
                      if ib2>0 % Reaction body
                        rs2 = modelobj.bodyobj(ib2).getPosition(ib2,y);
                        % Force (inertial frame)
                        FT((6*(ib2-1)+1):(6*(ib2-1)+3)) =  -Fc-Fd;
                        % Torque (body frame)
                        FT((6*(ib2-1)+4):(6*(ib2-1)+6)) =   QuadRotation(cross((r2-rs2), -Fc-Fd).', ...
                                                            [y(((ib2-1)*7+4)) -y(((ib2-1)*7+5):((ib2-1)*7+7)).']).';
                      end
                    end
            end
            
        end
        function forceobj = plotForce(forceobj,modelobj)
            switch forceobj.type
                case "none"
                case "gravity"
                case "springdamper"
                    forceobj = plotSpring(forceobj,modelobj);
            end
        end
        function forceobj = updatePlotForce(forceobj,resultobj,modelobj,i1,frame)
            switch forceobj.type
                case "none"
                case "gravity"
                case "springdamper"
                    r1 = modelobj.markerobj(modelobj.forceobj(i1).im1).getPosition(modelobj,resultobj.y(frame,:).');
                    r2 = modelobj.markerobj(modelobj.forceobj(i1).im2).getPosition(modelobj,resultobj.y(frame,:).');
                    forceobj = updatePlotSpring(forceobj,r1,r2,frame);
            end
        end
    end
end