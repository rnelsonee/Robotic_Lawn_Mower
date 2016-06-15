% The philosophy for this module is to look at the distance to the object
% and calculalte the deceleration needed to stop. If we can, good - if not,
% report the problem. We set our deceleration is the one called out to stop
% (using constant deceleration) or the maximum we have specced out.

% Once this is set, we want to move 6", since we now know the deceleration,
% the distance is 6", and we know initial velocity. So we calculate final
% velocity, and that becomes initial velocity going forward. We also track
% the time.


% Find time needed to stop
%distance_to_object = OD * resolution;   % Feet
distance_to_object = CheckForObjects(G, LMPy, LMPx, heading, 1:OD)*resolution; % feet
%fprintf('Moving %d at %0.1f ft/s and object is %0.1f feet away\n', i,v_i, distance_to_object);

LMPx = LMPx + sin(heading);
LMPy = LMPy + -cos(heading);

%1 v_f = v_i + at
%2 d   = v_i*t + (1/2)at^2
%3 d   = v_f*t - (1/2)at^2
%4 d   = (1/2)(v_i + v_f)t
%5 v_f = sqrt(v_o^2 + 2ad)

% From 5, a=(v_f^2 - v_o^2)/2d
v_f = 0;
decel_required = (v_f^2 - v_i^2)/(2*distance_to_object);
% Negate, as we have decel >0
time_to_stop = -v_i/decel_required;
decel_required = -decel_required;


%fprintf('The decel required to go %0.1f ft is %0.1f ft/s^2 and will take %0.3f seconds\n', distance_to_object, decel_required, time_to_stop);

if decel_required >= decel
    %fprintf('We have a problem, as max decel is %0.1f ft/s^2\n', decel);
    % This just ensures we're going to bang into the object....
    decel_used = decel;
else
    decel_used = decel_required;
end
    %fprintf('Using decel of %0.1f ft/s^2\n', decel_used);

% Move distance
v_f = sqrt(v_i^2 + 2*(-decel_used)*resolution); % Moving 6"
%fprintf('Decel going from %0.1f ft/s to %0.1f ft/s\n', v_i, v_f);
time_to_move = (v_f-v_i)/(-decel_used);
%fprintf('It will take us %0.3f seconds\n', time_to_move);

time = time + time_to_move;

