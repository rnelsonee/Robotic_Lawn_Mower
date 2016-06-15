function pct_complete = MoveMower(Yard, map, hours, show_progress, show_text_results, show_final_image)

% Inputs
%   Yard:           Yard grids (1x100 cell array)
%   map:            Map number (Yards element)
%   hours:          Hours to simulation
%   show_progress:  Show images during run
%   show_text_res.: Show text results at end
%   show_final_img: Show final image

% Outputs
%   pct_complete:   Percent coverage of map (mowed vs unmowed)

%% Program setup
save_figures = false;

% Load defaults
load('..\Common\Team2SimulationDB.mat');
mod_frame = 100;                       % Show only 1/mod_frame of images, speeds up display
mow_time = hours*60*60;                 % Seconds - how long to run the mower (3h)
max_speed = mower_max_speed*5280/3600;  % mph to feet per second
a = mower_accel*5280/3600;              % Acceleration of mower, from mph/s to ft/s^2
decel = mower_decel*5280/3600;          % Deceleration of mower, from mph/s to ft/s^2
resolution = 0.5;                       % feet per matrix element. Each pixel is 6", or 0.5ft
d = resolution;                         % Distanace travelled per simulation step, ft
blade_radius = 1;                       % feet, used to cut swath around the mower's center
p = blade_radius/resolution;            % Blade radius in pixels

pct_coverage = 0;                       % Percent (0-1)
distance_travelled = 0;                 % feet
time_elapsed = 0;                       % seconds
v_i = 0;                                % Initial velocity, feet/second
v_f = 0;                                % Final velocity, feet/second
revolution_speed = 1.5;                 % seconds to complete one revolution
at_object = false;                      % Assume our owner doesn't place the charging station in a tree

time_track = [];
time_cumulative_track = [];


% Slow at this point. If we detect object before this, we should keep speeding
% along. But we don't always want to slam on brakes too late (or too early)
% So we'll stop at 6 feet unless or specs change and we need to stop
% sooner.
% Based on v_f^2 = v_i^2 + 2ad. We know final v is 0, a is 'decel'.
 hit_brakes_distance = max(sqrt(max_speed)/(2*decel), 6);                                     
                                        
%% Load yard
LoadYard()

%% Set initial position, heading
PlaceMower()

%% Moving the mower
% Each step is 6" of movement (cos(theta) + sin(theta) = 1 pixel)
% Because distance is constant per loop, we calculate time dynamically
% and add it to a cumulative buffer (time_elapsed)
sim_iteration=0;
while time_elapsed <= mow_time
    sim_iteration = sim_iteration+1;
    time = 0;
    
    % Detect distance. Takes what we *can* detect, but also our desired
    % stop point. We only care about the lesser of the two.
    dd = min(DetermineObjectDetectDistance(obj_detect_dist_mean, obj_detect_dist_var), hit_brakes_distance); % feet
    OD = dd/resolution;             % Converts above to pixels for our CFO()
    v_i = v_f;                      % Set initial velocity for this loop to the
                                    % last velocity of the last loop
    
    if CheckForObjects(G, LMPy, LMPx, heading, 1:OD) > 1
        % There's objects detected ahead.
        % If a previous loop said we're at an object, that means we've
        % turned, but not enough. Change heading and try again.
        % If that's not the case, and we're moving, slow down.
        % If that's not the case, we're stopped, which only happens when
        % Harry Homeowner placed the initial mower position facing an
        % object.
        if at_object == true;
            ChangeHeading();
        elseif v_i > 0
            Decelerate();
        else
            Accelerate();
        end
    elseif CheckForObjects(G, LMPy, LMPx, heading, 1:OD) == 1
        % There's an object right in front of us. So record this so our
        % next iteration knows we may need to spin more.
        at_object = true;
        v_f = 0;                % Already 0 unless our decel isn't good enough.
        ChangeHeading();
    else
        % No objects in front of us - speed up (or keep going max speed).
        at_object = false;
        Accelerate()
    end
    
    CutGrass()
    
    % We've cut the grass, and time was set in each of our conditions above
    % So now we just track it in an array.
    time_elapsed = time_elapsed + time; % Cumulative time elapsed is tracked
    time_track = [time_track time];
    time_cumulative_track = [time_cumulative_track time_elapsed];
    
    % If we want to watch the fun, Display and image
    if show_progress == true && mod(sim_iteration,mod_frame)==0
        DisplayMower();
        pause(0.001);
    end
end % steps, i

%% Final displays
if show_progress == true || show_final_image == true
    DisplayMower()
    if save_figures == true
        filename = strcat('..\KPP 5 - Coverage Area\KPP5 results images\KPP5_result_Yard_', num2str(map, '%03d'), '.png');
        saveas(1,filename)
    end
    
    % Plot time
    figure(2);
    subplot(2,1,1);
    plot(time_track);
    title('Time taken to move each 6" step');
    xlabel('Sim step (6") move')
    ylabel('Time taken in step (sec)')
    subplot(2,1,2);
    plot(time_cumulative_track);
    title('Time elapsed per 6" step')
    xlabel('Sim step (6") move')
    ylabel('Time taken in step (sec)')
end

if show_text_results == true
    distance_travelled = sim_iteration*resolution;          % pixels*(feet/pixel) = feet
    time_elapsed_minutes = time_elapsed/60;     % minutes
    time_elapsed_hours = time_elapsed/(60*60);  % hours
    
    cut = sum(sum(G==3));
    not_cut = sum(sum(G==2));
    pct_complete = (cut/(cut + not_cut));
    fprintf('Yard number %3d, %0.2f simulation hours, %0.1f%% coverage\n', map, time_elapsed_hours, pct_complete*100)
end

%% Final output
cut = sum(sum(G==3));
not_cut = sum(sum(G==2));
pct_complete = (cut/(cut + not_cut));
