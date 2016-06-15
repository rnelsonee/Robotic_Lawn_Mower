function dd = DetermineObjectDetectDistance(obj_detect_dist_mean, obj_detect_dist_var)

% Best detection is at 4 meters or 13.12 feet.
mean = obj_detect_dist_mean; %13.12;   % Mean detect distance
var = obj_detect_dist_var; %2;        % Variance
mu = log((mean^2)/sqrt(var+mean^2));
sigma = sqrt(log(var/(mean^2)+1));

dd = lognrnd(mu,sigma);