function [dzdt_,varargout] = extendedDynamicsRightHandSideFun(t_,z_,u_,m_)
    % A function that evaluates the right-hand-side of the extended system.
    arguments
        t_            (1,1) double {mustBeNumeric} % time 
        z_            (3,1) double {mustBeNumeric} % extended state z=[x',q]
        u_            (:,:) {mustBeNumericOrStruct} % input
        m_            (1,1) double {mustBeNumeric} % mass of point
    end
    if isstruct(u_)
        u = interp1(u_.time,u_.data.',t_,'previous','extrap').';
    else
        u = u_;
    end
    dqdt = z_(1).^2 + u.^2;
    if nargout == 1
        dxdt = pointMassRightHandSideFun(t_,z_(1:2),u,m_);
    elseif nargout == 2
        [dxdt,dfdx] = pointMassRightHandSideFun(t_,z_(1:2),u,m_);
        dldx = [2*z_(1),zeros(1,length(dxdt)-1)];
        dldq = 0;
        % dfPrimedz = [dfdx,dfdq; dldx,dldq]
        varargout{1} = [dfdx,zeros(1,1);dldx,dldq];
    else
        [dxdt, dfdx, dfdu] = pointMassRightHandSideFun(t_,z_(1:2),u,m_);
        dldx = [2*z_(1),zeros(1,length(dxdt)-1)];
        dldq = 0;
        dldu = 2*u;
        % dfPrimedz = [dfdx,dfdq; dldx,dldq]
        varargout{1} = [dfdx,zeros(2,1);dldx,dldq];
        % dfPrimedu = [dfdu;dldu]
        varargout{2} = [dfdu;dldu];
    end
    dzdt_ = [dxdt;dqdt];
end
