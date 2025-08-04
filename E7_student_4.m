%% Exercise 7: Extreme value statistics. Water and Energy Cycles 20/21
% In this exercise, you are supposed to do the entire coding on your own!
% Follow the comments and advices in the code and on the exercise sheet.
%% Task 1: Import of data initial analysis
% read in data text file with year and HQ value as table
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% define separate arrays for HQ and year extracted from table
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot of HQ time series 
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% basic statistics of HQ time series (functions: max, min, median)
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 2: Generate and plot a histogram of HQ data
% define an array from 0 to max HQ with bin size 100; gives the left and right edges of all bins (= 46)
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot histogram
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 3: Generate and plot an empirical, cumulative distribution function (ecdf)
% Step 1:sort HQ values from small to large values ("sorted_HQ")
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 2: calculate frequencies of observed HQ values with Eq.1; each sorted HQ value gets a certain frequency
% , e.g. smallest HQ value gets the frequency = 1/N , and the highest HQ value gets the frequency = N/N (= 1).
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 3: plot ecdf
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 4: Generate theoretical, cumulative distribution function (tcdf) with "Normal","Gamma","Weibull" distribution
% Normal distribution (no approximation, uses mean and STD of HQ data)
% Step 1: function "fitdist" to fit a normal cdf to HQ data to find mean and standard deviation as input for generating a normal cdf
% look into the created object and its parameter values
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
 
% Step 2: mean as first input parameter for creating normal cdf;standard deviation as first input parameter for creating normal cdf  
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 3: creating normal cdf with function "cdf" and selected parameter
% from Step 2
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Gamma distribution (maximum likelihood approximation to generate a and b
% parameter)
% do the same 3 steps as above for Gamma distribution!
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Weibull distribution(maximum likelihood approximation to generate a and b
% parameter)
% do the same 3 steps as above for Weibull distribution!
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot all three tcdf, together with the ecdf for comparison
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 5: Compute flood return periods RP
% use Eq. 2 to calculate RP based on ecdf and the three tcdf
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot of return periods computed based on ecdf and tcdf in one plot
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'