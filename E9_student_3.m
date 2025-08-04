%% Design of flood-defence reservoir Water and Energy Cycles WS 24/25
% We will work in the catchment Colpach 

% create a string containing the path to the data, folder "data" has to
% be in the same location as this MATLAB script!
file_path_colpach = fullfile([pwd '/data'], 'Colpach.txt');

%% import hydrological time series
% table with all given data
colpach_climate = readtable(file_path_colpach,'Delimiter', ',');

% assigning observed runoff given in mm/h (= L/m^2*hr) to variable
colpach_runoff = table2array(colpach_climate(:,{'runoff_mm_h_'}));

% assigning observed rainfall given in mm/h (= L/m^2*hr) to variable
colpach_precip = table2array(colpach_climate(:,{'precip_mm_h_'}));

% define the date column as data type date 
format_date = 'yyyy-mm-dd HH:MM:SS';
date_vec = table2array(colpach_climate(:,1));
dn = datetime(date_vec,'InputFormat',format_date); % array containing only the dates of time series

% catchment area (m²) of Colpach to convert units
A_catchment_colpach = 1.9e+07; 

%% Task 1: Determine runoff at exceedance probability 1% in Colpach
% generate flow duration curve (cf. exercise 1)
[sorted_runoff_colpach, ranks_colpach] = sort(colpach_runoff,'descend');
prob_colpach = 100 * (ranks_colpach / (length(ranks_colpach) + 1));
sorted_prob_colpach = sort(prob_colpach);

% plot flow duration curve
figure
semilogy(sorted_prob_colpach, sorted_runoff_colpach)
xlabel('exceedance probability')
ylabel('runoff [mm/h]')
legend('colpach')
title('Flow duration curve')
    
% find the runoff value which has the first probability slightly higher 1%.
% Do it either analytically or visually in the plot of the flow duration
% curve! Assign this runoff value to variable "runoff_ex_prob_1".
    runoff_ex_prob_1 = 'INSERT FINDING OF RUNOFF VALUE AT EXCEEDENCE PROBABILITY 1%, EITHER ANALYTICALLY OR VISUALLY'
    
% convert this runoff value from mm/h (= L/m^2*h) into m³/s by using the Colpach catchment area --> this runoff value in m³/s
% is then the maximum capacity of the ouflow channel behind the reservoir.
% Maintain the variable name "runoff_ex_prob_1".
    runoff_ex_prob_1 = 'INSERT CONVERSION OF THIS RUNOFF VALUE FROM mm/h INTO m³/s BY USING CATCHMENT AREA'
    
%% Task 2: Design of flood_defence reservoir
% General setup
% select runoff event 
event_begin = datetime(2011, 01, 06, 09, 00, 00);    
event_end = datetime(2011, 01, 27, 09, 00, 00);     
event_idx = isbetween(dn, event_begin, event_end); 
time = dn(event_idx);

% reservoir inflow Q_in = event runoff; conversion of event runoff (mm/h
% into m³/s)
    Q_in = 'INSERT ASSIGNING OF OBSERVED RUNOFF OF SELECTED FLOOD EVENT TO Q_in'
    Q_in = 'INSERT UNIT CONVERSION FROM mm/h INTO m³/s'

% predefined dam height (m)
Dam_height = 3;

% maximum possible release of reservoir (m�/s) determined by the maximum capacity
% of the subsequent channel or stream (= runoff at 1 % exceedance
% probability in catchment; cf. Task 1)
max_reservoir_outflow = runoff_ex_prob_1; 

% acceleration of the earth m/s�
g = 9.81; 

% time step of given time series in seconds
diff_time = diff(table2array(colpach_climate(:,{'date'}))); 
dt = seconds(diff_time(1));

% Setup of Monte Carlo algorithm MC --> for an automatic calibration of A_out
% and alpha
MC_N = 1000000; % total number of Monte Carlo runs

% Step 1: random values for parameters A_out and alpha in predefined ranges. Think about suitable
% upper and lower range limits. Try different limits!
    A_out_range = 'INSERT GENERATION OF ARRAY WITH RANDOM VALUES IN PREDEFINED RANGE FOR A_out'
    alpha_range = 'INSERT GENERATION OF ARRAY WITH RANDOM VALUES IN PREDEFINED RANGE FOR alpha'

% Initialise/preallocate arrays for parameters, same length as input time series
ntime = length(time);
S = zeros(ntime,MC_N); % reservoir storage volume
h = zeros(ntime,MC_N); % reservoir water level height
Q_out = zeros(ntime,MC_N); % reservoir outflow

% Initial states of reservoir, empty reservoir
S(1,1) = 0; % zero water storage
h(1,1) = 0; % zero water level
Q_out(1,1) = 0; % no outflow
eps = 0.1; % calculation error
error_threshold = 0.05; % maximum error value
runoff_coefficient = 1; % scaling parameter for flow in outlet pipe

% MC loop
for MC_run = 1 : MC_N
    
    % select new values for parameters at beginning of each Monte Carlo run
        A_out = 'INSERT SELECTION OF VALUE FOR A_out AT BEGINNING OF EACH MC RUN'
        alpha = 'INSERT SELECTION OF VALUE FOR A_out AT BEGINNING OF EACH MC RUN'
    
% Step 2: for-loop to determine reservoir outflow in each time step
for t = 1 : ntime-1 
    
        % first assumption: new outflow = old outflow
        Q_out(t+1,MC_run) = Q_out(t,MC_run); 

        while eps > error_threshold % iteration with calculation of new outflow if error between calculated outflow (Q_out_it) and previously assumed outflow (Q_out) is above threshold
       
            % calculates storage volume change of reservoir by balancing inflow and outflow and mean
            % between current and next time step
            S(t+1,MC_run) = 'INSERT CALCULATION OF STORAGE VOLUME WITH Eq.1'
        
            % avoids negative storage within reservoir
            if S(t+1,MC_run) < 0
                S(t+1,MC_run) = 0;
                Q_out(t+1,MC_run) = 0;
            end
        
            % calculates water height in reservoir
            h(t+1,MC_run) = 'INSERT CALCULATION OF WATER LEVEL HEIGHT WITH Eq. 2' 
        
            % calculates actual outflow out of reservoir
            Q_out_it = 'INSERT CALCULATION OF RESERVOIR OUTFLOW WITH Eq. 3'
        
            % updates error value of current iteration
            eps = abs(Q_out_it - Q_out(t+1,MC_run)) / Q_out(t+1,MC_run); % error of calculated outflow (Q_out_it) related to previously assumed outflow (Q_out = equal to outflow in time step before) 
            Q_out(t+1,MC_run) = Q_out_it;


        end

        eps = 0.1; % resets actual error value for the next time step
    
end

end

% Steps 3-5: Analysis of Monte-Carlo runs and finding parameter setup with suitable and cheapest reservoir design

% initializing single costs
A_out_cm2_cost = 8; % cost of 1 cm² outlet pipe
alpha_m2 = 130; % cost of 1 m² surface area 

% create array with the maximum Q_out and h values of each Monte Carlo run.
% array should contain two columns: 1 -  max(Q_out) values; 2 - max(h)
% values.
    max_Q_h = 'INSERT CREATION OF ARRAY CONTAINING MAXIMUM Q_out AND h OF EACH MONTE-CARLO RUN' 

% Step 3: find in this "max_Q_h" array the index/position of Monte Carlo runs, which
% have (i) maximum h values below dam height, (ii) maximum outflow Q_out values
% below maximum possible reservoir outflow/channel capacity and 
% simultaneously (iii) only outflow Q_out values above 0 (we call these
% Monte Carlo runs, which satisfy these criteria: valid Monte Carlo runs).
% Use function "find". Hint: You can combine the finding of elements
% satisfying two or multiple conditions in one "find" function by using
% "&". Look up the help documentation of "find", section "Elements
% Satisfying Multiple Conditions".
    range_Q_h = 'INSERT FINDING OF INDEX/POSITIONS OF MC RUNS, WHERE Q_out AND h VALUES SATISFY THE THREE CONDITIONS'

% select the respective A_out and alpha values of these valid Monte Carlo
% runs by indexing the initially defined parameter value ranges with the
% "range_Q_h" index
    A_out = 'INSERT SELECTION OF RESPECTIVE A_out VALUES OF VALID MC RUNS'
    alpha = 'INSERT SELECTION OF RESPECTIVE alpha VALUES OF VALID MC RUNS'

% calculate total costs of each valid Monte Carlo run. Hint: A_out is given
% in m² --> convert. And the total surface area of your flood reservoir is
% achieved by 1/alpha.
    A_out_cost = 'INSERT CALCULATION OF COST FOR BUILDING OUTLET PIPE'
    alpha_cost = 'INSERT CALCULATION OF COST FOR RESERVOIR SURFACE AREA'

total_cost = A_out_cost + alpha_cost; % total costs

% find the minimum cost of valid Monte Carlo runs "min_cost" and the respective
% position/index of the Monte Carlo run "pos_min_cost", which produces this cheapest
% parameter setup and hence the cheapest but still suitable reservoir. Use
% function "min".
    [min_cost, pos_min_cost] = 'INSERT FINDING OF MINIMUM COST "min_cost" OF ALL VALID MC RUNS AND ITS RESPECTIVE POSITION/INDEX "pos_min_cost"'

% corresponding outlet area A_out and alpha of cheapest setup by indexing the initially defined parameter value ranges with the
% "range_Q_h" index and this is again indexed by "pos_min_cost"
    A_out_cheapest = 'INSERT DOUBLE INDEXING TO FIND CORRESPONDING A_out OF CHEAPEST SETUP'
    alpha_cheapest = 'INSERT DOUBLE INDEXING TO FIND CORRESPONDING alpha OF CHEAPEST SETUP'

% Q_out and h time series of cheapest setup for plotting
Q_out_final = Q_out(:,(range_Q_h(pos_min_cost)));
h_final = h(:,(range_Q_h(pos_min_cost)));

% plot of reservoir water level and outflow time series of cheapest but
% suitable reservoir design
figure;
subplot(2,1,1);
h1=plot(time,Q_in,'r-', 'linewidth',2);
hold on;
h2=plot(time,Q_out_final,'b-', 'linewidth',2);
h3=plot([time(1) time(ntime)],[max_reservoir_outflow max_reservoir_outflow],'r --', 'linewidth',2);
xlabel( 'time [h]','fontsize',16);
ylabel( 'Q [m^3/s]','fontsize',16);
legend('Inflow', 'Release','Channel capacity');
set(gca,'fontsize',16);
subplot(2,1,2); 
plot(time,h_final,'r-', 'linewidth',2);
hold on;
plot([time(1) time(ntime)],[Dam_height Dam_height],'r --', 'linewidth',2);
xlabel( 'time [h]','fontsize',16); 
ylabel( 'water level h [m]','fontsize',16); 
set(gca,'fontsize',16);  
legend('Water level', 'Dam height','Location','northwest');
