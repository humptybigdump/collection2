%% Water and Energy Cycles. WS 20/21
%% Exercise 10: Soil hydraulic functions
%% Task 1: Generating soil water retention and soil hydraulic conductivity curves of three soils
% select soil hydraulic parameters from Table 1 and save them to separate
% variables
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% define array with soil water contents from thr to ths with delta_theta step
% size of 10^-7. For the theta values in this array, you subsequently
% calculate the corresponding k(theta) and psi(theta) values
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% initialize/preallocate arrays for k(theta) and psi(theta) 
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'  

% Calculate psi with converted Eq. 1
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Calculate k with Eq. 2
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Calculation of effetive field capacity of soil:
% definition of psi (m) at PWP and FC
    psi_PWP = 150;
    psi_FC = 0.68;

% first, calculate relative saturation S at PWP
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% second, calculate soil water content theta at PWP
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% third, calculate relative saturation S at FC
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% fourth, calculate soil water content theta at FC
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% sixth, calculate effective field capacity with Eq. 3
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot soil water retention curve and soil hydraulic conductivity curve
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 2: Sensitivity of soil water retention curves of different soils to alpha
% select soil hydraulic parameters from Table 1 and save them to separate variable
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% initialize Monte-Carlo algorithm
% set number of MC runs
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% create array with randomly distributed alpha values between an upper and
% lower limit
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% define array with soil water content from thr to ths with delta_theta step
% size of now 0.01. For the theta values in this array, you subsequently
% calculate the corresponding k(theta) and psi(theta) values
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'    
        
% initialize/preallocate arrays for k(theta) and psi(theta) 
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% initialize arrays to store result (theta, psi) of each MC run
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% start MC loop:
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
    
    % in MC loop: select next alpha value from predefined random distribution
        'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
    
    % in MC loop: calculate m
        'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

    % in MC loop: calculate psi using Eq. 1 (see procedure above)
        'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'


% after MC loop: plot soil water retention curves for diferent alpha
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
