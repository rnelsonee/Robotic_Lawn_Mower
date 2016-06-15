
mean = 3;   			% Degrees, from spec
mean = mean/360*(2*pi);	% Radians
var = 0.5;    			% Variance, from spec
mu = log((mean^2)/sqrt(var+mean^2));
sigma = sqrt(log(var/(mean^2)+1));

x = lognrnd(mu,sigma);	% lognormal distribution, req'd by spec

old_heading = heading;
heading = rand()*2*pi + x;
%fprintf('Going to heading %0.0f\n', heading/(2*pi)*360);

time = time + (abs(heading - old_heading)/(2*pi))*revolution_speed;  % Time taken to spin