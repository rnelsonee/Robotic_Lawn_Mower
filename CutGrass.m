    % We keep the distance in floats. But to draw we need to go by
    % pixels, so we round to 'center' the mower to a pixel. Note we only
    % do this for displayt. We keep unrounded values in memory so our
    % movement stays accurate, and we use the floats for our cutting
    % algorithm as well
    LMPyr = round(LMPy);
    LMPxr = round(LMPx);
    
% Turn unmowed grass (2) to mowed (3) by taking advantage of the find
	% function. We find when the subset of G around our mower is unmowed
	% grass (2), which is a pxp array of 0's or 1's (1's where G subset
	% equals 2). We then simply add that 1's 0's to the G subset. This in
	% turn turns all 2's into 3's.
	
	% While hard to read, this saves time/memory, and it accurate - it has four
	% cases so it knows which pixels to cut. If we had a 2.5 foot diameter,
	% and we have a 6" grid, the easy way is to cut the pixel the mower is
	% on and 2 on each side. But we have a 2.0 foot diameter blade, so we
	% find in which quadrant within the 6"x6" pixel we are exactly, and
	% then only cut a 4x4 pixel (2'x2') square out of that.
	%
	% To make this easier to see, here's the 2.5', easy way, in pseudo code
	% G(y-p:y+p,x-p:x+p)=((G(y-p:y+p,x-p:x+p)==2)+G(y-p:y+p,x-p:x+p));
	% or
	% G(10:12,1:2)=((G(10:12,1:2)==2)+G(10:12,1:2));

	if (LMPy-LMPyr)<=0 && (LMPx-LMPxr)<=0			 % Mower is in upper-left
		G(LMPyr-p:LMPyr+p-1,LMPxr-p:LMPxr+p-1)=((G(LMPyr-p:LMPyr+p-1,LMPxr-p:LMPxr+p-1)==2)+G(LMPyr-p:LMPyr+p-1,LMPxr-p:LMPxr+p-1));
	elseif (LMPy-LMPyr)<=0 && (LMPx-LMPxr)>0		 % Mower is in upper-right
		 G(LMPyr-p:LMPyr+p-1,LMPxr-p+1:LMPxr+p)=((G(LMPyr-p:LMPyr+p-1,LMPxr-p+1:LMPxr+p)==2)+G(LMPyr-p:LMPyr+p-1,LMPxr-p+1:LMPxr+p));
	elseif (LMPy-LMPyr)>0 && (LMPx-LMPxr)>0		 % Mower is in lower-right
		 G(LMPyr-p+1:LMPyr+p,LMPxr-p+1:LMPxr+p)=((G(LMPyr-p+1:LMPyr+p,LMPxr-p+1:LMPxr+p)==2)+G(LMPyr-p+1:LMPyr+p,LMPxr-p+1:LMPxr+p));
	else											% Mower is in lower-left
		 G(LMPyr-p+1:LMPyr+p,LMPxr-p:LMPxr+p-1)=((G(LMPyr-p+1:LMPyr+p,LMPxr-p:LMPxr+p-1)==2)+G(LMPyr-p+1:LMPyr+p,LMPxr-p:LMPxr+p-1));
	end
