function coulomb2gmt_source
% FAULT_OVERLAY draws faults included in an input file.

global H_MAIN
global NUM ELEMENT KODE
global CALC_DEPTH
global PREF         % graphic preference row1, fault, row2, vector
global ICOORD LON_GRID DEPTH_RANGE_TYPE
% global NSELECTED

% tic
c = zeros(4,2); % initialize to be all zeros to fasten the process
d = zeros(4,2); % initialize to be all zeros to fasten the process
e = zeros(4,2); % initialize to be all zeros to fasten the process
% h = findobj('Tag','main_menu_window');
% if (isempty(h)~=1 && isempty(H_MAIN)~=1)
% 	figure(H_MAIN);
% else
%     warndlg('No window prepared for grid drawing!','!!Bug!!');
% end
% 

ICOORD = 1;

fid1 = fopen('gmt_fault_calc_dep.dat','wt');
fid2 = fopen('gmt_fault_map_proj.dat','wt');
fid3 = fopen('gmt_fault_surface.dat','wt');
for n = 1:NUM
% map projection box for a source fault
    c = fault_corners(ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
% map projection line for the surface
	d = fault_corners(ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),0.0);
% map projection line for the calc. depth
    e = fault_corners(ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),CALC_DEPTH);

% ----- Calculation depth ----------------------
if DEPTH_RANGE_TYPE == 0    % to avoid line drawing when depth range was selected
if ICOORD == 1
    d1 = xy2lonlat([e(3,1) e(3,2)]);
    d2 = xy2lonlat([e(4,1) e(4,2)]);
%     a2 = plot([d1(1) d2(1)],[d1(2) d2(2)]);
else
    d1 = [e(3,1) e(3,2)];
    d2 = [e(4,1) e(4,2)];
%     a2 = plot([e(3,1) e(4,1)],[e(3,2) e(4,2)]);
end
    fprintf(fid1,'%15.3f %15.3f\n',d1);
    fprintf(fid1,'%15.3f %15.3f\n',d2);
    fprintf(fid1,'> break\n');
end

% ----- Surface projection ---------------------
if ICOORD == 1
    d1 = xy2lonlat([c(1,1) c(1,2)]);
	d2 = xy2lonlat([c(2,1) c(2,2)]);
	d3 = xy2lonlat([c(3,1) c(3,2)]);
	d4 = xy2lonlat([c(4,1) c(4,2)]);
% a3 = plot([d1(1) d2(1) d3(1) d4(1) d1(1)],...
%     [d1(2) d2(2) d3(2) d4(2) d1(2)]);
else
    d1 = c(1,:);
    d2 = c(2,:);
    d3 = c(3,:);
    d4 = c(4,:);
%     
%     a3 = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
%     [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)]);
end
    fprintf(fid2,'%15.3f %15.3f\n',d1);
    fprintf(fid2,'%15.3f %15.3f\n',d2);
    fprintf(fid2,'%15.3f %15.3f\n',d3);
    fprintf(fid2,'%15.3f %15.3f\n',d4);
    fprintf(fid2,'%15.3f %15.3f\n',d1);
    fprintf(fid2,'> break\n');    
    
% if ICOORD == 2 && isempty(LON_GRID) ~= 1
%     d1 = xy2lonlat([c(1,1) c(1,2)]);
% 	d2 = xy2lonlat([c(2,1) c(2,2)]);
% 	d3 = xy2lonlat([c(3,1) c(3,2)]);
% 	d4 = xy2lonlat([c(4,1) c(4,2)]);
% a4 = plot([d1(1) d2(1) d3(1) d4(1) d1(1)],...
%     [d1(2) d2(2) d3(2) d4(2) d1(2)],'UIContextMenu', cmenuf(n));
% else
% a4 = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
%     [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)],'UIContextMenu', cmenuf(n));
% end

% ----- Surface intersection -------------------
if ICOORD == 1
	d1 = xy2lonlat([d(3,1) d(3,2)]);
    d2 = xy2lonlat([d(4,1) d(4,2)]);   
% a1 = plot([d1(1) d2(1)],[d1(2) d2(2)],'UIContextMenu', cmenus(n));
else
    d1 = [d(3,1) d(3,2)];
    d2 = [d(4,1) d(4,2)];
% a1 = plot([d(3,1) d(4,1)],[d(3,2) d(4,2)],'UIContextMenu', cmenus(n));
end
    fprintf(fid3,'%15.3f %15.3f\n',d1);
    fprintf(fid3,'%15.3f %15.3f\n',d2);
    fprintf(fid3,'> break\n');

% Point source
% if KODE == 400 | KODE == 500
%     ap = plot((e(3,1)+e(4,1))/2.,(e(3,2)+e(4,2))/2.,'ko');
% %     set (ap,'LineWidth',1.5);
% end

end

fclose(fid1);
fclose(fid2);
fclose(fid3);


% toc
% hold off;
