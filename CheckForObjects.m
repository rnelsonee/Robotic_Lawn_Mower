function obj_dist = CheckForObjects(G, LMPy, LMPx, heading, look_distances)

% This detects objects. It works in pixels, so it looks in the
% look_distances array passed in. It can look at any spot distance, but best
% practice is to search for 1:X where X is how far you're looking, in case
% there's an object one or two pixels in front of you, and then yard behind
% it. We want the object to register.

% So this loops over those distances (pixels) accordign to the heading
% we're on, and reports back obj_dist, which is -1 if nothing is found.

y_move = -cos(heading);			% Figuring the distance to move
x_move = sin(heading);			% Note no multiply needed - move 6" at a time

object_detected = false;
obj_dist = -1;
k= 1;
while object_detected == false && k <= numel(look_distances)
    LMPyo = round(LMPy+y_move*look_distances(k));
    LMPxo = round(LMPx+x_move*look_distances(k));
    if (LMPyo >= size(G,1)-1-1) ||...
            (LMPxo >= size(G,2)-1-1) ||...
            (LMPyo <= 1+1) || (LMPxo <= 1+1)  ||...
            ((G(LMPyo, LMPxo) ~= 2) && G(LMPyo, LMPxo) ~= 3)
        object_detected = true;
        obj_dist = k;
    end
        k = k+1;
end

