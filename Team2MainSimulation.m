%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENEE 670 Capstone | Fall 2015 | Team 2
%
% Team2MainSimulation.m
%
% This file will run all 5 KPP simulations.
% Results are provided by each KPP file.
%
% Inputs:	None
%
% Outputs:	Text output from each KPP simulation
%
%%%%%%%%%%%%%%%%%%%%%%%%%

%% File/path setup
load('Team2SimulationDB_Rev8.mat');
addpath('../KPP 1 - Max Grade');
addpath('../KPP 2 - Engine Stop');
addpath('../KPP 3 - Object Avoidance');
addpath('../KPP 4 - Drop avoidance');
addpath('../KPP 5 - Coverage Area');

%% Set up goals for each KPP
KPP1_goal = 27;                 % Minimum inclination angle
KPP1_runs = 100;                % Number of trials

KPP2_goal = 99;                 % Receive sensitivity threshold
KPP2_runs = 100;                % Number of sims

KPP3_goal = 1;

KPP4_goal = 1;

KPP5_goal = 0.98;               % Minimum coverage (mowed grass)
KPP5_runs = 10;                 % Number of sims


%% KPP 1 -
kpp1 = KPP1(KPP1_runs,false,false,false);
if kpp1 >= KPP1_goal
    fprintf('KPP 1 is met\n')
else
    fprintf('KPP 1 is not met\n')
end
%
 %% KPP 2 -
 kpp2 = KPP2(KPP2_runs,false,false);
 if kpp2 <= KPP2_goal
     fprintf('KPP 2 is met\n')
 else
     fprintf('KPP 2 is not met\n')
 end
%
% %% KPP 3 -
% kpp3 = KPP3();
% if kpp3 >= KPP3_goal
%     fprintf('KPP 3 is met\n')
% else
%     fprintf('KPP 3 is not met\n')
% end
%
% %% KPP 4 -
% kpp4 = KPP4();
% if kpp4 >= KPP4_goal
%     fprintf('KPP 4 is met\n')
% else
%     fprintf('KPP 4 is not met\n')
% end


%% KPP 5 - Coverage
kpp5 = KPP5(KPP5_runs, 3*hours_per_charge, false, false, false, false);     % 'false' parameters to turn off all outputs
if kpp5 >= KPP5_goal
    fprintf('KPP 5 is met\n')
else
    fprintf('KPP 5 is not met\n')
end