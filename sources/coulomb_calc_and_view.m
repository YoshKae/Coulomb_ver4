global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global IACT IACTS
global STRESS_TYPE
global STRIKE DIP RAKE
global COLORSN %color saturation value
global H_SECTION H_SEC_WINDOW H_MAIN H_COULOMB
global FLAG_SLIP_LINE
global XYCOORD
global XGRID YGRID
global GRID
global DEPTH_RANGE_TYPE CALC_DEPTH_RANGE
global CC PK_DEPTH
global FLAG_PR_AXES
global INPUT_FILE COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global PHII
global OUTFLAG PREF_DIR HOME_DIR
global RECEIVERS       % matrix form for regional setting (normally empty)

%===== GRID SEARCH parameter for opt faults calc. (STRESS_TYPE==1)
% if STRESS_TYPE == 1
%     temp = 10.0;    n_gs = temp;
%     prompt = 'Enter an interval for grid search (degree).';
%     name = 'Grid interval';
%     numlines = 1;
%     options.Resize = 'on';
%     options.WindowStyle = 'normal';
%     defc = num2str(n_gs,'%4.1f');
%     answer = inputdlg(prompt,name,numlines,{defc},options);
%     if str2double(answer) <= 0.0
%         warndlg('Put any number greather than zero. Not acceptable');
%         return
%     elseif  str2double(answer) >= 50.0
%         warndlg('Too large. Not acceptable');
%         return
%     elseif isempty(answer)==1
%         return
%     end
%     n_gr = str2double(answer);
%     if isnan(n_gr) == 1 | isempty(n_gr) == 1
%         n_gr = temp;
%     end
% end
%==================================
% Figure pointer (busy...)
set(gcf,'Pointer','watch'); set(H_MAIN,'Pointer','watch'); set(H_COULOMB,'Pointer','watch');
set(findobj('Tag','crosssection_toggle'),'Enable','on');

friction = str2num(get(findobj('Tag','edit_coul_fric'),'String'));
if DEPTH_RANGE_TYPE == 0
    CALC_DEPTH =  str2num(get(findobj('Tag','edit_coul_depth'),'String'));
else
%     temp_calc_depth =  str2num(get(findobj('Tag','edit_coul_depth'),'String'));
    temp_calc_depth =  CALC_DEPTH;
end

if friction == 0.0
    friction = 0.00001;
end
beta = 0.5 * (atan(1.0/friction));

% ***** single depth calc OR repeating to pick up max or average values
if DEPTH_RANGE_TYPE == 0
    mloop = 1;
elseif DEPTH_RANGE_TYPE == 1
    mloop = length(CALC_DEPTH_RANGE);
    CC = ones(length(YGRID),length(XGRID),'double') * (-10000.0);
    n = length(YGRID) * length(XGRID);
    PK_DEPTH = ones(1,n) * (-1.0);
%    ZCC = zeros(length(YGRID),length(XGRID),'double'); % keep the depth for max cc
else
    mloop = length(CALC_DEPTH_RANGE);
    CC = zeros(length(YGRID),length(XGRID),'double');    
end
%**************************************************************************
%	for calculating multiple calc layers (loop start) 
%**************************************************************************
for kk = 1:mloop
    if DEPTH_RANGE_TYPE ~= 0
        CALC_DEPTH = CALC_DEPTH_RANGE(kk);
    end
    if IACT == 0 | kk >= 2
        Okada_halfspace;
    	IACT = 1;
    end
    a = length(DC3D);
    if a < 14
        h = warndlg('Increase total grid number more than 14.','Warning!');
    end
    ss = zeros(6,a);
    % rot90 useful?????
    s9 = reshape(DC3D(:,9),1,a);
    s10 = reshape(DC3D(:,10),1,a);
    s11 = reshape(DC3D(:,11),1,a);
    s12 = reshape(DC3D(:,12),1,a);
    s13 = reshape(DC3D(:,13),1,a);
    s14 = reshape(DC3D(:,14),1,a);
    ss = [s9; s10; s11; s12; s13; s14];
%===== SWITCHING by types of stress calculation ========================
switch STRESS_TYPE
%  --------------------- for specified faults calc...
    case 5
        strike = str2num(get(findobj('Tag','edit_spec_strike'),'String'));
        dip = str2num(get(findobj('Tag','edit_spec_dip'),'String'));
        rake = str2num(get(findobj('Tag','edit_spec_rake'),'String'));
        if FLAG_PR_AXES == 1
            d = warndlg('To see the axes, choose one of the opt functions.',...
                'Warning!');
        return
        end
%  --------------- for optimally oriented strike slip, dip slip faults 
    otherwise
        if DEPTH_RANGE_TYPE == 0
            c_depth = CALC_DEPTH;
        else
            c_depth = CALC_DEPTH_RANGE(kk);
        end
        [rs] = regional_stress(R_STRESS,c_depth);
        sgx  = zeros(a,1) + rs(1,1) + reshape(ss(1,1:a),a,1);
        sgy  = zeros(a,1) + rs(2,1) + reshape(ss(2,1:a),a,1);
        sgz  = zeros(a,1) + rs(3,1) + reshape(ss(3,1:a),a,1);
        sgyz = zeros(a,1) + rs(4,1) + reshape(ss(4,1:a),a,1);
        sgxz = zeros(a,1) + rs(5,1) + reshape(ss(5,1:a),a,1);
        sgxy = zeros(a,1) + rs(6,1) + reshape(ss(6,1:a),a,1);
%       calculate principal stress axes...
%        if FLAG_PR_AXES == 1
            pt_rs = zeros(a,9);    
        for k = 1:a
        [V,D] = eig([sgx(k,1) sgxy(k,1) sgxz(k,1); sgxy(k,1) sgy(k,1) sgyz(k,1);...
                sgxz(k,1) sgyz(k,1) sgz(k,1)]);
        evc = reshape(V',1,9);
        eva = [D(1,1) D(2,2) D(3,3)];
        pt_rs(k,:) = find_axes(evc,eva);
        end
%        end
%===== Find sigma-1 and sigma-3 for plain stress condition =============
    if STRESS_TYPE ~= 5
    phi = zeros(a,1) + 0.5 * atan((2.0 * sgxy)./(sgx - sgy)) + pi/2.0;
%         ct = zeros(a,1) + cos(phi);
%         st = zeros(a,1) + sin(phi);
%     erad1 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;
%         ct = zeros(a,1) + cos(phi+pi/2.0);
%         st = zeros(a,1) + sin(phi+pi/2.0);
%     erad2 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;    
        ct = zeros(a,1) + cos(phi);
        st = zeros(a,1) + sin(phi);
    erad1 = sgx.*ct.*ct+sgy.*st.*st+2.0.*sgx.*st.*ct;
    erad2 = sgx.*st.*st+sgy.*ct.*ct-2.0.*sgx.*st.*ct;
% how can we compare each value in two matrices ????????????????????
    nn = length(phi);
        for k = 1:nn
            if erad2(k) >= erad1(k)
%                  phi(k) = pi/2.0 + phi(k);
%                 phi(k) = pi/2.0;
            else
%                phi(k) = 0.0;
            end

                phi(k) = deg2rad(pt_rs(k,1));

%                 if phi(k) < 0.0
%                     phi(k) = -phi(k);
%                 elseif phi(k) >= pi/2.0
%                     phi(k) = phi(k) - pi/2.0;
%                 end
        end
        PHII = rad2deg(phi);
    end
%===== Find strike, dip, and rake for opt faults options =============
%  ------------------ for opt strike-slip fauts
    if STRESS_TYPE == 2
        strike = zeros(a,1) + rad2deg(phi) - rad2deg(beta);
        strike2 = zeros(a,1) + rad2deg(phi) + rad2deg(beta);
        cg1 = strike < 0.0; cg2 = strike >= 0.0;
        strike = (180.0 + strike) .* cg1 + strike .* cg2;
        strike = round(strike);
        dip = 90.0;
        rake = 180.0;
%  ------------------ for opt thrust fauts
    elseif STRESS_TYPE == 3
        strike = zeros(a,1) + rad2deg(phi) + 90.0;
        if strike >= 360.0; strike = strike - 360.0; end;
%        sstrike = reshape(strike,length(YGRID),length(XGRID))
        dip = abs(rad2deg(beta));
        rake = 90.0;
 %  ------------------ for opt normal fauts       
    elseif STRESS_TYPE == 4
        strike = zeros(a,1) + rad2deg(phi);
        dip = abs(90.0-rad2deg(beta));
        rake = -90.0;
    else % dummy...
        strike = 180;
        dip = 90;
        rake = 0;
    end
end     % end of switch

% to hand variables to the other functions
    STRIKE = strike;
    DIP = dip;
    RAKE = rake;
    FRIC = friction;

% === we can remove this part now (Feb. 12, 2008) =========================
if IACT == 2         % escape if only friction is changed
    coulomb = zeros(a,1);
    c4 = zeros(a,1) + friction;
    coulomb = SHEAR + c4 .* NORMAL;
    b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];
% writing all data into a file (text column format)
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
        header1 = ['Input file selected: ',INPUT_FILE];
        if STRESS_TYPE == 1
        header2 = 'x y z coulomb shear normal opt-oriented-strike dip rake';
        header3 = '(km) (km) (km) (bar) (bar) (bar) (degree) (degree) (degree)';
        else
        header2 = 'x y z coulomb shear normal';
        header3 = '(km) (km) (km) (bar) (bar) (bar)';
        end
        dlmwrite('dcff.cou',header1,'delimiter',''); 
        dlmwrite('dcff.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff.cou',b,'-append','delimiter','\t','precision','%.6f');
        if DEPTH_RANGE_TYPE == 1
            fname2 = ['dcff_' num2str(int32(CALC_DEPTH_RANGE(kk))) 'km.cou'];
            copyfile('dcff.cou',fname2);
        end
% =========================================================================        
        
    cd (HOME_DIR);
else                % whole calculation without skipping...
    SHEAR = zeros(a,1);
    NORMAL = zeros(a,1);
    coulomb = zeros(a,1);
     if STRESS_TYPE == 1     % for opt-faults (complicated grid search)
%         ss_r = zeros(6,a);
%         ss_r = [sgx';sgy';sgz'; sgyz'; sgxz'; sgxy'];
%         coulomb_max = ones(a,1) * (-100000.0);
%         shear_max   = ones(a,1) * (-100000.0);
%         normal_max  = ones(a,1) * (-100000.0);
%         strike_max  = ones(a,1) * (-100000.0);
%         dip_max     = ones(a,1) * (-100000.0);
%         rake_max    = ones(a,1) * (-100000.0);
% %        max_depth   = ones(a,1) * (-1.0);
%         % grid search mesh size (n_gs)
%         str1 = 'Grid search mesh size:'; str3 = 'degrees';
%         str2 = num2str(n_gs);
%         disp(strcat(str1,str2,str3));
%         hm = msgbox('Now searching opt planes. Please wait...');
%         for strike = 0:n_gs:360
%              for dip = 0:n_gs:90
%                  for rake = -180:n_gs:180
%                         c1 = zeros(a,1) + strike;
%                         c2 = zeros(a,1) + dip;
%                         c3 = zeros(a,1) + rake;
%                         c4 = zeros(a,1) + friction;
%                   [SHEAR,NORMAL,coulomb] = calc_coulomb(c1,c2,c3,c4,ss_r);
%                         cg1 = coulomb >= coulomb_max;
%                         cg2 = coulomb < coulomb_max;
%                         coulomb_max = cg1.* coulomb + cg2.* coulomb_max;
%                         shear_max   = cg1.* SHEAR + cg2.* SHEAR;
%                         normal_max  = cg1.* NORMAL + cg2.* NORMAL;
%                         strike_max  = cg1.* strike + cg2.* strike_max;
%                         dip_max     = cg1.* dip + cg2.* dip_max;
%                         rake_max    = cg1.* rake   + cg2.* rake_max;
%                  end
%              end
%         end
%         close(hm);
%         strike = strike_max; dip = dip_max; rake = rake_max;

%         regionalStress = repmat(rot90(rs),a,1);
            strike = zeros(a,1);
            dip    = zeros(a,1);
            rake   = zeros(a,1);
            size(rs)
            size(ss)
        for i = 1:a
            optData = calcOptPlanes(rs,ss(:,i),FRIC);
            strike(i,1) = optData(1);
            dip(i,1)    = optData(2);
            rake(i,1)   = optData(3);
        end
     end
        if ~isempty(RECEIVERS) % the case user prepare specific matrix
            try
            c1 = zeros(a,1) + RECEIVERS(:,1);
            c2 = zeros(a,1) + RECEIVERS(:,2);
            c3 = zeros(a,1) + RECEIVERS(:,3);
            catch
            disp('Make sure the receiver fault matrix.');
            disp('Now using scalar strike, dip, and rake.');
            c1 = zeros(a,1) + strike;
            c2 = zeros(a,1) + dip;
            c3 = zeros(a,1) + rake;
            end
%            RECEIVERS = []; % reset to empty matrix
        else
        c1 = zeros(a,1) + strike;
        c2 = zeros(a,1) + dip;
        c3 = zeros(a,1) + rake;
        end
        c4 = zeros(a,1) + friction;
        [SHEAR,NORMAL,coulomb] = calc_coulomb(c1,c2,c3,c4,ss);
   

        
    if STRESS_TYPE == 1
        b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL strike dip rake];
    else
        b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];
    end
% writing all data into a file (text column format)
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
        header1 = ['Input file selected: ',INPUT_FILE];
        if STRESS_TYPE == 1
        header2 = 'x y z coulomb shear normal opt-oriented-strike dip rake';
        header3 = '(km) (km) (km) (bar) (bar) (bar) (degree) (degree) (degree)';
        else
        header2 = 'x y z coulomb shear normal';
        header3 = '(km) (km) (km) (bar) (bar) (bar)';
        end
        dlmwrite('dcff.cou',header1,'delimiter',''); 
        dlmwrite('dcff.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff.cou',b,'-append','delimiter','\t','precision','%.6f');
        if DEPTH_RANGE_TYPE == 1
            fname2 = ['dcff_' num2str(int32(CALC_DEPTH_RANGE(kk))) 'km.cou'];
            copyfile('dcff.cou',fname2);
        end
    cd (HOME_DIR);
end
    h = findobj('Tag','slider_coul_sat');
    COLORSN = get(h,'Value');
    coulomb_open(get(h,'Value'),kk);
% slip line drawing
    if FLAG_SLIP_LINE == 1 | FLAG_PR_AXES == 1
        slip_line_drawing;
    end
%
    if IACTS ~= 1
    h = findobj('Tag','section_view_window');
    if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    	close(figure(H_SECTION))
        H_SECTION = [];
    end
    h = findobj('Tag','xsec_window');
    if (isempty(h)~=1 && isempty(H_SEC_WINDOW)~=1)
        close(figure(H_SEC_WINDOW))
        H_SEC_WINDOW = [];
    end
    end

end             % loop end
%**************************************************************************
%	(loop end) 
%**************************************************************************

% fault_overlay;

% reset the setting for single calc depth (everytime after multiple layered
% calculation, the software automatically swithc a single layer mode)
if DEPTH_RANGE_TYPE ~= 0
    set(findobj('Tag','edit_coul_depth'),'Enable','on');
    set(findobj('Tag','Slip_line'),'Enable','on');
	CALC_DEPTH = temp_calc_depth;
    set(findobj('Tag','edit_coul_depth'),'String',num2str(CALC_DEPTH,'%6.1f'));
	DEPTH_RANGE_TYPE = 0;           % single calc depth
	IACT = 0;
end
fault_overlay;
if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
end
set(gcf,'Pointer','arrow'); set(H_MAIN,'Pointer','arrow'); set(H_COULOMB,'Pointer','arrow'); 

% % ----- update cross section window if exist ------------
h = findobj('Tag','section_view_window');
if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    draw_dipped_cross_section;
    coulomb_section;
end

