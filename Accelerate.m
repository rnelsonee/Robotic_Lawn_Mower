% Accelerate
% Sets final velocity and adds time to accelerate

% We will use the follwing formulas:
% Final velocity (becomes initial velocity for next step)
%   v_f^2 = v_i^2 + 2ad
%   v_f = sqrt(v_i^2 + 2*a*d)
% Time to traverse lawn given accel, distance, init. velocity
%   d = v_i + (1/2)at^2
%   time_roots = roots([a/2, v_i, -d])   
% Because of quadratic formula


LMPx = LMPx + sin(heading);
LMPy = LMPy + -cos(heading);

if v_i == max_speed
    accel_time = resolution/v_i;
else
    v_f = min(sqrt(v_i^2 + 2*a*d),max_speed);
    time_roots = roots([a/2, v_i, -d]); % How long did the move take?
    accel_time = max(time_roots);
end


time = time + accel_time;

%fprintf('Accel: going from %0.2f %0.2f in %0.2f sec\n', v_i, v_f, accel_time);