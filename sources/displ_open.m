function displ_open(scl)
% For rendering the displacement vectors
% 
global XGRID YGRID CALC_DEPTH
global SIZE KODE
global H_MAIN A_MAIN
global FUNC_SWITCH
global FIXX FIXY FIXFLAG
global DC3D CC
global PREF
global H_VERTICAL_DISPL COLORSN
global ELEMENT NUM
global COULOMB_RIGHT COULOMB_UP COULOMB_PREF COULOMB_RAKE EC_NORMAL
global EC_RAKE EC_STRESS_TYPE
global C_SAT
global ANATOLIA SEIS_RATE
global S_ELEMENT
global F3D_SLIP_TYPE ICOORD LON_GRID LAT_GRID
global LON_PER_X LAT_PER_Y XY_RATIO MIN_LON MIN_LAT MAX_LON MAX_LAT
global OUTFLAG PREF_DIR HOME_DIR
global VIEW_AZ VIEW_EL IACT
global IRAKE IND_RAKE CONT_INTERVAL
global C_SLIP_SAT
global IMAXSHEAR

if isempty(C_SAT) == 1
    C_SAT = 5;      % default color saturation value is 5 bars
end

if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
    dummy = zeros(length(YGRID),length(XGRID));
else
    if OUTFLAG == 1 || isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
    fid = fopen('Displacement.cou','r');
    coul = textscan(fid,'%f %f %f %f %f %f','delimiter','\t','headerlines',3);
    fclose (fid);
%    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);
% cell to matrices
    ux = [coul{4}];
    uy = [coul{5}];
    uz = [coul{6}];    
    uux = reshape(ux,length(YGRID),length(XGRID));
    uuy = reshape(uy,length(YGRID),length(XGRID));
    uuz = reshape(uz,length(YGRID),length(XGRID));
    hold on;
end

%-----------    Horizontal displ. mapview  ---------------------------
if FUNC_SWITCH == 2 || FUNC_SWITCH == 3
grid_drawing;
set(H_MAIN,'NumberTitle','off','Menubar','figure');
hold on;
% resizing using "Exaggeration" in input file and slider value (scl)
% notice that uux, uuy, and uuz are "m" unit but now looks "km"
% that's why I use "/1000"
resz = double((SIZE(3,1)/1000)*scl);
if FIXFLAG == 0       % no fixed point
    if FUNC_SWITCH == 2  % VECTOR PLOT
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            a1 = quiver(a(:,1),b(:,2),uux*LON_PER_X*resz,uuy*LAT_PER_Y*resz,0);
        else
            a1 = quiver(XGRID,YGRID,uux*resz,uuy*resz,0);
        end
        hold on;
    else                % FUNC_SWITCH == 3 (distorted wireframe)
        xds = zeros(length(YGRID),length(XGRID));
        yds = zeros(length(YGRID),length(XGRID));
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             a  = xy2lonlat([reshape(XGRID,length(XGRID),1) reshape(YGRID,length(YGRID),1)]);
%             xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(a(:,2)),1);
%             yds = repmat(reshape(a(:,2),length(a(:,2)),1),1,length(a(:,1)));  
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(b(:,2)),1);
            yds = repmat(reshape(b(:,2),length(b(:,2)),1),1,length(a(:,1)));   
        else
            xds = repmat(XGRID,length(YGRID),1);
            yds = repmat(reshape(YGRID,length(YGRID),1),1,length(XGRID));
        end
        for k = 1:length(XGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(:,k)+uux(:,k)*LON_PER_X*resz,yds(:,k)+uuy(:,k)*LAT_PER_Y*resz,...
                    'Color','b');
            else
                a1 = plot(xds(:,k)+uux(:,k)*resz,yds(:,k)+uuy(:,k)*resz,...
                    'Color','b');
            end
        end
        for k = 1:length(YGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(k,:)+uux(k,:)*LON_PER_X*resz,yds(k,:)+uuy(k,:)*LAT_PER_Y*resz,...
                    'Color','b');
            else
                a1 = plot(xds(k,:)+uux(k,:)*resz,yds(k,:)+uuy(k,:)*resz,...
                    'Color','b');
            end
        end
    end
    
else                    % recalculate displacement for the fixed point
        [m n] = size(DC3D);
        dc3d_keep = zeros(m,n,'double');
        dc3d_keep = DC3D;
    Okada_halfspace_one;
    a = DC3D(:,1:2);    %xx, yy
    b = DC3D(:,5:8);    %zz, UX, UY, UZ
    c = horzcat(a,b);   %now 1x6 matrix
    DC3D = dc3d_keep;
    if FUNC_SWITCH == 2  % VECTOR PLOT
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            a1 = quiver(a(:,1),b(:,2),(uux-c(:,4))*LON_PER_X*resz,(uuy-c(:,5))*LAT_PER_Y*resz,0);
        else
            a1 = quiver(XGRID,YGRID,(uux-c(:,4))*resz,(uuy-c(:,5))*resz,0);
        end
        hold on;
    else                % FUNC_SWITCH == 3 (distorted wireframe)
        xds = zeros(length(YGRID),length(XGRID));
        yds = zeros(length(YGRID),length(XGRID));
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a  = xy2lonlat([reshape(XGRID,length(XGRID),1) reshape(YGRID,length(YGRID),1)]);
                xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(a(:,2)),1);
                yds = repmat(reshape(a(:,2),length(a(:,2)),1),1,length(a(:,1)));           
            else
                xds = repmat(XGRID,length(YGRID),1);
                yds = repmat(reshape(YGRID,length(YGRID),1),1,length(XGRID));
            end
        for k = 1:length(XGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(:,k) + (uux(:,k)-c(4))*LON_PER_X*resz,...
                    yds(:,k) + (uuy(:,k)-c(5))*LAT_PER_Y*resz,...
                    'Color','b');
            else
                a1 = plot(xds(:,k) + (uux(:,k)-c(4))*resz,...
                    yds(:,k) + (uuy(:,k)-c(5))*resz,...
                    'Color','b');
            end
            set(a1,'Color',PREF(2,1:3),'LineWidth',PREF(2,4));
        end
        for k = 1:length(YGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(k,:) + (uux(k,:)-c(4))*LON_PER_X*resz,...
                yds(k,:) + (uuy(k,:)-c(5))*LAT_PER_Y*resz,...
                    'Color','b');
            else
                a1 = plot(xds(k,:) + (uux(k,:)-c(4))*resz,...
                yds(k,:) + (uuy(k,:)-c(5))*resz,...
                    'Color','b');
            end
        end
    end
    plot(FIXX,FIXY,'ro');
    hold on;
end


%         [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.2,0.5);
%         a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),unit*resz,0.,0); %scale vector
%         h1 = text((XGRID(1)+unit*resz*0.5),(YGRID(1)+yinc*2.2),unitText);
%         
        
if ICOORD == 2 && isempty(LON_GRID) ~= 1
%     a  = xy2lonlat([reshape(XGRID,length(XGRID),1) reshape(YGRID,length(YGRID),1)]);
%     xinc = a(2,1)-a(1,1);
%     yinc = a(2,2)-a(1,2);    
	a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
	b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
    xinc = a(2,1)-a(1,1);
    yinc = b(2,2)-b(1,2);
    [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.15,0.4);
    a0 = quiver((a(1,1)+xinc),(b(1,2)+yinc*1.5),unit*LON_PER_X*resz,0.,0); %scale vector
    h = text((a(1,1)+unit*LON_PER_X*resz*0.5),(b(1,2)+yinc*2.2),unitText);
%     a0 = quiver((a(1,1)+xinc),(b(1,2)+yinc*1.5),1.0*LON_PER_X*resz,0.,0); %scale vector (1m)
%     h = text((a(1,1)+2.0*xinc),(b(1,2)+yinc*3.0),'1m');
else
    xinc = XGRID(2)-XGRID(1);
    yinc = YGRID(2)-YGRID(1);
    [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.15,0.4);
	a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),unit*resz,0.,0); %scale vector
    h = text(XGRID(1)+unit*resz*0.5,YGRID(1)+yinc*2.2,unitText);
% 	a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),1.0*resz,0.,0); %scale vector (1m)
%     h = text((XGRID(1)+2.0*xinc),(YGRID(1)+yinc*2.2),'1m');

end

set(a1,'Color',PREF(2,1:3),'LineWidth',PREF(2,4));
set(a0,'Color','r','LineWidth',1.2);
set(h,'FontName','Helvetica','Fontsize',14,'Color','r','FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
hold on;
fault_overlay;
hold on;
A_MAIN = gca;

%-----------    Vertical displ. mapview  ---------------------------
elseif FUNC_SWITCH == 4
grid_drawing;
% set(H_MAIN,'NumberTitle','off','Menubar','figure','Name','Vertical displacement');
set(H_MAIN,'NumberTitle','off','Menubar','figure');
hold on;
a1 = 1; %dummy
% [C,h] = contour(XGRID,YGRID,uuz,10);
% if ICOORD == 2 && isempty(LON_GRID) ~= 1
%     CC = zeros(length(LAT_GRID),length(LON_GRID),'double');
%     CC = reshape(uuz,length(LAT_GRID),length(LON_GRID));
%     CC = CC(length(LAT_GRID):-1:1,:);
%     buffer = 1.0;
%     cmax = max(reshape(max(abs(CC)),length(LON_GRID),1));
%     cmin = min(reshape(min(abs(CC)),length(LON_GRID),1));
%     cmean = mean(reshape(mean(abs(CC)),length(LON_GRID),1));
% else
    CC = zeros(length(YGRID),length(XGRID),'double');
    CC = reshape(uuz,length(YGRID),length(XGRID));
    CC = CC(length(YGRID):-1:1,:);
    buffer = 1.0;
    cmax = max(reshape(max(abs(CC)),length(XGRID),1));
    cmin = min(reshape(min(abs(CC)),length(XGRID),1));
    cmean = mean(reshape(mean(abs(CC)),length(XGRID),1));
% end
% cmax = cmax + buffer;
% cmin = 0.0;
COLORSN = cmean;
coulomb_view(cmean);
hold on;
fault_overlay;
hold off;
    a = cmax - cmin;
%    if isempty(CONT_INTERVAL)
    if a > 10.0
        CONT_INTERVAL = 1;
    elseif a > 5.0
        CONT_INTERVAL = 0.5;
    elseif a > 1.0
        CONT_INTERVAL = 0.1;
    else
        CONT_INTERVAL = 0.01;
    end
%    end
H_VERTICAL_DISPL = vertical_displ_window;
set(findobj('Tag','vd_slider'),'Max',cmax);
set(findobj('Tag','vd_slider'),'Min',cmin);
set(findobj('Tag','vd_slider'),'Value',cmean);
set(findobj('Tag','edit_vd_color_sat'),'String',num2str(cmean,'%6.3f'));
set(findobj('Tag','pushbutton_vd_crosssection'),'Enable','off');

%-----------    3 dimensional displ. view  ---------------------------
elseif FUNC_SWITCH == 5 || FUNC_SWITCH == 1 ...
        || FUNC_SWITCH == 5.5 || FUNC_SWITCH == 5.7 ...
        || FUNC_SWITCH == 10
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        nx = length(XGRID); ny = length(YGRID);
        ax = xy2lonlat([rot90(XGRID) ones(nx,1)*(YGRID(1)+YGRID(end))/2.]);
        ay = xy2lonlat([ones(ny,1)*(XGRID(1)+XGRID(end))/2. rot90(YGRID)]);
        xx = fliplr(rot90(ax(:,1)));
        yy = fliplr(rot90(ay(:,2)));
    else
        xx = XGRID;
        yy = YGRID;
    end
set(H_MAIN,'NumberTitle','off','Menubar','figure');
        switch PREF(7,1)
            case 1
                set(H_MAIN,'Colormap',jet);
            case 2
                set(H_MAIN,'Colormap',ANATOLIA);              
            case 3
                temp = gray;
                temp = flipud(temp);
            	c_index = colormap(temp);                        
        end
hold on;
resz = (SIZE(3,1)/1000)*scl;
if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
    topz = 0.0;
elseif FUNC_SWITCH == 5.7
    set(H_MAIN,'Colormap',jet);
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    [xm,ym] = meshgrid(xx,yy);
    zm = ones(length(yy),length(xx))*(-1.0)*CALC_DEPTH;
	hold on;
    mesh(xx,yy,zm); hidden off; hold on;
    	if ICOORD == 2 && isempty(LON_GRID) ~= 1
            uux = (uux) * double(resz) * LON_PER_X;
            uuy = (uuy) * double(resz) * LAT_PER_Y;
            quiver3(xm,ym,zm,uux,uuy,uuz*double(resz),0);
        else
            quiver3(xm,ym,zm,uux*double(resz),uuy*double(resz),uuz*double(resz),0);
        end
elseif FUNC_SWITCH == 5.5
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    hold on;
    mesh(xx,yy,uuz*double(resz)-CALC_DEPTH); hidden off;
else
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    hold on;
 	surf(xx,yy,uuz*double(resz)-CALC_DEPTH);
end
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        xlim([MIN_LON,MAX_LON]);
        ylim([MIN_LAT,MAX_LAT]);
        xlabel('Lon (deg)'); ylabel('Lat (deg)'); zlabel('Z (km)'); 
        xyz_aspect = [LON_PER_X LAT_PER_Y 1.0];
    else
        xlim([min(XGRID),max(XGRID)]);
        ylim([min(YGRID),max(YGRID)]);
        xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
        xyz_aspect = [XY_RATIO 1 1];
    end
    try
%         azm = str2num(get(findobj('Tag','edit_view_az'),'String'));
%         elv = str2num(get(findobj('Tag','edit_view_el'),'String'));
%               view(azm,elv);
% for some reason it does not work so I cannot help using global variable.
        view(VIEW_AZ,VIEW_EL);
    catch
%        disp('error');
        view(15,40);        % default veiw parameters (azimuth,elevation)
    end
hold on;
% ELEMENT
% Each fault element
%       ELEMENT(:,1) xstart (km)
%       ELEMENT(:,2) ystart (km)
%       ELEMENT(:,3) xfinish (km)
%       ELEMENT(:,4) yfinish (km)
%       ELEMENT(:,5) right-lat. slip (m)
%       ELEMENT(:,6) reverse slip (m)
%       ELEMENT(:,7) dip (degree)
%       ELEMENT(:,8) fault top depth (km)
%       ELEMENT(:,9) fault bottom depth (km)
    depth_max = 0.0;

if isempty(S_ELEMENT) == 1
    S_ELEMENT = zeros(NUM,10);
    S_ELEMENT = [ELEMENT double(KODE)];
    m = NUM;
else
    [m n] = size(S_ELEMENT);
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
mm = size(S_ELEMENT,1);
temp_element = S_ELEMENT(:,1:4);
    a = xy2lonlat([S_ELEMENT(:,1) S_ELEMENT(:,2)]);
    b = xy2lonlat([S_ELEMENT(:,3) S_ELEMENT(:,4)]);
    S_ELEMENT(:,1) = a(:,1);
    S_ELEMENT(:,2) = a(:,2);
    S_ELEMENT(:,3) = b(:,1);
    S_ELEMENT(:,4) = b(:,2); 
% else
%     temp_element = S_ELEMENT(:,1:4);
end    

%--- for coloring amount of fault slip for grid 3D
slip_max = 0.0;
slip_min = 0.0;
for k = 1:m
    if int16(S_ELEMENT(k,10))==100
        if F3D_SLIP_TYPE == 1
            sl = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0);
        elseif F3D_SLIP_TYPE == 2
            sl = S_ELEMENT(k,5);
        else
            sl = S_ELEMENT(k,6);
        end
        if sl > slip_max
            slip_max = sl;
        end
        if sl < slip_min
            slip_min = sl;
        end
    else
        sl = 0.0;
    end
end
%---

%============= k loop ================== (start)
for k = 1:m
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
    dist = sqrt((temp_element(k,3)-temp_element(k,1))^2+(temp_element(k,4)...
        -temp_element(k,2))^2);
    else
    dist = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2+(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2);
    end
    hh = sin(deg2rad(S_ELEMENT(k,7)));
    if hh == 0.0
        hh = 0.000001;
    end
    ddip_length = (S_ELEMENT(k,9)-S_ELEMENT(k,8))/hh;
    middepth = (S_ELEMENT(k,9)+S_ELEMENT(k,8))/2.0;
    
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
	e = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
        temp_element(k,4),S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
    e1 = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
        temp_element(k,4),S_ELEMENT(k,7),S_ELEMENT(k,8),S_ELEMENT(k,9));
    else
	e = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
        S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
    end
    xc = (e(3,1)+e(4,1))/2.0;
    yc = (e(3,2)+e(4,2))/2.0; 
    xcs = xc - ddip_length/2.0;
    xcf = xc + ddip_length/2.0;
    ycs = yc - dist/2.0;
    ycf = yc + dist/2.0;
% determin fill color
    if FUNC_SWITCH ~= 10
        c_index = zeros(64,3);
        switch PREF(7,1)
            case 1
            	c_index = colormap(jet);
            case 2
                if F3D_SLIP_TYPE == 1 & FUNC_SWITCH == 1
            	c_index = colormap(SEIS_RATE);
                else
            	c_index = colormap(ANATOLIA);
                end
            case 3
                temp = gray;
                temp = flipud(temp);
            	c_index = colormap(temp);                         
        end

        if abs(slip_min) > abs(slip_max)
                    sb = abs(slip_min);
        else
                    sb = abs(slip_max);
        end
        if slip_max == 0.0 && slip_min == 0.0
%            disp('No source slip is found. See the input file.');
            sb = 1.0;           % in case
        end
            if isempty(C_SLIP_SAT)
                C_SLIP_SAT = sb;
            end
            c_unit = (C_SLIP_SAT + C_SLIP_SAT) / 64;
%             c_unit = (sb + sb) / 64;
            if F3D_SLIP_TYPE == 1
                c_unit = C_SLIP_SAT / 64;
%                 c_unit = sb / 64;
            	rgb = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0) / c_unit;
            elseif F3D_SLIP_TYPE == 2
%             	rgb = (S_ELEMENT(k,5) + sb) / c_unit;
            	rgb = (S_ELEMENT(k,5) + C_SLIP_SAT) / c_unit;
            else
%             	rgb = (S_ELEMENT(k,6) + sb) / c_unit;
            	rgb = (S_ELEMENT(k,6) + C_SLIP_SAT) / c_unit;
            end
        ni = int8(round(rgb));
        if ni == 0
            ni = 1;    % in case
        elseif ni > 64
            ni = 64;    % in case
        elseif ni < 0
            ni = 64;    % in caseof other than Kode 100
        end
            fcolor = c_index(ni,:);
    else
        c_index = zeros(64,3);
        switch PREF(7,1)
            case 1
            	c_index = colormap(jet);
            case 2
            	c_index = colormap(ANATOLIA);                
            case 3
                temp = gray;
                temp = flipud(temp);
            	c_index = colormap(temp);                  
        end
        c_unit = C_SAT * 2.0 / 64;
        if isempty(EC_STRESS_TYPE)==1
            EC_STRESS_TYPE = 1;         % default
        end
        if EC_STRESS_TYPE == 1
            rgb = COULOMB_RIGHT(k) / C_SAT;
        elseif EC_STRESS_TYPE == 2
            rgb = COULOMB_UP(k) / C_SAT;
        elseif EC_STRESS_TYPE == 3
            rgb = COULOMB_PREF(k) / C_SAT;
        elseif EC_STRESS_TYPE == 4
            temp = isnan(COULOMB_RAKE(k));
            rgb = COULOMB_RAKE(k) / C_SAT;
%            rgb = (COULOMB_RAKE(k)-1.0) / C_SAT;
            if temp == 1
                rgb = 0.0;
            end
        else
            rgb = EC_NORMAL(k) / C_SAT;
        end
        
        if rgb > 1.0
                    fcolor = c_index(64,:);
        elseif rgb <= -1.0
                    fcolor = c_index(1,:); 
        else
                    ni = int8(round((rgb*C_SAT + C_SAT) / c_unit))+1;
                    if ni > 64
                        ni = 64;    % in case
                    end
                    fcolor = c_index(ni,:);
        end
    end
    
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
% 	b  = fill([xc1 xc2 xc3 xc4 xc1],[yc1 yc2 yc3 yc4 yc1],fcolor);
    else
    b  = fill([xcs xcf xcf xcs xcs],[ycf ycf ycs ycs ycf],fcolor);
	end
    
	axis equal;
    if S_ELEMENT(k,9) > depth_max
        depth_max = S_ELEMENT(k,9);
    end
    zlim([-depth_max*2.0 topz+1]);
    
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        denom = temp_element(k,3)-temp_element(k,1);
        numer = temp_element(k,4)-temp_element(k,2);
        if denom == 0
        a = atan((numer)/0.000001);        
        else
        a = atan((numer)/(denom));
        end
        if temp_element(k,1) > temp_element(k,3)
            rstr = 1.5 * pi - a;
        else
            rstr = pi / 2.0 - a;
        end
        rdip = deg2rad(S_ELEMENT(k,7));
    else
        denom = S_ELEMENT(k,3)-S_ELEMENT(k,1);
        if denom == 0
        a = atan((S_ELEMENT(k,4)-S_ELEMENT(k,2))/0.000001);        
        else
        a = atan((S_ELEMENT(k,4)-S_ELEMENT(k,2))/(S_ELEMENT(k,3)-S_ELEMENT(k,1)));
        end
        if S_ELEMENT(k,1) > S_ELEMENT(k,3)
            rstr = 1.5 * pi - a;
        else
            rstr = pi / 2.0 - a;
        end
        rdip = deg2rad(S_ELEMENT(k,7));
    end
    
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         Rsc  = makehgtform('scale',[1,1,1/LON_PER_X]);
%         Rsc2 = makehgtform('scale',[1,1,1]);
%         xshift = xc;
%         yshift = yc;	
    else
    t = hgtransform;
    set(b,'Parent',t);    
	Rsc = makehgtform('scale',[1,1,1]);
	Rsc2 = makehgtform('scale',[1,1,1]);
	xshift = (xcf + xcs) / 2.0;
	yshift = (ycf + ycs) / 2.0;
    Rz = makehgtform('zrotate',double(pi-rstr));
    Rx = makehgtform('yrotate',double(-rdip));   
    Rt  = makehgtform('translate',[xshift yshift -middepth]);
	Rt2  = makehgtform('translate',[-xshift -yshift 0]);
    set(t,'Matrix',Rt*Rsc*Rz*Rsc2*Rx*Rt2);
    end
        
%----- to plot arrows on the fault (rake arrow) ----------------------

%   skip putting rake arrows to the rendering much faster!
    if IMAXSHEAR == 2
        continue
    end
%

    adj = 2.0;
    offset = 0.2;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
    unit_arrow = sqrt((temp_element(k,3)-temp_element(k,1))^2.0...
        +(temp_element(k,4)-temp_element(k,2))^2.0) * 0.03;
    z0 = (S_ELEMENT(k,8)+S_ELEMENT(k,9))/2.0;
    fc = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
        temp_element(k,4),S_ELEMENT(k,7),S_ELEMENT(k,8),z0);
    else
    unit_arrow = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2.0...
        +(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2.0) * 0.03;
    z0 = (S_ELEMENT(k,8)+S_ELEMENT(k,9))/2.0;
    fc = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
        S_ELEMENT(k,7),S_ELEMENT(k,8),z0);
    end
    deno = fc(4,2) - fc(3,2);
    if deno == 0; deno = 0.0001; end
    x0 = (fc(4,1) + fc(3,1)) / 2.0;
    y0 = (fc(4,2) + fc(3,2)) / 2.0;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([x0 y0]);
        x0 = a(1);
        y0 = a(2);
        offset = (LON_PER_X + LAT_PER_Y)/2.0 * offset;
        unit_arrow = (LON_PER_X + LAT_PER_Y)/2.0 * unit_arrow;
    end
    str = rad2deg(atan((fc(4,1) - fc(3,1)) / deno));
    if deno < 0.0
    c = obj_trans(0,-S_ELEMENT(k,7),str,0,0,0,1,1,1);
    else
    c = obj_trans(0,S_ELEMENT(k,7),str,0,0,0,1,1,1);
    end
    c1 = c.';
% if rake is specified even without any slip (the case of IRAKE = 1)
    if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE == 4 || EC_STRESS_TYPE == 5
        if IRAKE == 1
            [latslip dipslip] = rake2comp(IND_RAKE(k,1),unit_arrow);
        else
            [rake netslip] = comp2rake(S_ELEMENT(k,5),S_ELEMENT(k,6));
            [latslip dipslip] = rake2comp(rake,unit_arrow);
        end
    elseif EC_STRESS_TYPE == 1 % right-lat.
            [latslip dipslip] = rake2comp(180.0,unit_arrow);
    elseif EC_STRESS_TYPE == 2 % reverse slip
            [latslip dipslip] = rake2comp(90.0,unit_arrow);
    elseif EC_STRESS_TYPE == 3 % specified rake
            [latslip dipslip] = rake2comp(EC_RAKE,unit_arrow);
    end
        tf1 = c1 * [-dipslip; -latslip; 0];
        tf2 = c1 * [dipslip; latslip; 0];
%    if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE ~= 5      % no rake line (slip line) for normal stress change
    hold on;
	quiver3(x0+offset,y0+offset,-z0,tf1(1)*adj,tf1(2)*adj,tf1(3)*adj,2,...
         'Color','b','LineWidth',1.0); % plot an arrow on one side
    hold on;
	quiver3(x0-offset,y0-offset,-z0,tf2(1)*adj,tf2(2)*adj,tf2(3)*adj,2,...
         'Color','b','LineWidth',1.0); % plot an arrow on the other side 
%    end
     
%------ plot a circle in 'plot3d' for point source calculation -------------   
    if S_ELEMENT(k,10)==400 || S_ELEMENT(k,10)==500
        hold on;
        tm = [S_ELEMENT(k,1) S_ELEMENT(k,2) S_ELEMENT(k,3) S_ELEMENT(k,...
            4) S_ELEMENT(k,7) S_ELEMENT(k,8) S_ELEMENT(k,9)];
        fc = zeros(4,2); e_center = zeros(1,3);
        middle = (tm(6) + tm(7))/2.0;
        fc = fault_corners(tm(1),tm(2),tm(3),tm(4),tm(5),tm(6),middle);
        e_center(1,1) = (fc(4,1) + fc(3,1)) / 2.0;
        e_center(1,2) = (fc(4,2) + fc(3,2)) / 2.0;
        e_center(1,3) = -middle; 
        plot3(e_center(1,1),e_center(1,2),e_center(1,3),'ko');
    end
end
%============= k loop ================== (end)

%    ---- title and legend bar -------------------------
if FUNC_SWITCH == 5 || FUNC_SWITCH == 5.5
            	title('Vertical displacement (exaggerated depth)','FontSize',18);
                temp = C_SAT;
                dm = max(uuz*double(resz));
                a = isnan(dm);
                ind = find(a>0);
                dm(ind) = 0;
                C_SAT = max(rot90(dm)) * 0.3;
                %---in case (temporal solution, need to be fixed) !!!!
                if C_SAT < 0    % in case (temporal solution, need to be fixed) !!!!
                    C_SAT = abs(C_SAT);
                end
                %---------
                if isnan(C_SAT)==1
                    C_SAT = 1.0;
                end
                caxis([(-1.0)*C_SAT-CALC_DEPTH C_SAT-CALC_DEPTH]);
                colorbar('location','SouthOutside');
                C_SAT = temp;
elseif FUNC_SWITCH == 1
            if F3D_SLIP_TYPE == 1
            	title('Amount of net slip on each fault (m)','FontSize',18);
%                 caxis([0.0 sb]);
                caxis([0.0 C_SLIP_SAT]);
            elseif F3D_SLIP_TYPE == 2
            	title('Amount of strike slip on each fault (m). Right lat. positive','FontSize',18); 
%                 caxis([-sb sb]);
                caxis([-C_SLIP_SAT C_SLIP_SAT]);
            else
            	title('Amount of dip slip on each fault patch (m). Reverse. positive','FontSize',18); 
%                 caxis([-sb sb]);
                caxis([-C_SLIP_SAT C_SLIP_SAT]);
            end
                colorbar('location','SouthOutside');
elseif FUNC_SWITCH == 10
        switch EC_STRESS_TYPE
            case 1
            	title('Coulomb stress change for right-lat. slip (bar)','FontSize',18);
            case 2
            	title('Coulomb stress change for reverse slip (bar)','FontSize',18);
            case 3
            	title(['Coulomb stress change for specified rake ' num2str(int16(EC_RAKE)) ' deg. (bar)'],'FontSize',18);
            case 4
            	title('Coulomb stress change for individual rake (bar)','FontSize',18);
            case 5
            	title('Normal stress change (bar, unclamping positive)','FontSize',18);
            otherwise
                title('Coulomb stress change (bar)','FontSize',18);
        end
        caxis([(-1.0)*C_SAT C_SAT]);
        colorbar('location','SouthOutside');
elseif FUNC_SWITCH == 5.7
            	title('3D displacement vectors','FontSize',18);

end
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                xlim([MIN_LON,MAX_LON]);
                ylim([MIN_LAT,MAX_LAT]);
            else
                xlim([min(XGRID),max(XGRID)]);
                ylim([min(YGRID),max(YGRID)]);
            end
                 daspect(xyz_aspect);
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        S_ELEMENT(:,1:4) = temp_element;
    end   
end

