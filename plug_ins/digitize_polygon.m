% DIGITIZE_POLYGON get mouse-click positions
%
%   Copyright 2007 Shinji Toda, Active Fault Rearch Center,
%   Geological Survey of Japan, AIST.
%   $Revision: 1.0.0 $  $Date: 2007/01/12 $

ntrial = 1;
while (ntrial ~= 0)
    
set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);
%------ mouse clicks -------------------
n = 0;
but = 1;
try
    while (but == 1)
        n = n+1;
        [xi,yi,but] = ginput(1);
        xy_poly(n,1) = xi;
        xy_poly(n,2) = yi;
        hold on;
        p(n) = plot(xi,yi,'kx');
    end
catch
    disp('Error. Try again.');
    return
end
set(p(:),'Tag','polygon');

%----- quest dialog (Yes, No, Remove) ---------------------
%       Yes   : continue to make another polygon
%       No    : stop (this is the last polygon)
%       Remove: remove x marks and repeat the same clicking
button = questdlg('Next polygon?',' ','Yes','No','Remove this one','Cancel');
switch button
    case 'Yes'
        xy_poly(1:n,:);
        a = xy2lonlat(xy_poly(1:n,:));
        b = [a;a(1,:)];
        hold on;
        q = plot([rot90(xy_poly(:,1)) xy_poly(1,1)],...
            [rot90(xy_poly(:,2)) xy_poly(1,2)],'k');
        fn = ['polygons' num2str(ntrial) '.dat'];
        save(fn, 'b', '-ascii');
 %       save polygons.dat b -ascii;
        disp('polygons.dat is saved in this directory');
        ntrial = ntrial + 1;
    case 'No'
        xy_poly(1:n,:);
        a = xy2lonlat(xy_poly(1:n,:));
        b = [a;a(1,:)];
        hold on;
        q = plot([rot90(xy_poly(:,1)) xy_poly(1,1)],...
            [rot90(xy_poly(:,2)) xy_poly(1,2)],'k');
        fn = ['polygons' num2str(ntrial) '.dat'];
        save(fn, 'b', '-ascii');
        disp('polygons.dat is saved in this directory');
        ntrial = 0;
    case 'Remove this one'
        hd = findobj('Tag','polygon');
        delete(hd);
        ntrial = 0;
    otherwise
end
% clear
clear a b p xy_poly
end
%----------------------------------------
clear a b xy_poly
set(H_MAIN,'HandleVisibility','callback');