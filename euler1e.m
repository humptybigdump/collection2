function [t_,y_,varargout] = euler1e(fFun_,tSpan_,y0_,h_)
    % A function integrates an ODE using an explicit Euler method of order 1. Mimicks call to ode45.
    arguments
        fFun_         (1,1) function_handle % right-hand-side of ODE
        tSpan_        (1,:) double {mustBeNumeric,mustBeReal} % time span
        y0_           (:,1) double {mustBeNumeric,mustBeReal} % initial condition of IVP
        h_            (1,1) double {mustBeNumeric,mustBeReal} % step size
    end
    t = tSpan_(1):h_:tSpan_(end);
    y = zeros(length(y0_),length(t));
    y(:,1) = y0_;
    for kk = 1:length(t)-1
        xk = y(:,kk);
        tk = t(kk);
        [k1,varargout{1:nargout-2}] = fFun_(tk,xk);
        y(:,kk+1) = xk + h_*k1;
    end
    if nargout > 2
        % multiply Jacobians by h_
        varargout = cellfun(@(y_)y_*h_,varargout,'un',0);
        % add eye(nx) to first entry in cell array
        varargout{1} = varargout{1} + eye(length(y0_));
    end
    % if tSpan has more than two entries, interpolate the solution at the times in tSpan
    if length(tSpan_) > 2
        t_ = tSpan_.';
        y_ = interp1(t,y.',tSpan_,'linear','extrap');
    else
        t_ = t.';
        y_ = y.';
    end
end
