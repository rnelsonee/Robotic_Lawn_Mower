% DisplayMower.m
distance_travelled = i*resolution;          % pixels*(feet/pixel) = feet
time_elapsed_minutes = time_elapsed/60;     % minutes
time_elapsed_hours = time_elapsed/(60*60);  % hours

cut = sum(sum(G==3));
not_cut = sum(sum(G==2));
pct_complete = (cut/(cut + not_cut));

M=G;
    % We keep the distance in floats. But to draw we need to go by
    % pixels, so we round to 'center' the mower to a pixel. Note we only
    % do this for displayt. We keep unrounded values in memory so our
    % movement stays accurate, and we use the floats for our cutting
    % algorithm as well
    LMPyr = round(LMPy);
    LMPxr = round(LMPx);
    
% LMPyr and LMPxr should be within the yard
% But just in case we will constrain them
LMPyr = min(max(3,LMPyr),size(G,1)-2);
LMPxr = min(max(3,LMPxr),size(G,2)-2);

M(LMPyr-p:LMPyr+p,LMPxr-p:LMPxr+p)=7;
M(LMPyr, LMPxr) = 1;
figure(1)
image(M)
axis image
yard_map = [1 1 1; 0 0.8 0; 0 1 0; 0 0 0; 1 0.7 0; 0.6 0.6 0.6; 0.0 0.4 0.9];
% Only load colormap if figure exists already
colormap(yard_map);
title(sprintf('Yard %d, %3.1f mins, %4.2f%% complete', map, time_elapsed_minutes, pct_complete*100))