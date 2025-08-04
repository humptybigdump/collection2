%% Design of flood-defence reservoir Water and Energy Cycles WS 20/21
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
    'INSERT GENERATION OF FLOW DURATION CURVE IN COLPACH'
    
% plot flow duration curve
    'INSERT PLOTTING OF FLOW DURATION CURVE'
    
% find the runoff value which has the probability around 1 % to exceeded.
% Do it either analytically or visually in the plot of the flow duration
% curve! Assign this runoff value to variable "runoff_ex_prob_1".
    runoff_ex_prob_1 = 'INSERT FINDING OF RUNOFF VALUE AT EXCEEDENCE PROBABILITY 1%, EITHER ANALYTICALLY OR VISUALLY'
    
% convert this runoff value from mm/h (= L/m^2*h) into m³/s by using the Colpach catchment area --> this runoff value in m³/s
% is then the maximum capacity of the ouflow channel behind the reservoir.
% Maintain the variable name "runoff_ex_prob_1".
    runoff_ex_prob_1 = 'INSERT CONVERTING OF THIS RUNOFF VALUE FROM mm/h INTO m³/s BY USING CATCHMENT AREA'
    
%% Task 2: Design of flood_defence reservoir
% General setup
% select runoff event 
event_begin = datetime(2011, 01, 06, 09, 00, 00);    
event_end = datetime(2011, 01, 20, 09, 00, 00);     
event_idx = isbetween(dn, event_begin, event_end); 
time = dn(event_idx);

% reservoir inflow Q_in = event runoff; conversion of event runoff (mm/h
% into m³/s)
    Q_in = 'INSERT ASSIGNING OF OBSERVED RUNOFF OF SELECTED FLOOD EVENT TO Q_in'
    Q_in = 'INSERT UNIT CONVERSION FROM mm/h INTO m³/s'

% predefined dam height (m)
Dam_height = 4;

% maximum possible release of reservoir (m³/s) determined by the maximum capacity
% of the subsequent channel or stream (= runoff at 1 % exceedance
% probability in catchment; cf. Task 1)
max_reservoir_outflow = runoff_ex_prob_1; 

% acceleration of the earth m/s²
g = 9.81; 

% time step of given time series in seconds
diff_time = diff(table2array(colpach_climate(:,{'date'}))); 
dt = seconds(diff_time(1));

% Setup of Monte Carlo algorithm MC (cf. Task 2, Step 5 on exercise sheet) --> for an automatic calibration of A_out
% and alpha
MC_N = 10000; % total number of Monte Carlo runs

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

% MC loop
for MC_run = 1 : MC_N
    
    % select new values for parameters at beginning of each Monte Carlo run
        A_out = 'INSERT SELECTION OF VALUE FOR A_out AT BEGINNING OF EACH MC RUN'
        alpha = 'INSERT SELECTION OF VALUE FOR A_out AT BEGINNING OF EACH MC RUN'
    
% Step 2: for-loop to determine reservoir outflow in each time step
for t = 1 : ntime-1 
    
    for pc = 1:2 % iterative procedure to update reservoir state within time step: 
        % calculation of S for half time step --> calculation/updating of residual parameters based on S --> with new parameters, calculation for the second half of time step
    
    % water inflow Q_in fills reservoir to storage volume S (Eq.1)
        S(t+1, MC_run) = 'INSERT CALCULATION OF STORAGE VOLUME WITH Eq.1 FOR A HALF TIME STEP dt/2'
    
    % this storage volume corresponds to a water level dependend on
    % reservoir area represented by the scaling factor alpha (Eq. 2)
        h(t+1,MC_run) = 'INSERT CALCULATION OF WATER LEVEL HEIGHT WITH Eq. 2'
    
    % this water level in combination with the selected outlet area results
    % in reservoir outflow (Eq. 3)
        Q_out(t+1,MC_run) = 'INSERT CALCULATION OF RESERVOIR OUTFLOW WITH Eq. 3'
    
    % based on this outflow, the reservoir volume is updated (reduced).
    % Subtraction of Q_out from S for a half time step
        S(t+1,MC_run) = 'INSERT CALCULATION/UPDATING OF STORAGE VOLUME FOR A HALF TIME STEP dt/2'
    
    % if storage volume reduction leads to negative
    % storage, then the storage volume is just set to 0 and the actual
    % outflow to the inflow --> all the inflowing water immediately flows
    % out!
    if S(t+1,MC_run) < 0
       S(t+1,MC_run) = 0;
       Q_out(t+1,MC_run) = Q_in(t);
    end
    
    % water level height is respectively also updated and reduced.
        h(t+1,MC_run) = 'INSERT CALCULATION/UPDATING OF WATER LEVEL HEIGHT WITH Eq. 2'
    end % end of first step of iterative procedure (pc). All calculations above are now repeated for a second time
        % to calculate the second half of the time step with the updated conditions
    
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

% Step 3: find in this "max_Q_h" array the index/positions of Monte Carlo runs, which
% have maximum h values below dam height and maximum outflow (Q_out) values
% below maximum possible reservoir outflow/channel capacity (we call these
% Monte Carlo runs, which satisfy these criteria: valid Monte Carlo runs).
% Use function "find". Hint: You can combine the finding of elements
% satisfying two or multiple conditions in one "find" function by using
% "%". Look up the help documentation of "find", section "Elements
% Satisfying Multiple Conditions".
    range_Q_h = 'INSERT FINDING OF INDEX/POSITIONS OF MC RUNS, WHERE MAXIMUM Q_out AND h VALUES SATISFY THE TWO CONDITIONS'

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
    'INSERT FINDING OF MINIMUM COST "min_cost" OF ALL VALID MC RUNS AND RESPECTIVE POSITION/INDEX "pos_min_cost"'

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
