classdef ESN < handle
    %
    % Class: Echo state network
    %
    %  Description:
    %          Class to set up, train and perform predictions using echo state networks
    %
    %  Specials:
    %          The class is derived from https://github.com/stefanonardo/echo-state-network
    %          and modified by performing Certain modifications and corrections.
    %
    %  Authors: Thomas Meurer (KIT)
    %  Email: thomas.meurer@kit.edu
    %  Website: https://www.mvm.kit.edu/dpe.php
    %  Creation date: 02.02.2024
    %  Last revision date: 03.02.2024
    %  Last revision author: Thomas Meurer (KIT)
    %
    %  Copyright (c) 2024, DPE/MVM, KIT
    %  All rights reserved.
    %
    properties
        nreservoir 
        alpha
        rho
        inputScaling
        biasScaling
        lambda
        connectivity
        readout_training
        Win
        Wyin
        Wb
        W
        Wout
        internalState
    end
    %
    methods
        function esn = ESN(nreservoir, varargin)
        % Constructor
        %
        % Inputs:
        %   nreservoir            ... number of state of the reservoir
        %   
        % Optional arguments:
        %   'leakageRate'         ... leakage rate
        %   'spectralRadius'      ... spectral radius
        %   'inputScaling'        ... input weights scale 
        %   'biasScaling'         ... bias weights scale 
        %   'regularization'      ... regularization parameter
        %   'connectivity'        ... reservoir connectivity
        %   'readoutTraining'     ... function used to determine Wout for readout
        
            %Default values
            esn.nreservoir       = nreservoir;
            esn.alpha            = 1;
            esn.rho              = 0.9;
            esn.inputScaling     = 1;
            esn.biasScaling      = 1;
            esn.lambda           = 1;
            esn.connectivity     = 1; 
            esn.readout_training = 'ridgeregression';
            
            numvarargs = length(varargin);
            for i = 1:2:numvarargs
                switch varargin{i}
                  case 'leakRate', esn.alpha = varargin{i+1};
                  case 'spectralRadius', esn.rho = varargin{i+1};
                  case 'inputScaling', esn.inputScaling = varargin{i+1};
                  case 'biasScaling', esn.biasScaling = varargin{i+1};
                  case 'regularization', esn.lambda = varargin{i+1};
                  case 'connectivity', esn.connectivity = varargin{i+1};
                  case 'readoutTraining', esn.readout_training = varargin{i+1};
                  otherwise, error('the option does not exist');
                end
            end
        end
        %
        function train(esn, inputData, outputData, washout)
        % Train of the reservoir using inputData and outputData
        %
        % Inputs:
        %   inputData  ... Matrix of input values (rows must correspond to individual inputs)
        %   outputData ... Matrix of corresponding output values
        %   washout    ... Number of time steps to be discarded during initialization
            
            inputDim  = size(inputData,1);
            trainLen  = size(outputData,2);

            % Initialize matrices Win and W as well as bias vector Wb
            esn.Win = esn.inputScaling * (rand(esn.nreservoir, inputDim) * 2 - 1);
            esn.Wb  = esn.biasScaling * (rand(esn.nreservoir, 1) * 2 - 1);
            esn.W   = full(sprand(esn.nreservoir,esn.nreservoir, esn.connectivity));

            % Impose connectivity on W
            esn.W(esn.W ~= 0) = esn.W(esn.W ~= 0) * 2 - 1;
            % Impose desired spectral radius on W
            esn.W  = esn.W * (esn.rho / max(abs(eig(esn.W))));

            % Pass data through reservoir and collect the states of the reservoir over time
            X   = zeros(1+inputDim+esn.nreservoir, trainLen-washout);
            Y   = outputData(:,washout+1:end);
            %Y   = outputData(:,1:end-washout);
            idx = 1;
            x   = zeros(esn.nreservoir,1);
            
            for i = 1:trainLen
                u = inputData(:,i);
                x = reservoir_update(esn,x,u);
                if i > washout
                    X(:,idx) = [1;u;x];
                    idx = idx+1;
                end
            end
            esn.internalState = X((1+inputDim+1):end,:);
            
            % Evaluate readout training method 
            esn.Wout = feval(esn.readout_training, X, Y, esn);
        end
        %
        function y = predict(esn, inputData, washout)
        % Predict the output for given input data
        %
        % Inputs:
        %   inputData ... Matrix of input values (rows must correspond to individual inputs)
        %   washout   ... Number of time steps to be discarded during initialization
        %
        % Outputs:
        %   y         ... Predicted output from pre-trained reservoir
            
            inputDim = size(inputData,1);
            testLen  = size(inputData,2); 
            testLen  = testLen - washout;
            
            X = zeros(1+inputDim+esn.nreservoir, testLen);
            idx = 1;
            U = inputData;
            x = zeros(esn.nreservoir,1);

            % Pass data through reservoir and collect the states of the reservoir over time
            for i = 1:size(U,2)
                u = U(:,i);
                x = reservoir_update(esn,x,u);
                if i > washout
                    X(:,idx) = [1;u;x];
                    idx = idx+1;
                end
            end
            esn.internalState = X(1+inputDim+1:end,:);

            % Evaluate readout to compute the predicted output
            y = esn.Wout*X;
            y = y';
        end
        %
        function out = reservoir_update(esn, x, u)
        % Compute the reservoir update
        %
        % Inputs:
        %   x    ... State of reservoir at time step k-1
        %   u    ... Input at time step k 
        %
        % Outputs:
        %   out  ... State of reservoir at time step k
            
            xup = tanh(esn.Win*u + esn.W*x + esn.Wb);
            out = (1-esn.alpha)*x + esn.alpha*xup;            
        end
        %
    end
end
