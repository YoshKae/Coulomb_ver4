function coulomb_3d_view
%COULOMB_3D_VIEW
%
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
global ANATOLIA
global S_ELEMENT
global F3D_SLIP_TYPE ICOORD LON_GRID
global LON_PER_X LAT_PER_Y XY_RATIO
global OUTFLAG PREF_DIR HOME_DIR
global VIEW_AZ VIEW_EL
global COAST_DATA AFAULT_DATA EQ_DATA

clear_obj_and_subfig;

set(H_MAIN,'HandleVisibility','on');
grid_drawing_3d; hold on;
if isempty(C_SAT) == 1 % in case
    C_SAT = 1;      % default color saturation value is 5 bars
end

%-----------    3 dimensional coulomb view  ---------------------------
set(H_MAIN,'NumberTitle','off','Menubar','figure');
        switch PREF(7,1)
            case 1
                set(H_MAIN,'Colormap',jet);
            case 2
                set(H_MAIN,'Colormap',ANATOLIA);              
            case 3
                set(H_MAIN,'Colormap',Gray);                
        end
hold on;
    topz = 0.0;   %top depth
    hold on;
    [xx,yy] = meshgrid(XGRID,YGRID);
    zz = ones(length(YGRID),length(XGRID))*(-1.0)*CALC_DEPTH;
	surf(xx,yy,zz,flipud(CC),...
        'EdgeColor','none');
    xlim([min(XGRID),max(XGRID)]);
	ylim([min(YGRID),max(YGRID)]);
	xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
        view(15,40);        % default veiw parameters (azimuth,elevation)
hold on;
    depth_max = 0.0;

if isempty(S_ELEMENT) == 1
    S_ELEMENT = zeros(NUM,10);
    S_ELEMENT = [ELEMENT double(KODE)];
    m = NUM;
else
    [m n] = size(S_ELEMENT);
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
for k = 1:m
    dist = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2+(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2);
    hh = sin(deg2rad(S_ELEMENT(k,7)));
    if hh == 0.0
        hh = 0.000001;
    end
    ddip_length = (S_ELEMENT(k,9)-S_ELEMENT(k,8))/hh;
    middepth = (S_ELEMENT(k,9)+S_ELEMENT(k,8))/2.0;
	e = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
        S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
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
            	c_index = colormap(ANATOLIA);                
            case 3
            	c_index = colormap(Gray);                  
        end

        if abs(slip_min) > abs(slip_max)
                    sb = abs(slip_min);
        else
                    sb = abs(slip_max);
        end
        if slip_max == 0.0 && slip_min == 0.0
            sb = 1.0;           % in case
        end
        
            c_unit = (sb + sb) / 64;
            if F3D_SLIP_TYPE == 1
                c_unit = sb / 64;
            	rgb = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0) / c_unit;
            elseif F3D_SLIP_TYPE == 2
            	rgb = (S_ELEMENT(k,5) + sb) / c_unit;
            else
            	rgb = (S_ELEMENT(k,6) + sb) / c_unit;
            end
        ni = int8(round(rgb));
        if ni == 0
            ni = 1;    % in case
        elseif ni > 64
            ni = 64;    % in case
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
            	c_index = colormap(Gray);                  
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
    b  = fill([xcs xcf xcf xcs xcs],[ycf ycf ycs ycs ycf],fcolor);
	axis equal;
    if S_ELEMENT(k,9) > depth_max
        depth_max = S_ELEMENT(k,9);
    end
    zlim([-depth_max*2.0 topz+1]);
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
    t = hgtransform;
    set(b,'Parent',t);
    Rz = makehgtform('zrotate',double(pi-rstr));
    Rx = makehgtform('yrotate',double(-rdip));
    xshift = (xcf + xcs) / 2.0;
    yshift = (ycf + ycs) / 2.0;
    Rt  = makehgtform('translate',[xshift yshift -middepth]);
	Rt2  = makehgtform('translate',[-xshift -yshift 0]);
    set(t,'Matrix',Rt*Rz*Rx*Rt2);
% plot a circle in 'plot3d' for point source calculation   
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

%    ---- title and legend bar -------------------------
            	title('Coulomb stress change (bar)','FontSize',18);
                caxis([-C_SAT C_SAT]);
                colorbar('location','SouthOutside');

% ----- overlay -------------------
if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
end

set(H_MAIN,'HandleVisibility','callback');
