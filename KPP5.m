function lower_bound = KPP5(number_of_runs, hours, show_all_sim_images,...
 show_end_sim_images, show_sim_text, show_final_text_output)
% KPP5 Runs the Coverage Area KPP
% Inputs are (number of sim iterations) (sim hours to run), (show all sim
% progress images), (show images only at end of run), (show sim text
% output), (show final KPP.m text output)
% Suggested call for demonstration
% KPP5(5, 3/10, true, true, true, true);
% This runs 5 yards, simulating 30 minutes each, with all outputs on

%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENEE 670 Capstone | Fall 2015 | Team 2
%
% KPP5.m
%
% This file will simulate a mower moving over different lawns
% and tracks how much of the yard is mowed. Returns the average
% coverage rate over a number of simulations
%
% Inputs:	number_of_runs:         How many sims to run (integer)
%           hours:                  How many hours to run in sim time
%           show_all_sim_images:    Show map images during sim frequently (boolean)
%           show_end_sim_images:    Show map image during sim at yard finish (boolean)
%           show_sim_text:          Show text output after each yard finish (boolean)
%           show_final_text_output: Show final KPP5 high level text output (boolean)
%
% Outputs:	result:             KPP result, avg area covered (0-1).
%
% Rev	Date	Auth	Description
%  1    11/15   RGN     Initial Release
%
%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set initial variables/values
coverage_goal = 0.98;                       % The pass/fail criteria
conf_interval = 0.95;                       % Confidence interval


load('Team2SimulationDB.mat');    % Load shared data file
coverage_log = zeros(1,number_of_runs)-1;   % -1 to spot errors easier

%% Run simulation
for i = 1:number_of_runs
    map = mod(i-1, 100)+1;          % Cycle through maps
                                    % This math prevents 0's
    % MoveMower is the workhorse - runs a mower and tracks coverage
    pct_coverage  = MoveMower(Yard, map, hours, show_all_sim_images, show_sim_text, show_end_sim_images);
    coverage_log(i) = pct_coverage;
end
result = mean(coverage_log);   % 0-100, avg % coverage

%% Calculate confidence interval
alpha = 1 - conf_interval;
n = length(coverage_log);
T = tinv(1-alpha/2, n-1);
interval = T*std(coverage_log)/sqrt(n);
lower_bound = max(result-interval,0);	% Cannot go under 0%
upper_bound = min(result+interval,1);   % Cannot go over 100%


%%  Display results
if show_final_text_output == true
    fprintf('The average coverage is %0.2f%%\n', result*100);
    fprintf('The confidence interval is between %1.2f%% and %1.2f%%\n', lower_bound*100, upper_bound*100)
    if lower_bound >= coverage_goal
        fprintf('KPP 5 is met\n')
    else
        fprintf('KPP 5 is not met\n')
    end
end

