function surface_positions(n)
% display surface positions of a fault
% n: n-th fault element

global H_MAIN
global NUM ELEMENT KODE
global CALC_DEPTH
global PREF         % graphic preference row1, fault, row2, vector
global ICOORD LON_GRID DEPTH_RANGE_TYPE
% global NSELECTED

% tic
d = zeros(4,2); % initialize to be all zeros to fasten the process

% map projection line for the surface
	d = fault_corners(ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),0.0);

% Surface intersection
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	d1 = xy2lonlat([d(3,1) d(3,2)]);
    d2 = xy2lonlat([d(4,1) d(4,2)]);   
disp(['x-start ' num2str(d1(1),'%7.3f') '  y-start ' num2str(d2(1),'%7.3f')]);
disp(['x-finish ' num2str(d1(2),'%7.3f') '  y-finish ' num2str(d2(2),'%7.3f')]);
% a1 = plot([d1(1) d2(1)],[d1(2) d2(2)],'UIContextMenu', cmenus(n));
else
disp(['x-start ' num2str(d(4,1),'%7.3f') '  y-start ' num2str(d(4,2),'%7.3f')]);
disp(['x-finish ' num2str(d(3,1),'%7.3f') '  y-finish ' num2str(d(3,2),'%7.3f')]);
% a1 = plot([d(3,1) d(4,1)],[d(3,2) d(4,2)],'UIContextMenu', cmenus(n));
end



