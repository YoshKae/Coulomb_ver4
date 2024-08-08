function gps_plot
% This function plots earthquakes on Coulomb map
% 
global H_MAIN HOME_DIR PREF_DIR OUTFLAG
global XGRID YGRID LON_PER_X LAT_PER_Y
global SIZE
global PREF
global ICOORD LON_GRID LAT_GRID
global GPS_DATA GPS_FLAG GPS_SEQN_FLAG

    scl   = 2.0;
    resz  = double((SIZE(3,1)/1000)*scl);
    vln = PREF(2,4); % line width of the vectors
    if strcmp(GPS_FLAG,'vertical')
        vln = vln * 2.0; % make it bolder
    end
    offparam = 0.1; % parameter control offset of OBS and CALC for vertical

    
    
% automatically chosen directory 'GPS_data'
    try
        cd('GPS_data');
    catch
        cd(HOME_DIR);
    end
% Chose a data file in default dialog
if isempty(GPS_DATA)==1
    [filename,pathname] = uigetfile('*.*',' Open GPS data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
        cd(HOME_DIR);
        return
    else
        disp('  ----- GPS data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
	fid = fopen(fullfile(pathname, filename),'r'); 
    n     = 10000;  % dummy number (probably use 'end' later)
    count = 0;
    for m = 1:n
        count = count + 1;
        if m == 1
            a = textscan(fid,'%f %f %f %f %f','headerlines', 2);
            x{m}      = a{1};
            y{m}      = a{2};
            east{m}   = a{3};
            north{m}  = a{4};
            upward{m} = a{5};
        else
            a = textscan(fid,'%f %f %f %f %f','headerlines', 1);
            x{m}      = a{1};
            y{m}      = a{2};
            east{m}   = a{3};
            north{m}  = a{4};
            upward{m} = a{5};
        end
        checka = [a{1}];
        if length(checka) <= 1
            break
        end
    end
    fclose(fid);
    GPS_DATA = zeros(count,7,'double');
    b=lonlat2xy([[x{:}] [y{:}]]);
    GPS_DATA = [[x{:}] [y{:}] [east{:}] [north{:}] [upward{:}] b(:,1) b(:,2)];    
end
%---------------------

if isempty(GPS_DATA)~=1
    [m,n] = size(GPS_DATA(:,6));
    ux = zeros(m,1,'double');
    uy = zeros(m,1,'double');
    uz = zeros(m,1,'double');
    [dc3de] = dc3de_calc(GPS_DATA(:,6),GPS_DATA(:,7));
    ux = dc3de(:,6);
    uy = dc3de(:,7);
    uz = dc3de(:,8);
%------ GPS_DATA format (5 columns) -------------------------------
% 1)lon, 2)lat, 3)Easting, 4)Northing, 5)Upwarding, 6)x, 7)y
%------------------------------------------------------------------
    figure(H_MAIN);
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1                % lon.lat.coordinates
        h = scatter(GPS_DATA(:,1),GPS_DATA(:,2));
        if strcmp(GPS_FLAG,'vertical')              % vertical disp.
            zero = zeros(size(GPS_DATA,1),1);
            off = abs(LON_GRID(2)-LON_GRID(1))*offparam;   % to control offset of OBS and CALC vectors
        a1 = quiver(GPS_DATA(:,1)-off,GPS_DATA(:,2),zero,...
            GPS_DATA(:,5)*LAT_PER_Y*resz,0);        % OBS vertical vector
        a2 = quiver(GPS_DATA(:,1)+off,GPS_DATA(:,2),zero,...
            uz(:,1)*LAT_PER_Y*resz,0);              % CACL vertical vector   
        aaa = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
        bbb = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
        xinc = aaa(2,1)-aaa(1,1);
        yinc = bbb(2,2)-bbb(1,2);
        [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.2,0.5);
        a0 = quiver(aaa(1,1)+xinc,bbb(1,2)+yinc*1.5,0.,unit*LAT_PER_Y*resz,0); %scale vector
        h1 = text(aaa(1,1)+unit*LAT_PER_Y*resz*0.5,bbb(1,2)+yinc*3.0,unitText);
        else
        a1 = quiver(GPS_DATA(:,1),GPS_DATA(:,2),GPS_DATA(:,3)*LON_PER_X*resz,...
            GPS_DATA(:,4)*LAT_PER_Y*resz,0);        % OBS horizontal vector
        a2 = quiver(GPS_DATA(:,1),GPS_DATA(:,2),ux(:,1)*LON_PER_X*resz,...
            uy(:,1)*LAT_PER_Y*resz,0);              % CACL horizontal vector   
        aaa = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
        bbb = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
        xinc = aaa(2,1)-aaa(1,1);
        yinc = bbb(2,2)-bbb(1,2);
        [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.2,0.5);
        a0 = quiver((aaa(1,1)+xinc),(bbb(1,2)+yinc*1.5),unit*LON_PER_X*resz,0.,0); %scale vector
        h1 = text((aaa(1,1)+unit*LON_PER_X*resz*0.5),(bbb(1,2)+yinc*2.2),unitText);
        end
%         a0 = quiver((aaa(1,1)+xinc),(bbb(1,2)+yinc*1.5),1.0*LON_PER_X*resz,0.,0); %scale vector (1m)
%         h1 = text((aaa(1,1)+2.0*xinc),(bbb(1,2)+yinc*3.0),'1m');
    else                                                    % cartesian coordinates
        h = scatter(GPS_DATA(:,6),GPS_DATA(:,7));
        if strcmp(GPS_FLAG,'vertical')              % vertical disp.
            zero = zeros(size(GPS_DATA,1),1);
            off = abs(XGRID(2)-XGRID(1))*0.03;   % to control offset of OBS and CALC vectors
        a1 = quiver(GPS_DATA(:,6)-off,GPS_DATA(:,7),zero,GPS_DATA(:,5)*resz,0); % OBS vector
        a2 = quiver(GPS_DATA(:,6)+off,GPS_DATA(:,7),zero,uz(:,1)*resz,0);             % CALC vector
            xinc = XGRID(2)-XGRID(1);
            yinc = YGRID(2)-YGRID(1);
        [unit,unitText] = check_unit_vector(YGRID(1),YGRID(end),1.0*resz,0.2,0.5);
        a0 = quiver(XGRID(1)+xinc*1.5,YGRID(1)+yinc,0.,unit*resz,0); %scale vector
        h1 = text(XGRID(1)+xinc*3.0,YGRID(1)+unit*resz*0.5,unitText);
        else                                        % horizontal disp.
        a1 = quiver(GPS_DATA(:,6),GPS_DATA(:,7),GPS_DATA(:,3)*resz,GPS_DATA(:,4)*resz,0); % OBS vector
        a2 = quiver(GPS_DATA(:,6),GPS_DATA(:,7),ux(:,1)*resz,uy(:,1)*resz,0);             % CALC vector
            xinc = XGRID(2)-XGRID(1);
            yinc = YGRID(2)-YGRID(1);
        [unit,unitText] = check_unit_vector(XGRID(1),XGRID(end),1.0*resz,0.2,0.5);
        a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),unit*resz,0.,0); %scale vector
        h1 = text((XGRID(1)+unit*resz*0.5),(YGRID(1)+yinc*2.2),unitText);
        end

%         a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),1.0*resz,0.,0); %scale vector (1m)
%         h1 = text((XGRID(1)+2.0*xinc),(YGRID(1)+yinc*2.2),'1m');
    end
    
    % ------ save numerical file -----
    format long;
    if OUTFLAG == 1 || isempty(OUTFLAG) == 1
        cd (HOME_DIR);
        cd output_files;
    else
        cd (PREF_DIR);
    end
    gpsv = [GPS_DATA(:,1:5) ux(:,1) uy(:,1) uz(:,1)];
    header1 = 'longitude,latitude,ObsEasting,ObsNorthing,ObsUpwarding,CalcEasting,CalcNorthing,CalcUpwarding';
    header2 = '(deg),(deg),(m),(m),(m),(m),(m),(m)';
    dlmwrite('GPS_output.csv',header1,'delimiter','');  
	dlmwrite('GPS_output.csv',header2,'delimiter','','-append');  
	dlmwrite('GPS_output.csv',gpsv,'delimiter',',','precision','%15.6f','-append');
	disp(['GPS_output.csv is saved in ' pwd]);
    
    % ----- drawing ------------------
    % set color and linewidth
    darkblue = [0.1 0.1 1.0];
    set(h,'MarkerEdgeColor',darkblue);
    set(a1,'LineWidth',vln,'Color',darkblue);
    set(a2,'LineWidth',vln,'Color',[0.8 0.2 0.2]);
    set(a0,'LineWidth',vln,'Color',darkblue);
    set(h1,'FontName','Helvetica','Fontsize',14,'Color','b','FontWeight','bold',...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
    if strcmp(GPS_FLAG,'vertical')
        set(a0,'ShowArrowHead','off');
        set(a1,'ShowArrowHead','off');
        set(a2,'ShowArrowHead','off');
        set(h1,'HorizontalAlignment','left');
    end
    % putting Tags to the objects to turn on and off later
    set(h,'Tag','GPSObj');
    set(a1,'Tag','GPSOBSObj');
    set(a2,'Tag','GPSCALCObj');
    set(h1,'Tag','UNITObj');
    set(a0,'Tag','UNITTEXTObj');
    
    % write gps sequential numbers (eventually it has to be the station
    % name)
    if strcmp(GPS_SEQN_FLAG,'on')
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        for j = 1:size(GPS_DATA,1)
            hold on;
            hgp = text(GPS_DATA(j,1),GPS_DATA(j,2),num2str(j));
            set(hgp,'fontsize',14,'fontweight','b','Color',[0.1 0.1 0.3]);
        end
    else
        for j = 1:size(GPS_DATA,1)
            dg   = lonlat2xy([GPS_DATA(j,1),GPS_DATA(j,2)]);
            hold on;
            hgp = text(dg(1,1),dg(1,2),num2str(j));
            set(hgp,'fontsize',12,'fontweight','b','Color',[0.1 0.1 0.3]);
        end
    end
    end
    
    
end
	cd(HOME_DIR);

if ~strcmp(GPS_FLAG,'vertical')
disp(' ');
disp('   * To see vertical displacement, type GPS_FLAG = ''vertical''');
disp(' ');
else
disp(' ');
disp('   * To see horizontal displacement, type GPS_FLAG = ''horizontal''');
disp(' ');  
end
disp('   * To change the vector line width, go to Input/Preferences/Disp.Vector.');
disp('   * To change vector exagg. length, change param. SIZE(3) typing here.');
disp('   *   (e.g., SIZE(3) = 500000)');
disp('   * To know the corresponding location for each data line, change the param.');
disp('   * GPS_SEQN_FLAG = ''on'' typing here and then redraw the map.');
disp('   * To save the GPS data as binary, use the following command in this window');
disp('   * save filename GPS_DATA (e.g., save mygps.mat GPS_DATA)');
disp('   * To read the .mat formatted GPS data, use ''File -> Import Data...'' menu later.');
disp(' ');

