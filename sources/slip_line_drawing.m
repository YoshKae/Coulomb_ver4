% SCRIPT
%
% to draw slip lines for Coulomb stress calculation
% [fig,h] = figflag('main_menu_window');

global H_MAIN ICOORD LON_GRID LAT_GRID
figure(H_MAIN);
hax = gca;
hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    xinc = LON_GRID(2) - LON_GRID(1);
    yinc = LAT_GRID(2) - LAT_GRID(1);
    n = length(LON_GRID) * length(LAT_GRID);
else
    xinc = GRID(5,1);
    yinc = GRID(6,1);
    n = length(XGRID) * length(YGRID);
end
sl = sqrt(xinc*xinc+yinc*yinc)/4.0;
angle = zeros(n,1);
angle2 = zeros(n,1);
angle3 = zeros(n,1);
lg = zeros(n,1);
lg2 = zeros(n,1);
lg3 = zeros(n,1);
sx = zeros(n,1);
sy = zeros(n,1);
sx2 = zeros(n,1);
sy2 = zeros(n,1);
sx3 = zeros(n,1);
sy3 = zeros(n,1);
if FLAG_PR_AXES ~= 1
    if STRESS_TYPE ~= 1
    if STRESS_TYPE == 2
        angle(:,1) = STRIKE;
        angle2(:,1) = strike2;
    else
        angle(:,1) = STRIKE; 
    end
    lg = 1.0;       % default
    sx = sl .* sin(deg2rad(angle)) .* lg;
    sy = sl .* cos(deg2rad(angle)) .* lg;
    sx2 = sl .* sin(deg2rad(angle2)) .* lg;
    sy2 = sl .* cos(deg2rad(angle2)) .* lg;
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat(XYCOORD(:,:));
            x1 = [rot90(a(:,1)-sx(:));rot90(a(:,1)+sx(:))];
            y1 = [rot90(a(:,2)-sy(:));rot90(a(:,2)+sy(:))];
        else
            x1 = [rot90(XYCOORD(:,1)-sx(:));rot90(XYCOORD(:,1)+sx(:))];
            y1 = [rot90(XYCOORD(:,2)-sy(:));rot90(XYCOORD(:,2)+sy(:))];
     end
    h1 = plot(hax,x1,y1,'Color','k','LineWidth',1);
    hold on;
	if STRESS_TYPE == 2
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat(XYCOORD(:,:));
            x2 = [rot90(a(:,1)-sx2(:));rot90(a(:,1)+sx2(:))];
            y2 = [rot90(a(:,2)-sy2(:));rot90(a(:,2)+sy2(:))];
        else
            x2 = [rot90(XYCOORD(:,1)-sx2(:));rot90(XYCOORD(:,1)+sx2(:))];
            y2 = [rot90(XYCOORD(:,2)-sy2(:));rot90(XYCOORD(:,2)+sy2(:))];
        end
    h2 = plot(hax,x2,y2,'Color',[0.7 0.7 0.7],'LineWidth',1);
    legend([h1(1) h2(1)],'Right-lat.','Left-lat.');
    end
    end
else
    angle(:,1) = pt_rs(:,1);
    angle2(:,1) = pt_rs(:,4);
    angle3(:,1) = pt_rs(:,7);
    lg(:,1)  = cos(deg2rad(pt_rs(:,2)));
    lg2(:,1) = cos(deg2rad(pt_rs(:,5)));
    lg3(:,1) = cos(deg2rad(pt_rs(:,8)));
    lg = 1.0;
    sx = sl .* sin(deg2rad(angle)) .* lg;
    sy = sl .* cos(deg2rad(angle)) .* lg;
    sx2 = sl .* sin(deg2rad(angle2)) .* lg2;
    sy2 = sl .* cos(deg2rad(angle2)) .* lg2;
    sx3 = sl .* sin(deg2rad(angle3)) .* lg3;
    sy3 = sl .* cos(deg2rad(angle3)) .* lg3;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat(XYCOORD(:,:));
    x1 = [rot90(a(:,1)-sx(:));rot90(a(:,1)+sx(:))];
    y1 = [rot90(a(:,2)-sy(:));rot90(a(:,2)+sy(:))];
    x2 = [rot90(a(:,1)-sx2(:));rot90(a(:,1)+sx2(:))];
    y2 = [rot90(a(:,2)-sy2(:));rot90(a(:,2)+sy2(:))];
    x3 = [rot90(a(:,1)-sx3(:));rot90(a(:,1)+sx3(:))];
    y3 = [rot90(a(:,2)-sy3(:));rot90(a(:,2)+sy3(:))];
    else
    x1 = [rot90(XYCOORD(:,1)-sx(:));rot90(XYCOORD(:,1)+sx(:))];
    y1 = [rot90(XYCOORD(:,2)-sy(:));rot90(XYCOORD(:,2)+sy(:))];
    x2 = [rot90(XYCOORD(:,1)-sx2(:));rot90(XYCOORD(:,1)+sx2(:))];
    y2 = [rot90(XYCOORD(:,2)-sy2(:));rot90(XYCOORD(:,2)+sy2(:))];
    x3 = [rot90(XYCOORD(:,1)-sx3(:));rot90(XYCOORD(:,1)+sx3(:))];
    y3 = [rot90(XYCOORD(:,2)-sy3(:));rot90(XYCOORD(:,2)+sy3(:))];
    end
    h1 = plot(hax,x1,y1,'Color','r','LineWidth',1);
    h2 = plot(hax,x2,y2,'Color','b','LineWidth',1);
    h3 = plot(hax,x3,y3,'Color','g','LineWidth',1);
    legend([h1(1) h2(1) h3(1)],'Sigma-1','Sigma-2','Sigma-3');
end
