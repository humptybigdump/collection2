%% Exercise 4: Extreme value statistics. Water and Energy Cycles 23/24
% Follow the comments and advices in the code and on the exercise sheet.
% In this exercise, you have to do more coding on your own. It is
% recommended to use the help documentation of MATLAB to get information
% about the syntax of functions and how they are used.
%% Task 1: Import of data, initial analysis
% read in text file with year and HQ value as table
table_data = readtable('data\HQ_Elbe_Extreme.txt');

% define separate arrays for HQ and year extracted from table
HQ = table2array(table_data(:,{'HQ'}));
year = table2array(table_data(:,{'year'}));

% plot of HQ time series (as circles: 'o'; check help documentation for different line styles and line colours)
figure
    'INSER PLOT OF HQ OVER THE YEARS AS CIRCLES'
xlabel('year');
ylabel('HQ [m/s]');
title('HQ time series')

% basic statistics of HQ time series (use functions: max, min, median)
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

%% Task 2: Generate and plot a histogram of HQ data
% define an array from 0 to 'max(HQ)' with step/bin size 100; this array
% defines the left and right edges of all bins for the histogram plot
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% plot histogram (function: "histogram")
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

%% Task 3: Generate and plot an empirical, cumulative distribution function (ecdf)
% Step 1:sort HQ values from small to large values by function "sort" ("sorted_HQ")
	'INSERT YOUR CODE FOLLOWING THE COMMENT'

% Step 2: calculate frequencies of observed HQ values with Eq.1; each sorted HQ value gets a certain frequency
% , e.g. smallest HQ value gets the frequency = 1/N , and the highest HQ value gets the frequency = N/N (= 1).
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% Step 3: plot ecdf (again as circles 'o')
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

%% Task 4: Generate theoretical, cumulative distribution function (tcdf) with "Normal","Gamma","Weibull" distribution
% Normal distribution (no approximation, it uses mean and STD of HQ data)
% Step 1: use function "fitdist" (check help documentation) to fit a normal cdf to sorted HQ data to find mean and standard deviation as input for generating a normal cdf
% look into the created object and its parameter values
	normal_cdf_fit = 'INSERT YOUR CODE FOLLOWING STEP 1'
 
% Step 2: identify mean (mu) as first input parameter for creating normal cdf, and standard deviation (sigma) as second input parameter for creating normal cdf  
% example for extracting a property out of a distribution function object: "normal_cdf_fit.mu"    
    sorted_HQ_mean = 'INSERT YOUR CODE FOLLOWING STEP 2'
    sorted_HQ_STD = 'INSERT YOUR CODE FOLLOWING STEP 2'

% Step 3: create normal cdf with function "cdf" and selected parameters
% from Step 2
    normal_cdf = 'INSERT YOUR CODE FOLLOWING STEP 3'

% Gamma distribution (maximum likelihood approximation to generate a and b
% parameter)
% do the same 3 steps as before!
    gamma_cdf_fit = 'INSERT YOUR CODE FOLLOWING STEP 1'

    a_Gamma = 'INSERT YOUR CODE FOLLOWING STEP 2'
    b_Gamma = 'INSERT YOUR CODE FOLLOWING STEP 2'

    gamma_cdf = 'INSERT YOUR CODE FOLLOWING STEP 3'

% Weibull distribution(maximum likelihood approximation to generate a and b
% parameter)
% do the same 3 steps as before!
    weibull_cdf_fit = 'INSERT YOUR CODE FOLLOWING STEP 1'

    a_Weibull = 'INSERT YOUR CODE FOLLOWING STEP 2'
    b_Weibull = 'INSERT YOUR CODE FOLLOWING STEP 2'

    weibull_cdf = 'INSERT YOUR CODE FOLLOWING STEP 3'

% plot all three tcdf, together with the ecdf for comparison
figure
plot(sorted_HQ, PE,'o');  %ecdf
xlabel('HQ [m/s]')
ylabel('frequencies')
hold on
    'INSERT PLOT OF sorted_HQ AND NORMAL CDF AS RED LINE'
    'INSERT PLOT OF sorted_HQ AND GAMMA CDF AS GREEN LINE'
    'INSERT PLOT OF sorted_HQ AND WEIBULL CDF AS BLACK LINE'
title('Fit of three tcdf to ecdf')
legend('ecdf','normal tcdf','gamma cdf','weibull cdf')

%% Task 5: Compute flood return periods RP
% use Eq. 2 to calculate RP for ecdf (PE from task 3) and for the three tcdf
% (from task 4)
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% plot of return periods computed based on ecdf and tcdf in one plot
figure
    'INSERT PLOT OF sorted_HQ AND RP OF ECDF/PE AS CIRCLES'
set(gca, 'YScale', 'log')
xlabel('HQ (m/s)')
ylabel('return period [a]')
hold on
    'INSERT PLOT OF sorted_HQ AND RP OF NORMAL CDF AS RED LINE'
    'INSERT PLOT OF sorted_HQ AND RP OF GAMMA CDF AS GREEN LINE'
    'INSERT PLOT OF sorted_HQ AND RP OF WEIBULL CDF AS BLACK LINE'
yline(1000)
legend('ecdf','normal tcdf','gamma cdf','weibull cdf','HQ 1000')