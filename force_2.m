classdef force
    % Improvements: im and ib could be arrays, 
    % different force types in seperate files
    properties
        name = "void_force"
        type = "none"
        g    = 9.81;
        gdir = [0;0;-1];
        im1  
        im2  
        im3
        ib1  
        ib2  
        c    = 0
        cR   = 0;
        lR   = 0;
        d    = 0;
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
                case "gravity"
                    for i1=1:length(modelobj.bodyobj)
                        FT((6*(i1-1)+1):(6*(i1-1)+3)) = modelobj.bodyobj(i1).m*forceobj.g*forceobj.gdir/norm(forceobj.gdir);
                    end
                case "springdamper"                               
                    r1  = modelobj.markerobj(forceobj.im1).getPosition(modelobj,y);
                    r2  = modelobj.markerobj(forceobj.im2).getPosition(modelobj,y);
                    v1  = modelobj.markerobj(forceobj.im1).getVelocity(modelobj,y);
                    v2  = modelobj.markerobj(forceobj.im2).getVelocity(modelobj,y);
                    F = forceobj.calculateSpringForce(r1,r2,v1,v2);
                    
                    ibm1 = modelobj.markerobj(forceobj.im1).ib;
                    ibm2 = modelobj.markerobj(forceobj.im2).ib;
                    if ibm1>0 % Application body
                        rs1 = modelobj.bodyobj(ibm1).getPosition(ibm1,y);
                        % Force (inertial frame)
                        FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) =   F;
                        % Torque (body frame)
                        FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) =   QuadRotation(cross((r1-rs1), F).', ...
                            [y(((ibm1-1)*7+4)) -y(((ibm1-1)*7+5):((ibm1-1)*7+7)).']).';
                    end
                    if ibm2>0 % Reaction body
                        rs2 = modelobj.bodyobj(ibm2).getPosition(ibm2,y);
                        % Force (inertial frame)
                        FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) =  -F;
                        % Torque (body frame)
                        FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) =   QuadRotation(cross((r2-rs2), -F).', ...
                            [y(((ibm2-1)*7+4)) -y(((ibm2-1)*7+5):((ibm2-1)*7+7)).']).';
                    end
                case "bushing"
                    % Reference position - same for both bodies
                    r0 =  modelobj.markerobj(forceobj.im1).r0;
                    % Creating 6 forceelements (springdamper like) around
                    % reference position - leading to a resulting force and
                    % torque element
                    DeltaR = forceobj.lR/2*[eye(3,3)    -eye(3,3)];
                    for i1=1:length(DeltaR(1,:))
                        modelobj.markerobj(forceobj.im1).r0 = r0 + DeltaR(:,i1); 
                        modelobj.markerobj(forceobj.im2).r0 = r0 + DeltaR(:,i1); 
                        r1  = modelobj.markerobj(forceobj.im1).getPosition(modelobj,y);
                        r2  = modelobj.markerobj(forceobj.im2).getPosition(modelobj,y);
                        v1  = modelobj.markerobj(forceobj.im1).getVelocity(modelobj,y);
                        v2  = modelobj.markerobj(forceobj.im2).getVelocity(modelobj,y);
                        F = forceobj.calculateSpringForce(r1,r2,v1,v2)/length(DeltaR(1,:));

                        ibm1 = modelobj.markerobj(forceobj.im1).ib;
                        ibm2 = modelobj.markerobj(forceobj.im2).ib;

                        if ibm1>0 % Application body
                            rs1 = modelobj.bodyobj(ibm1).getPosition(ibm1,y);
                            % Force (inertial frame)
                            FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) = FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) + F;
                            % Torque (body frame)
                            FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) = FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) + QuadRotation(cross((r1-rs1), F).', ...
                                [y(((ibm1-1)*7+4)) -y(((ibm1-1)*7+5):((ibm1-1)*7+7)).']).';
                        end
                        if ibm2>0 % Reaction body
                            rs2 = modelobj.bodyobj(ibm2).getPosition(ibm2,y);
                            % Force (inertial frame)
                            FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) = FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) -F;
                            % Torque (body frame)
                            FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) = FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) + QuadRotation(cross((r2-rs2), -F).', ...
                                [y(((ibm2-1)*7+4)) -y(((ibm2-1)*7+5):((ibm2-1)*7+7)).']).';
                        end
                    end
                case "linearguide"
                    rm0  =  modelobj.markerobj(forceobj.im1).r0; % Reference position at guide center
                    rz0  =  modelobj.markerobj(forceobj.im2).r0; % Reference position along guide axis
                    dr0  = (rz0-rm0)/norm(rz0-rm0); 
                    % Find perpendicular vectors
                    if dr0(3) ~= 0
                        xr0 = [1; 1; -(dr0(1)+dr0(2))/dr0(3)];
                    elseif dr0(2) ~=0
                        xr0 = [1; -(dr0(1)+dr0(3))/dr0(2); 1];
                    else
                        xr0 = [-(dr0(2)+dr0(3))/dr0(1); 1; 1];
                    end
                    xr0 = xr0/norm(xr0);
                    yr0 = cross(xr0,dr0);
                    DeltaR = forceobj.lR/2*[dr0 xr0 yr0 -dr0 -xr0 -yr0];
                    for i1=1:length(DeltaR(1,:))
                        modelobj.markerobj(forceobj.im1).r0 = rm0 + DeltaR(:,i1);
                        modelobj.markerobj(forceobj.im2).r0 = rz0 + DeltaR(:,i1);
                        modelobj.markerobj(forceobj.im3).r0 = rm0 + DeltaR(:,i1);
                        r1  = modelobj.markerobj(forceobj.im1).getPosition(modelobj,y); % Current position at body 1 at center m
                        r2  = modelobj.markerobj(forceobj.im2).getPosition(modelobj,y); % Current position at body 1 along guide axis z
                        r3  = modelobj.markerobj(forceobj.im3).getPosition(modelobj,y); % Current position at body 2 at center m
                        v1  = modelobj.markerobj(forceobj.im1).getVelocity(modelobj,y); % Current velocity at body 1 at center m
                        v3  = modelobj.markerobj(forceobj.im3).getVelocity(modelobj,y); % Current velocity at body 2 at center m
                        F = forceobj.calculateSpringForce(r1,r3,v1,v3)/length(DeltaR(1,:)); % Force acts between centers m at body 1 and 2
                        if norm(r2-r1) > 0 
                          dr = (r2-r1)/norm(r2-r1);
                          F = F-dot(F,dr)*dr; % Substracting the force component along the guide axis
                        end

                        ibm1 = modelobj.markerobj(forceobj.im1).ib;
                        ibm2 = modelobj.markerobj(forceobj.im3).ib;

                        if ibm1>0 % Application body
                            rs1 = modelobj.bodyobj(ibm1).getPosition(ibm1,y);
                            % Force (inertial frame)
                            FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) = FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) + F;
                            % Torque (body frame)
                            FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) = FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) + QuadRotation(cross((r1-rs1), F).', ...
                                [y(((ibm1-1)*7+4)) -y(((ibm1-1)*7+5):((ibm1-1)*7+7)).']).';
                        end
                        if ibm2>0 % Reaction body
                            rs2 = modelobj.bodyobj(ibm2).getPosition(ibm2,y);
                            % Force (inertial frame)
                            FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) = FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) -F;
                            % Torque (body frame)
                            FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) = FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) + QuadRotation(cross((r3-rs2), -F).', ...
                                [y(((ibm2-1)*7+4)) -y(((ibm2-1)*7+5):((ibm2-1)*7+7)).']).';
                        end
                    end
                case "rotationalguide"
                    rm0  =  modelobj.markerobj(forceobj.im1).r0; % Reference position at guide center
                    rz0  =  modelobj.markerobj(forceobj.im2).r0; % Reference position along guide axis
                    dr0  = (rz0-rm0)/norm(rz0-rm0); 
                    DeltaR = forceobj.lR/2*[dr0 -dr0];
                    for i1=1:length(DeltaR(1,:))
                        modelobj.markerobj(forceobj.im1).r0 = rm0 + DeltaR(:,i1);
                        %modelobj.markerobj(forceobj.im2).r0 = rz0 + DeltaR(:,i1);
                        modelobj.markerobj(forceobj.im3).r0 = rm0 + DeltaR(:,i1);
                        r1  = modelobj.markerobj(forceobj.im1).getPosition(modelobj,y); % Current position at body 1 at center m
                        % r2  = modelobj.markerobj(forceobj.im2).getPosition(modelobj,y); % Current position at body 1 along axis z
                        r3  = modelobj.markerobj(forceobj.im3).getPosition(modelobj,y); % Current position at body 2 at center m
                        v1  = modelobj.markerobj(forceobj.im1).getVelocity(modelobj,y); % Current velocity at body 1 at center m
                        v3  = modelobj.markerobj(forceobj.im3).getVelocity(modelobj,y); % Current velocity at body 2 at center m
                        F = forceobj.calculateSpringForce(r1,r3,v1,v3)/length(DeltaR(1,:)); % Force acts between centers m at body 1 and 2

                        ibm1 = modelobj.markerobj(forceobj.im1).ib;
                        ibm2 = modelobj.markerobj(forceobj.im3).ib;

                        if ibm1>0 % Application body
                            rs1 = modelobj.bodyobj(ibm1).getPosition(ibm1,y);
                            % Force (inertial frame)
                            FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) = FT((6*(ibm1-1)+1):(6*(ibm1-1)+3)) + F;
                            % Torque (body frame)
                            FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) = FT((6*(ibm1-1)+4):(6*(ibm1-1)+6)) + QuadRotation(cross((r1-rs1), F).', ...
                                [y(((ibm1-1)*7+4)) -y(((ibm1-1)*7+5):((ibm1-1)*7+7)).']).';
                        end
                        if ibm2>0 % Reaction body
                            rs2 = modelobj.bodyobj(ibm2).getPosition(ibm2,y);
                            % Force (inertial frame)
                            FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) = FT((6*(ibm2-1)+1):(6*(ibm2-1)+3)) -F;
                            % Torque (body frame)
                            FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) = FT((6*(ibm2-1)+4):(6*(ibm2-1)+6)) + QuadRotation(cross((r3-rs2), -F).', ...
                                [y(((ibm2-1)*7+4)) -y(((ibm2-1)*7+5):((ibm2-1)*7+7)).']).';
                        end
                    end
            end
                        
                    
        end
        function F = calculateSpringForce(forceobj,r1,r2,v1,v2)
            dr = norm(r2-r1);
            if dr>0
                Fc  = (forceobj.c*(dr-forceobj.l0)-forceobj.F0)*(r2-r1)/dr;
            else
                Fc  = zeros(3,1);
            end
            Fd  = forceobj.d*(v2-v1);
            F = Fc+Fd;
        end    
            

        function forceobj = plotForce(forceobj,modelobj)
            switch forceobj.type
                case "springdamper"
                    forceobj = plotSpring(forceobj,modelobj);
            end
        end
        function forceobj = updatePlotForce(forceobj,resultobj,modelobj,i1,frame)
            switch forceobj.type
                case "springdamper"
                    r1 = modelobj.markerobj(modelobj.forceobj(i1).im1).getPosition(modelobj,resultobj.y(frame,:).');
                    r2 = modelobj.markerobj(modelobj.forceobj(i1).im2).getPosition(modelobj,resultobj.y(frame,:).');
                    forceobj = updatePlotSpring(forceobj,r1,r2,frame);
            end
        end

        function modelobj = force_init(forceobj,i1,modelobj)
            switch forceobj.type
                case "bushing" 
                    % Creating body fixed markers for the bushing
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_bushing_body_1";
                    modelobj.markerobj(end).ib      = forceobj.ib1;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im1       = length(modelobj.markerobj);

                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_bushing_body_2";
                    modelobj.markerobj(end).ib      = forceobj.ib2;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im2       = length(modelobj.markerobj);

                    % Calculating the force application point distance lR
                    % from the rotational Stiffness cR
                    if forceobj.c > 0
                     modelobj.forceobj(i1).lR = sqrt((forceobj.cR*180/pi)/(2*forceobj.c)); 
                    end
                case "linearguide"
                    % The linearguide needs three markers - two on body 1
                    % for the center m of the guide (im1) and the direction z of
                    % the guide axis (im2), and one on body 2 at the center
                    % m of the guide (im3)
                    % -> the guide axis is fixed to body 1

                    % Marker at body 1 at center m of the guide 
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_linearguide_body_1_m";
                    modelobj.markerobj(end).ib      = forceobj.ib1;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im1       = length(modelobj.markerobj);
                    % Marker im2 at body 1 along axis z of the guide 
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im2);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im2).name+"_linearguide_body_1_z";
                    modelobj.markerobj(end).ib      = forceobj.ib1;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im2       = length(modelobj.markerobj);
                    % Marker im3 at body 2 at center m of the guide
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_linearguide_body_2_m";
                    modelobj.markerobj(end).ib      = forceobj.ib2;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im3       = length(modelobj.markerobj);

                    % Calculating the force application point distance lR
                    % from the rotational Stiffness cR
                    if forceobj.c > 0
                     modelobj.forceobj(i1).lR = sqrt((forceobj.cR*180/pi)/(2*forceobj.c)); 
                    end
                case "rotationalguide"
                    % The rotationalguide needs three markers - two on body 1
                    % for the center m of the guide (im1) and the direction z of
                    % the guide axis (im2), and one on body 2 at the center
                    % m of the guide (im3)
                    % -> the guide axis is fixed to body 1

                    % Marker at body 1 at center m of the guide 
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_linearguide_body_1_m";
                    modelobj.markerobj(end).ib      = forceobj.ib1;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im1       = length(modelobj.markerobj);
                    % Marker im2 at body 1 along axis z of the guide 
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im2);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im2).name+"_linearguide_body_1_z";
                    modelobj.markerobj(end).ib      = forceobj.ib1;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im2       = length(modelobj.markerobj);
                    % Marker im3 at body 2 at center m of the guide
                    modelobj.markerobj(end+1)       = modelobj.markerobj(forceobj.im1);
                    modelobj.markerobj(end).name    = modelobj.markerobj(forceobj.im1).name+"_linearguide_body_2_m";
                    modelobj.markerobj(end).ib      = forceobj.ib2;
                    modelobj.markerobj(end).visible = false;
                    modelobj.forceobj(i1).im3       = length(modelobj.markerobj);

                    % Calculating the force application point distance lR
                    % from the rotational Stiffness cR
                    if forceobj.c > 0
                     modelobj.forceobj(i1).lR = sqrt((forceobj.cR*180/pi)/(2*forceobj.c)); 
                    end
            end
        end
    end


end