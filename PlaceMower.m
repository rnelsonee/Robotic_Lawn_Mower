
% Place on the left, search until we gind a green spot
LMPy = size(G,1)/2;
LMPx = (1/resolution)+1;                               % We have a 2-pixel white (1) border, 3 is edge
heading = pi/2;              % Leaves the base at a known heading

% Look for a random spot of grass (2 = uncut grass)
look_loop = 0;
while G(LMPy,LMPx)~= 2
    LMPy = floor(rand()*size(G,1))+1;
    look_loop = look_loop + 1;
    if look_loop >= 1000
        error('Cannot find spot of grass on left for init position.');
    end
end