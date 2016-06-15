%% Load yard
G = Yard{1,map}; 
% Add border - this prevents having to do time-consuming checks every time
% we move the mower. So we add a 1-pixel Null space around the lawn
% Note this expands to 2 pixels in the next step
A = ones(size(G,1)+2,size(G,2)+2);	  % Create ones array, larger than G
A(2:1+size(G,1), 2:1+size(G,2))=G;	  % Put G in there
G=A;
clear A;

% Resize G to 6" resolution by expanding once in each dimension
% Basically turns [a b; c d] to [a a b b; a a b b; c c d d; c c d d]
c=reshape([G(:) G(:)]',2*size(G,1),[])';
G=reshape([c(:) c(:)]',2*size(c,1), [])';

% Set up color map - display code is in DisplayMower.m
% but it helps to have the key here to see what's going on
% 			1 White     [  1    1   1]  Null
%			2 D. Grn  	[  0  .80   0]  Uncut grass
%			3 Green     [  0    1   0]  Cut grass
%			4 Black     [  0    0   0]  Edge (not used)
%			5 Orange 	[  1  .70   0]  Objects
%			6 Gray		[ .6  .60 .60]   Inaccessible yard
%           7 Blue      [  0  .40 .90]  Mower

