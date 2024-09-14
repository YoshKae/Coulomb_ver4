function displ_open2(scl)
% For rendering the displacement vectors

global H_MAIN A_MAIN
global FIXX FIXY FIXFLAG
global H_VERTICAL_DISPL COLORSN
global COULOMB_RIGHT COULOMB_UP COULOMB_PREF COULOMB_RAKE
global EC_RAKE EC_STRESS_TYPE EC_NORMAL
global F3D_SLIP_TYPE
global LON_PER_X LAT_PER_Y
global VIEW_AZ VIEW_EL

global INPUT_VARS
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global GRAPHICS_VARS
global SYSTEM_VARS

if isempty(GRAPHICS_VARS.GRAPHICS_VARS.C_SAT) == 1
    GRAPHICS_VARS.GRAPHICS_VARS.C_SAT = 5;      % default color saturation value is 5 bars
end

if CALC_CONTROL.FUNC_SWITCH == 1 || CALC_CONTROL.FUNC_SWITCH == 10
    dummy = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
else
    if SYSTEM_VARS.OUTFLAG == 1 || isempty(SYSTEM_VARS.OUTFLAG) == 1
        cd output_files;
    else
        cd (SYSTEM_VARS.PREF_DIR);
    end
    fid = fopen('Displacement.cou','r');
    coul = textscan(fid,'%f %f %f %f %f %f','delimiter','\t','headerlines',3);
    fclose (fid);

    cd (SYSTEM_VARS.HOME_DIR);
    % cell to matrices
    ux = [coul{4}];
    uy = [coul{5}];
    uz = [coul{6}];    
    uux = reshape(ux,length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
    uuy = reshape(uy,length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
    uuz = reshape(uz,length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
    hold on;
end

%-----------    Horizontal displ. mapview  ---------------------------
if CALC_CONTROL.FUNC_SWITCH == 2 || CALC_CONTROL.FUNC_SWITCH == 3
    grid_drawing2;
    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    hold on;
    % resizing using "Exaggeration" in input file and slider value (scl)
    % notice that uux, uuy, and uuz are "m" unit but now looks "km"
    % that's why I use "/1000"
    resz = double((INPUT_VARS.SIZE(3,1)/1000)*scl);
    if FIXFLAG == 0       % no fixed point
        if CALC_CONTROL.FUNC_SWITCH == 2  % VECTOR PLOT
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                a = xy2lonlat([reshape(COORD_VARS.XGRID,length(COORD_VARS.XGRID),1) zeros(length(COORD_VARS.XGRID),1)]);
                b = xy2lonlat([zeros(length(COORD_VARS.YGRID),1) reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1)]);
                a1 = quiver(a(:,1),b(:,2),uux*LON_PER_X*resz,uuy*LAT_PER_Y*resz,0);
            else
                a1 = quiver(COORD_VARS.XGRID,COORD_VARS.YGRID,uux*resz,uuy*resz,0);
            end
            hold on;
        else                % CALC_CONTROL.FUNC_SWITCH == 3 (distorted wireframe)
            xds = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
            yds = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                a = xy2lonlat([reshape(COORD_VARS.XGRID,length(COORD_VARS.XGRID),1) zeros(length(COORD_VARS.XGRID),1)]);
                b = xy2lonlat([zeros(length(COORD_VARS.YGRID),1) reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1)]);
                xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(b(:,2)),1);
                yds = repmat(reshape(b(:,2),length(b(:,2)),1),1,length(a(:,1)));   
            else
                xds = repmat(COORD_VARS.XGRID,length(COORD_VARS.YGRID),1);
                yds = repmat(reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1),1,length(COORD_VARS.XGRID));
            end
            for k = 1:length(COORD_VARS.XGRID)
                hold on;
                if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                    a1 = plot(xds(:,k)+uux(:,k)*LON_PER_X*resz,yds(:,k)+uuy(:,k)*LAT_PER_Y*resz,'Color','b');
                else
                    a1 = plot(xds(:,k)+uux(:,k)*resz,yds(:,k)+uuy(:,k)*resz,'Color','b');
                end
            end
            for k = 1:length(COORD_VARS.YGRID)
                hold on;
                if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                    a1 = plot(xds(k,:)+uux(k,:)*LON_PER_X*resz,yds(k,:)+uuy(k,:)*LAT_PER_Y*resz,'Color','b');
                else
                    a1 = plot(xds(k,:)+uux(k,:)*resz,yds(k,:)+uuy(k,:)*resz,'Color','b');
                end
            end
        end
    else                    % recalculate displacement for the fixed point
        [m, n] = size(OKADA_OUTPUT.DC3D);
        dc3d_keep = zeros(m,n,'double');
        dc3d_keep = OKADA_OUTPUT.DC3D;
        Okada_halfspace_one;
        a = OKADA_OUTPUT.DC3D(:,1:2);    %xx, yy
        b = OKADA_OUTPUT.DC3D(:,5:8);    %zz, UX, UY, UZ
        c = horzcat(a,b);   %now 1x6 matrix
        OKADA_OUTPUT.DC3D = dc3d_keep;
        if CALC_CONTROL.FUNC_SWITCH == 2  % VECTOR PLOT
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                a = xy2lonlat([reshape(COORD_VARS.XGRID,length(COORD_VARS.XGRID),1) zeros(length(COORD_VARS.XGRID),1)]);
                b = xy2lonlat([zeros(length(COORD_VARS.YGRID),1) reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1)]);
                a1 = quiver(a(:,1),b(:,2),(uux-c(:,4))*LON_PER_X*resz,(uuy-c(:,5))*LAT_PER_Y*resz,0);
            else
                a1 = quiver(COORD_VARS.XGRID,COORD_VARS.YGRID,(uux-c(:,4))*resz,(uuy-c(:,5))*resz,0);
            end
            hold on;
        else                % CALC_CONTROL.FUNC_SWITCH == 3 (distorted wireframe)
            xds = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
            yds = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                a  = xy2lonlat([reshape(COORD_VARS.XGRID,length(COORD_VARS.XGRID),1) reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1)]);
                xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(a(:,2)),1);
                yds = repmat(reshape(a(:,2),length(a(:,2)),1),1,length(a(:,1)));           
            else
                xds = repmat(COORD_VARS.XGRID,length(COORD_VARS.YGRID),1);
                yds = repmat(reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1),1,length(COORD_VARS.XGRID));
            end
            for k = 1:length(COORD_VARS.XGRID)
                hold on;
                if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                    a1 = plot(xds(:,k) + (uux(:,k)-c(4))*LON_PER_X*resz,yds(:,k) + (uuy(:,k)-c(5))*LAT_PER_Y*resz,'Color','b');
                else
                    a1 = plot(xds(:,k) + (uux(:,k)-c(4))*resz,yds(:,k) + (uuy(:,k)-c(5))*resz,'Color','b');
                end
                set(a1,'Color',SYSTEM_VARS.PREF(2,1:3),'LineWidth',SYSTEM_VARS.PREF(2,4));
            end
            for k = 1:length(COORD_VARS.YGRID)
                hold on;
                if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                    a1 = plot(xds(k,:) + (uux(k,:)-c(4))*LON_PER_X*resz,yds(k,:) + (uuy(k,:)-c(5))*LAT_PER_Y*resz,'Color','b');
                else
                    a1 = plot(xds(k,:) + (uux(k,:)-c(4))*resz,yds(k,:) + (uuy(k,:)-c(5))*resz,'Color','b');
                end
            end
        end
        plot(FIXX,FIXY,'ro');
        hold on;
    end

            
    if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
        a = xy2lonlat([reshape(COORD_VARS.XGRID,length(COORD_VARS.XGRID),1) zeros(length(COORD_VARS.XGRID),1)]);
        b = xy2lonlat([zeros(length(COORD_VARS.YGRID),1) reshape(COORD_VARS.YGRID,length(COORD_VARS.YGRID),1)]);
        xinc = a(2,1)-a(1,1);
        yinc = b(2,2)-b(1,2);
        [unit,unitText] = check_unit_vector(COORD_VARS.XGRID(1),COORD_VARS.XGRID(end),1.0*resz,0.15,0.4);
        a0 = quiver((a(1,1)+xinc),(b(1,2)+yinc*1.5),unit*LON_PER_X*resz,0.,0); %scale vector
        h = text((a(1,1)+unit*LON_PER_X*resz*0.5),(b(1,2)+yinc*2.2),unitText);
    else
        xinc = COORD_VARS.XGRID(2)-COORD_VARS.XGRID(1);
        yinc = COORD_VARS.YGRID(2)-COORD_VARS.YGRID(1);
        [unit,unitText] = check_unit_vector(COORD_VARS.XGRID(1),COORD_VARS.XGRID(end),1.0*resz,0.15,0.4);
        a0 = quiver((COORD_VARS.XGRID(1)+xinc),(COORD_VARS.YGRID(1)+yinc*1.5),unit*resz,0.,0); %scale vector
        h = text(COORD_VARS.XGRID(1)+unit*resz*0.5,COORD_VARS.YGRID(1)+yinc*2.2,unitText);
    end

    set(a1,'Color',SYSTEM_VARS.PREF(2,1:3),'LineWidth',SYSTEM_VARS.PREF(2,4));
    set(a0,'Color','r','LineWidth',1.2);
    set(h,'FontName','Helvetica','Fontsize',14,'Color','r','FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','bottom');
    hold on;
    fault_overlay;
    hold on;
    A_MAIN = gca;

    %-----------    Vertical displ. mapview  ---------------------------
elseif CALC_CONTROL.FUNC_SWITCH == 4
    grid_drawing2;
    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    hold on;
    a1 = 1; %dummy
    OKADA_OUTPUT.CC = zeros(length(COORD_VARS.YGRID),length(COORD_VARS.XGRID),'double');
    OKADA_OUTPUT.CC = reshape(uuz,length(COORD_VARS.YGRID),length(COORD_VARS.XGRID));
    OKADA_OUTPUT.CC = OKADA_OUTPUT.CC(length(COORD_VARS.YGRID):-1:1,:);
    buffer = 1.0;
    cmax = max(reshape(max(abs(OKADA_OUTPUT.CC)),length(COORD_VARS.XGRID),1));
    cmin = min(reshape(min(abs(OKADA_OUTPUT.CC)),length(COORD_VARS.XGRID),1));
    cmean = mean(reshape(mean(abs(OKADA_OUTPUT.CC)),length(COORD_VARS.XGRID),1));
    COLORSN = cmean;
    coulomb_view(cmean);
    hold on;
    fault_overlay;
    hold off;
    a = cmax - cmin;
    if a > 10.0
        GRAPHICS_VARS.CONT_INTERVAL = 1;
    elseif a > 5.0
        GRAPHICS_VARS.CONT_INTERVAL = 0.5;
    elseif a > 1.0
        GRAPHICS_VARS.CONT_INTERVAL = 0.1;
    else
        GRAPHICS_VARS.CONT_INTERVAL = 0.01;
    end

    H_VERTICAL_DISPL = vertical_displ_window;
    set(findobj('Tag','vd_slider'),'Max',cmax);
    set(findobj('Tag','vd_slider'),'Min',cmin);
    set(findobj('Tag','vd_slider'),'Value',cmean);
    set(findobj('Tag','edit_vd_color_sat'),'String',num2str(cmean,'%6.3f'));
    set(findobj('Tag','pushbutton_vd_crosssection'),'Enable','off');

    %-----------    3 dimensional displ. view  ---------------------------
elseif CALC_CONTROL.FUNC_SWITCH == 5 || CALC_CONTROL.FUNC_SWITCH == 1 ...
        || CALC_CONTROL.FUNC_SWITCH == 5.5 || CALC_CONTROL.FUNC_SWITCH == 5.7 ...
        || CALC_CONTROL.FUNC_SWITCH == 10
	if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
        nx = length(COORD_VARS.XGRID); ny = length(COORD_VARS.YGRID);
        ax = xy2lonlat([rot90(COORD_VARS.XGRID) ones(nx,1)*(COORD_VARS.YGRID(1)+COORD_VARS.YGRID(end))/2.]);
        ay = xy2lonlat([ones(ny,1)*(COORD_VARS.XGRID(1)+COORD_VARS.XGRID(end))/2. rot90(COORD_VARS.YGRID)]);
        xx = fliplr(rot90(ax(:,1)));
        yy = fliplr(rot90(ay(:,2)));
    else
        xx = COORD_VARS.XGRID;
        yy = COORD_VARS.YGRID;
    end
    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    switch SYSTEM_VARS.PREF(7,1)
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
    resz = (INPUT_VARS.SIZE(3,1)/1000)*scl;
    if CALC_CONTROL.FUNC_SWITCH == 1 || CALC_CONTROL.FUNC_SWITCH == 10
        topz = 0.0;
    elseif CALC_CONTROL.FUNC_SWITCH == 5.7
        set(H_MAIN,'Colormap',jet);
        topz = max(rot90(max(uuz*double(resz))));   %top depth
        [xm,ym] = meshgrid(xx,yy);
        zm = ones(length(yy),length(xx))*(-1.0)*INPUT_VARS.CALC_DEPTH;
        hold on;
        mesh(xx,yy,zm); hidden off; hold on;
    	if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            uux = (uux) * double(resz) * LON_PER_X;
            uuy = (uuy) * double(resz) * LAT_PER_Y;
            quiver3(xm,ym,zm,uux,uuy,uuz*double(resz),0);
        else
            quiver3(xm,ym,zm,uux*double(resz),uuy*double(resz),uuz*double(resz),0);
        end
    elseif CALC_CONTROL.FUNC_SWITCH == 5.5
        topz = max(rot90(max(uuz*double(resz))));   %top depth
        hold on;
        mesh(xx,yy,uuz*double(resz)-INPUT_VARS.CALC_DEPTH); hidden off;
    else
        topz = max(rot90(max(uuz*double(resz))));   %top depth
        hold on;
        surf(xx,yy,uuz*double(resz)-INPUT_VARS.CALC_DEPTH);
    end
	if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
        xlim([COORD_VARS.MIN_LON,COORD_VARS.MAX_LON]);
        ylim([COORD_VARS.MIN_LAT,COORD_VARS.MAX_LAT]);
        xlabel('Lon (deg)'); ylabel('Lat (deg)'); zlabel('Z (km)'); 
        xyz_aspect = [LON_PER_X LAT_PER_Y 1.0];
    else
        xlim([min(COORD_VARS.XGRID),max(COORD_VARS.XGRID)]);
        ylim([min(COORD_VARS.YGRID),max(COORD_VARS.YGRID)]);
        xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
        xyz_aspect = [COORD_VARS.XY_RATIO 1 1];
    end

    try
        % for some reason it does not work so I cannot help using global variable.
        view(VIEW_AZ,VIEW_EL);
    catch
        view(15,40);        % default veiw parameters (azimuth,elevation)
    end

    hold on;
    % INPUT_VARS.ELEMENT
    % Each fault element
    %       INPUT_VARS.ELEMENT(:,1) xstart (km)
    %       INPUT_VARS.ELEMENT(:,2) ystart (km)
    %       INPUT_VARS.ELEMENT(:,3) xfinish (km)
    %       INPUT_VARS.ELEMENT(:,4) yfinish (km)
    %       INPUT_VARS.ELEMENT(:,5) right-lat. slip (m)
    %       INPUT_VARS.ELEMENT(:,6) reverse slip (m)
    %       INPUT_VARS.ELEMENT(:,7) dip (degree)
    %       INPUT_VARS.ELEMENT(:,8) fault top depth (km)
    %       INPUT_VARS.ELEMENT(:,9) fault bottom depth (km)
    depth_max = 0.0;

    if isempty(OKADA_OUTPUT.S_ELEMENT) == 1
        OKADA_OUTPUT.S_ELEMENT = zeros(INPUT_VARS.NUM,10);
        OKADA_OUTPUT.S_ELEMENT = [INPUT_VARS.ELEMENT double(INPUT_VARS.KODE)];
        m = INPUT_VARS.NUM;
    else
        [m, n] = size(OKADA_OUTPUT.S_ELEMENT);
    end

    if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
        mm = size(OKADA_OUTPUT.S_ELEMENT,1);
        temp_element = OKADA_OUTPUT.S_ELEMENT(:,1:4);
        a = xy2lonlat([OKADA_OUTPUT.S_ELEMENT(:,1) OKADA_OUTPUT.S_ELEMENT(:,2)]);
        b = xy2lonlat([OKADA_OUTPUT.S_ELEMENT(:,3) OKADA_OUTPUT.S_ELEMENT(:,4)]);
        OKADA_OUTPUT.S_ELEMENT(:,1) = a(:,1);
        OKADA_OUTPUT.S_ELEMENT(:,2) = a(:,2);
        OKADA_OUTPUT.S_ELEMENT(:,3) = b(:,1);
        OKADA_OUTPUT.S_ELEMENT(:,4) = b(:,2); 
    end    

    %--- for coloring amount of fault slip for grid 3D
    slip_max = 0.0;
    slip_min = 0.0;
    for k = 1:m
        if int16(OKADA_OUTPUT.S_ELEMENT(k,10))==100
            if F3D_SLIP_TYPE == 1
                sl = sqrt(OKADA_OUTPUT.S_ELEMENT(k,5)^2.0 + OKADA_OUTPUT.S_ELEMENT(k,6)^2.0);
            elseif F3D_SLIP_TYPE == 2
                sl = OKADA_OUTPUT.S_ELEMENT(k,5);
            else
                sl = OKADA_OUTPUT.S_ELEMENT(k,6);
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
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            dist = sqrt((temp_element(k,3)-temp_element(k,1))^2+(temp_element(k,4)-temp_element(k,2))^2);
        else
            dist = sqrt((OKADA_OUTPUT.S_ELEMENT(k,3)-OKADA_OUTPUT.S_ELEMENT(k,1))^2+(OKADA_OUTPUT.S_ELEMENT(k,4)-OKADA_OUTPUT.S_ELEMENT(k,2))^2);
        end
        hh = sin(deg2rad(OKADA_OUTPUT.S_ELEMENT(k,7)));
        if hh == 0.0
            hh = 0.000001;
        end
        ddip_length = (OKADA_OUTPUT.S_ELEMENT(k,9)-OKADA_OUTPUT.S_ELEMENT(k,8))/hh;
        middepth = (OKADA_OUTPUT.S_ELEMENT(k,9)+OKADA_OUTPUT.S_ELEMENT(k,8))/2.0;
        
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            e = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
                temp_element(k,4),OKADA_OUTPUT.S_ELEMENT(k,7),OKADA_OUTPUT.S_ELEMENT(k,8),middepth);
            e1 = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
                temp_element(k,4),OKADA_OUTPUT.S_ELEMENT(k,7),OKADA_OUTPUT.S_ELEMENT(k,8),OKADA_OUTPUT.S_ELEMENT(k,9));
        else
            e = fault_corners(OKADA_OUTPUT.S_ELEMENT(k,1),OKADA_OUTPUT.S_ELEMENT(k,2),OKADA_OUTPUT.S_ELEMENT(k,3),OKADA_OUTPUT.S_ELEMENT(k,4),...
                OKADA_OUTPUT.S_ELEMENT(k,7),OKADA_OUTPUT.S_ELEMENT(k,8),middepth);
        end
        xc = (e(3,1)+e(4,1))/2.0;
        yc = (e(3,2)+e(4,2))/2.0; 
        xcs = xc - ddip_length/2.0;
        xcf = xc + ddip_length/2.0;
        ycs = yc - dist/2.0;
        ycf = yc + dist/2.0;

        % determin fill color
        if CALC_CONTROL.FUNC_SWITCH ~= 10
            c_index = zeros(64,3);
            switch SYSTEM_VARS.PREF(7,1)
                case 1
                    c_index = colormap(jet);
                case 2
                    if F3D_SLIP_TYPE == 1 & CALC_CONTROL.FUNC_SWITCH == 1
                        c_index = colormap(GRAPHICS_VARS.SEIS_RATE);
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

                sb = 1.0;           % in case
            end

            if isempty(SYSTEM_VARS.C_SLIP_SAT)
                SYSTEM_VARS.C_SLIP_SAT = sb;
            end
            c_unit = (SYSTEM_VARS.C_SLIP_SAT + SYSTEM_VARS.C_SLIP_SAT) / 64;

            if F3D_SLIP_TYPE == 1
                c_unit = SYSTEM_VARS.C_SLIP_SAT / 64;
            	rgb = sqrt(OKADA_OUTPUT.S_ELEMENT(k,5)^2.0 + OKADA_OUTPUT.S_ELEMENT(k,6)^2.0) / c_unit;
            elseif F3D_SLIP_TYPE == 2
            	rgb = (OKADA_OUTPUT.S_ELEMENT(k,5) + SYSTEM_VARS.C_SLIP_SAT) / c_unit;
            else
            	rgb = (OKADA_OUTPUT.S_ELEMENT(k,6) + SYSTEM_VARS.C_SLIP_SAT) / c_unit;
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
            switch SYSTEM_VARS.PREF(7,1)
                case 1
                    c_index = colormap(jet);
                case 2
                    c_index = colormap(ANATOLIA);                
                case 3
                    temp = gray;
                    temp = flipud(temp);
                    c_index = colormap(temp);                  
            end
            c_unit = GRAPHICS_VARS.GRAPHICS_VARS.C_SAT * 2.0 / 64;
            if isempty(EC_STRESS_TYPE)==1
                EC_STRESS_TYPE = 1;         % default
            end
            if EC_STRESS_TYPE == 1
                rgb = COULOMB_RIGHT(k) / GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
            elseif EC_STRESS_TYPE == 2
                rgb = COULOMB_UP(k) / GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
            elseif EC_STRESS_TYPE == 3
                rgb = COULOMB_PREF(k) / GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
            elseif EC_STRESS_TYPE == 4
                temp = isnan(COULOMB_RAKE(k));
                rgb = COULOMB_RAKE(k) / GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
                if temp == 1
                    rgb = 0.0;
                end
            else
                rgb = EC_NORMAL(k) / GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
            end
        end
        
        if rgb > 1.0
            fcolor = c_index(64,:);
        elseif rgb <= -1.0
            fcolor = c_index(1,:); 
        else
            ni = int8(round((rgb*GRAPHICS_VARS.GRAPHICS_VARS.C_SAT + GRAPHICS_VARS.GRAPHICS_VARS.C_SAT) / c_unit))+1;
            if ni > 64
                ni = 64;    % in case
            end
            fcolor = c_index(ni,:);
        end
    end
    
    if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    else
        b  = fill([xcs xcf xcf xcs xcs],[ycf ycf ycs ycs ycf],fcolor);
	end
    
	axis equal;
    if OKADA_OUTPUT.S_ELEMENT(k,9) > depth_max
        depth_max = OKADA_OUTPUT.S_ELEMENT(k,9);
    end
    zlim([-depth_max*2.0 topz+1]);
    
    if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
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
        rdip = deg2rad(OKADA_OUTPUT.S_ELEMENT(k,7));
    else
        denom = OKADA_OUTPUT.S_ELEMENT(k,3)-OKADA_OUTPUT.S_ELEMENT(k,1);
        if denom == 0
            a = atan((OKADA_OUTPUT.S_ELEMENT(k,4)-OKADA_OUTPUT.S_ELEMENT(k,2))/0.000001);        
        else
            a = atan((OKADA_OUTPUT.S_ELEMENT(k,4)-OKADA_OUTPUT.S_ELEMENT(k,2))/(OKADA_OUTPUT.S_ELEMENT(k,3)-OKADA_OUTPUT.S_ELEMENT(k,1)));
        end
        if OKADA_OUTPUT.S_ELEMENT(k,1) > OKADA_OUTPUT.S_ELEMENT(k,3)
            rstr = 1.5 * pi - a;
        else
            rstr = pi / 2.0 - a;
        end
        rdip = deg2rad(OKADA_OUTPUT.S_ELEMENT(k,7));
    end
    
	if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
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
    if SYSTEM_VARS.IMAXSHEAR == 2
        adj = 2.0;
        offset = 0.2;
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            unit_arrow = sqrt((temp_element(k,3)-temp_element(k,1))^2.0+(temp_element(k,4)-temp_element(k,2))^2.0) * 0.03;
            z0 = (OKADA_OUTPUT.S_ELEMENT(k,8)+OKADA_OUTPUT.S_ELEMENT(k,9))/2.0;
            fc = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),temp_element(k,4),OKADA_OUTPUT.S_ELEMENT(k,7),OKADA_OUTPUT.S_ELEMENT(k,8),z0);
        else
            unit_arrow = sqrt((OKADA_OUTPUT.S_ELEMENT(k,3)-OKADA_OUTPUT.S_ELEMENT(k,1))^2.0+(OKADA_OUTPUT.S_ELEMENT(k,4)-OKADA_OUTPUT.S_ELEMENT(k,2))^2.0) * 0.03;
            z0 = (OKADA_OUTPUT.S_ELEMENT(k,8)+OKADA_OUTPUT.S_ELEMENT(k,9))/2.0;
            fc = fault_corners(OKADA_OUTPUT.S_ELEMENT(k,1),OKADA_OUTPUT.S_ELEMENT(k,2),OKADA_OUTPUT.S_ELEMENT(k,3),OKADA_OUTPUT.S_ELEMENT(k,4),...
                OKADA_OUTPUT.S_ELEMENT(k,7),OKADA_OUTPUT.S_ELEMENT(k,8),z0);
        end
        deno = fc(4,2) - fc(3,2);
        if deno == 0; deno = 0.0001; end
            x0 = (fc(4,1) + fc(3,1)) / 2.0;
            y0 = (fc(4,2) + fc(3,2)) / 2.0;
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            a = xy2lonlat([x0 y0]);
            x0 = a(1);
            y0 = a(2);
            offset = (LON_PER_X + LAT_PER_Y)/2.0 * offset;
            unit_arrow = (LON_PER_X + LAT_PER_Y)/2.0 * unit_arrow;
        end
        str = rad2deg(atan((fc(4,1) - fc(3,1)) / deno));
        if deno < 0.0
            c = obj_trans(0,-OKADA_OUTPUT.S_ELEMENT(k,7),str,0,0,0,1,1,1);
        else
            c = obj_trans(0,OKADA_OUTPUT.S_ELEMENT(k,7),str,0,0,0,1,1,1);
        end
        c1 = c.';

        % if rake is specified even without any slip (the case of CALC_CONTROL.IRAKE = 1)
        if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE == 4 || EC_STRESS_TYPE == 5
            if CALC_CONTROL.IRAKE == 1
                [latslip, dipslip] = rake2comp(CALC_CONTROL.IND_RAKE(k,1),unit_arrow);
            else
                [rake, netslip] = comp2rake(OKADA_OUTPUT.S_ELEMENT(k,5),OKADA_OUTPUT.S_ELEMENT(k,6));
                [latslip, dipslip] = rake2comp(rake,unit_arrow);
            end
        elseif EC_STRESS_TYPE == 1 % right-lat.
            [latslip, dipslip] = rake2comp(180.0,unit_arrow);
        elseif EC_STRESS_TYPE == 2 % reverse slip
            [latslip, dipslip] = rake2comp(90.0,unit_arrow);
        elseif EC_STRESS_TYPE == 3 % specified rake
            [latslip, dipslip] = rake2comp(EC_RAKE,unit_arrow);
        end
        tf1 = c1 * [-dipslip; -latslip; 0];
        tf2 = c1 * [dipslip; latslip; 0];
        % if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE ~= 5 % no rake line (slip line) for normal stress change
        hold on;
        quiver3(x0+offset,y0+offset,-z0,tf1(1)*adj,tf1(2)*adj,tf1(3)*adj,2,'Color','b','LineWidth',1.0); % plot an arrow on one side
        hold on;
        quiver3(x0-offset,y0-offset,-z0,tf2(1)*adj,tf2(2)*adj,tf2(3)*adj,2,'Color','b','LineWidth',1.0); % plot an arrow on the other side 
        
        %------ plot a circle in 'plot3d' for point source calculation -------------   
        if OKADA_OUTPUT.S_ELEMENT(k,10)==400 || OKADA_OUTPUT.S_ELEMENT(k,10)==500
            hold on;
            tm = [OKADA_OUTPUT.S_ELEMENT(k,1) OKADA_OUTPUT.S_ELEMENT(k,2) OKADA_OUTPUT.S_ELEMENT(k,3) OKADA_OUTPUT.S_ELEMENT(k,...
                4) OKADA_OUTPUT.S_ELEMENT(k,7) OKADA_OUTPUT.S_ELEMENT(k,8) OKADA_OUTPUT.S_ELEMENT(k,9)];
            fc = zeros(4,2); e_center = zeros(1,3);
            middle = (tm(6) + tm(7))/2.0;
            fc = fault_corners(tm(1),tm(2),tm(3),tm(4),tm(5),tm(6),middle);
            e_center(1,1) = (fc(4,1) + fc(3,1)) / 2.0;
            e_center(1,2) = (fc(4,2) + fc(3,2)) / 2.0;
            e_center(1,3) = -middle; 
            plot3(e_center(1,1),e_center(1,2),e_center(1,3),'ko');
        end
    end
end
%============= k loop ================== (end)

%    ---- title and legend bar -------------------------
if CALC_CONTROL.FUNC_SWITCH == 5 || CALC_CONTROL.FUNC_SWITCH == 5.5
    title('Vertical displacement (exaggerated depth)','FontSize',18);
    temp = GRAPHICS_VARS.GRAPHICS_VARS.C_SAT;
    dm = max(uuz*double(resz));
    a = isnan(dm);
    ind = find(a>0);
    dm(ind) = 0;
    GRAPHICS_VARS.GRAPHICS_VARS.C_SAT = max(rot90(dm)) * 0.3;
    %---in case (temporal solution, need to be fixed) !!!!
    if GRAPHICS_VARS.GRAPHICS_VARS.C_SAT < 0    % in case (temporal solution, need to be fixed) !!!!
        GRAPHICS_VARS.GRAPHICS_VARS.C_SAT = abs(GRAPHICS_VARS.GRAPHICS_VARS.C_SAT);
    end
    %---------
    if isnan(GRAPHICS_VARS.GRAPHICS_VARS.C_SAT)==1
        GRAPHICS_VARS.GRAPHICS_VARS.C_SAT = 1.0;
    end
    caxis([(-1.0)*GRAPHICS_VARS.GRAPHICS_VARS.C_SAT-INPUT_VARS.INPUT_VARS.CALC_DEPTH GRAPHICS_VARS.GRAPHICS_VARS.C_SAT-INPUT_VARS.INPUT_VARS.CALC_DEPTH]);
    colorbar('location','SouthOutside');
    GRAPHICS_VARS.GRAPHICS_VARS.C_SAT = temp;
elseif CALC_CONTROL.FUNC_SWITCH == 1
    if F3D_SLIP_TYPE == 1
        title('Amount of net slip on each fault (m)','FontSize',18);
        caxis([0.0 SYSTEM_VARS.C_SLIP_SAT]);
    elseif F3D_SLIP_TYPE == 2
        title('Amount of strike slip on each fault (m). Right lat. positive','FontSize',18);
        caxis([-SYSTEM_VARS.C_SLIP_SAT SYSTEM_VARS.C_SLIP_SAT]);
    else
        title('Amount of dip slip on each fault patch (m). Reverse. positive','FontSize',18);
        caxis([-SYSTEM_VARS.C_SLIP_SAT SYSTEM_VARS.C_SLIP_SAT]);
    end
    colorbar('location','SouthOutside');
elseif CALC_CONTROL.FUNC_SWITCH == 10
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
    caxis([(-1.0)*GRAPHICS_VARS.GRAPHICS_VARS.C_SAT GRAPHICS_VARS.GRAPHICS_VARS.C_SAT]);
    colorbar('location','SouthOutside');
elseif CALC_CONTROL.FUNC_SWITCH == 5.7
    title('3D displacement vectors','FontSize',18);
end

if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    xlim([COORD_VARS.MIN_LON,COORD_VARS.MAX_LON]);
    ylim([COORD_VARS.MIN_LAT,COORD_VARS.MAX_LAT]);
else
    xlim([min(COORD_VARS.XGRID),max(COORD_VARS.XGRID)]);
    ylim([min(COORD_VARS.YGRID),max(COORD_VARS.YGRID)]);
end
daspect(xyz_aspect);
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    OKADA_OUTPUT.S_ELEMENT(:,1:4) = temp_element;
end
