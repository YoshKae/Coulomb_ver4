function fault_overlay
% FAULT_OVERLAY draws faults included in an input file.

global H_MAIN
global FNUM_ONOFF   % to turn on (1) or turn off (0) the fault number
global DEPTH_RANGE_TYPE
global INPUT_VARS
global COORD_VARS
global SYSTEM_VARS

% tic
c = zeros(4,2); % initialize to be all zeros to fasten the process
d = zeros(4,2); % initialize to be all zeros to fasten the process
e = zeros(4,2); % initialize to be all zeros to fasten the process
h = findobj('Tag','main_menu_window2');
if (isempty(h)~=1 && isempty(H_MAIN)~=1)
	figure(H_MAIN);
else
    warndlg('No window prepared for grid drawing!','!!Bug!!');
end

hold on;
% size(INPUT_VARS.ELEMENT)
% load junk.mat
for n = 1:NUM
	 % Define the context menu
        cmenus(n) = uicontextmenu;
        cmenuf(n) = uicontextmenu;
% map projection box for a source fault
    c = fault_corners(INPUT_VARS.INPUT_VARS.ELEMENT(n,1),INPUT_VARS.ELEMENT(n,2),INPUT_VARS.ELEMENT(n,3),INPUT_VARS.ELEMENT(n,4),...
        INPUT_VARS.ELEMENT(n,7),INPUT_VARS.ELEMENT(n,8),INPUT_VARS.ELEMENT(n,9));
% map projection line for the surface
	d = fault_corners(INPUT_VARS.ELEMENT(n,1),INPUT_VARS.ELEMENT(n,2),INPUT_VARS.ELEMENT(n,3),INPUT_VARS.ELEMENT(n,4),...
        INPUT_VARS.ELEMENT(n,7),INPUT_VARS.ELEMENT(n,8),0.0);
% map projection line for the calc. depth
    e = fault_corners(INPUT_VARS.ELEMENT(n,1),INPUT_VARS.ELEMENT(n,2),INPUT_VARS.ELEMENT(n,3),INPUT_VARS.ELEMENT(n,4),...
        INPUT_VARS.ELEMENT(n,7),INPUT_VARS.ELEMENT(n,8),CALC_DEPTH);

% Calculation depth
if DEPTH_RANGE_TYPE == 0    % to avoid line drawing when depth range was selected
hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    d1 = xy2lonlat([e(3,1) e(3,2)]);
    d2 = xy2lonlat([e(4,1) e(4,2)]);
    a2 = plot([d1(1) d2(1)],[d1(2) d2(2)]);
else
    a2 = plot([e(3,1) e(4,1)],[e(3,2) e(4,2)]);
end
set (a2,'Color','k','LineWidth',1);
end

% Surface projection
hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    d1 = xy2lonlat([c(1,1) c(1,2)]);
	d2 = xy2lonlat([c(2,1) c(2,2)]);
	d3 = xy2lonlat([c(3,1) c(3,2)]);
	d4 = xy2lonlat([c(4,1) c(4,2)]);
a3 = plot([d1(1) d2(1) d3(1) d4(1) d1(1)],...
    [d1(2) d2(2) d3(2) d4(2) d1(2)]);
else
a3 = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
    [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)]);
end
set (a3,'Color','w','LineWidth',2.0);

hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    d1 = xy2lonlat([c(1,1) c(1,2)]);
	d2 = xy2lonlat([c(2,1) c(2,2)]);
	d3 = xy2lonlat([c(3,1) c(3,2)]);
	d4 = xy2lonlat([c(4,1) c(4,2)]);
a4 = plot([d1(1) d2(1) d3(1) d4(1) d1(1)],...
    [d1(2) d2(2) d3(2) d4(2) d1(2)],'UIContextMenu', cmenuf(n));
else
a4 = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
    [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)],'UIContextMenu', cmenuf(n));
end
set (a4,'Color',PREF(1,1:3),'LineWidth',PREF(1,4));



% Surface intersection
hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	d1 = xy2lonlat([d(3,1) d(3,2)]);
    d2 = xy2lonlat([d(4,1) d(4,2)]);   
a1 = plot([d1(1) d2(1)],[d1(2) d2(2)],'UIContextMenu', cmenus(n));
set (a1,'Color','g','LineWidth',2);
else
a1 = plot([d(3,1) d(4,1)],[d(3,2) d(4,2)],'UIContextMenu', cmenus(n));
set (a1,'Color','g','LineWidth',2);
end

% Define the context menu items
items1 = uimenu(cmenus(n), 'Label', 'change parameters',...
    'Callback',['INPUT_VARS.ELEMENT_modification(' num2str(n,'%3i') ')']);
itemf1 = uimenu(cmenuf(n), 'Label', 'change parameters',...
    'Callback',['INPUT_VARS.ELEMENT_modification(' num2str(n,'%3i') ')']);

% write fault number of the starting point
if FNUM_ONOFF == 1
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    d1 = xy2lonlat([c(1,1) c(1,2)]);
    htx = text(d1(1),d1(2),num2str(n));
else
    htx = text(c(1,1),c(1,2),num2str(n));
end
    set(htx,'fontsize',14,'fontweight','b','Color',[0.1 0.1 0.6]);
end

% Point source
if KODE == 400 | KODE == 500
    ap = plot((e(3,1)+e(4,1))/2.,(e(3,2)+e(4,2))/2.,'ko');
    set (ap,'LineWidth',1.5);
end

end

% toc
hold off;
