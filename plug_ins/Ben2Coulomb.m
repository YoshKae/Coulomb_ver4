% script to convert Ben's fault model into Coulomb

fmodel = 'model_v13.patch';
zero_lon =  -117.6048;
zero_lat =    35.7665;
margin  = 0.25; % degree
% MIN_LON = -120.6048000;
% MAX_LON = -114.6048000;
% MIN_LAT = 32.7665000;
% MAX_LAT = 38.7665000;
nend = 1000;


% myData = textread(fmodel, '%s', 'delimiter', '\n', 'whitespace', '');
fileID = fopen(fmodel);
myData = textscan(fileID,'%s %s %s %s %s %s',nend);
fclose(fileID);

nel = int32(length(myData{1})/5);
ELEMENT = zeros(nel,9,'double'); %(:,1)xstart,(:,2)ystart,(:,3)xfinish
                                            %(:,4)yfinish,(:,5)right-lat. slip
                                            %(:,6)reverse slip,(:,7)dip,(:,8)top,(:,9)bottom

lon1 = zeros(nel,1);
lon2 = zeros(nel,1);
lon3 = zeros(nel,1);
lon4 = zeros(nel,1);
lat1 = zeros(nel,1);
lat2 = zeros(nel,1);
lat3 = zeros(nel,1);
lat4 = zeros(nel,1);
dep1 = zeros(nel,1);
dep2 = zeros(nel,1);
right = zeros(nel,1);
rever = zeros(nel,1);
xy1 = zeros(nel,2); xy2 = zeros(nel,2); xy3 = zeros(nel,2); xy4 = zeros(nel,2);

for i = 1:length(myData{1})
    n = mod(i,5);
    m = round(i/5-0.51)+1;
    if n == 1
        right(m) = str2double(myData{4}(i));
        rever(m) = str2double(myData{5}(i));
    elseif n == 2
        lon1(m) = str2double(myData{1}(i));
        lat1(m) = str2double(myData{2}(i));
        dep1(m) = str2double(myData{3}(i));
    elseif n == 3
        lon2(m) = str2double(myData{1}(i));  
        lat2(m) = str2double(myData{2}(i));  
    elseif n == 4
        lon3(m) = str2double(myData{1}(i)); 
        lat3(m) = str2double(myData{2}(i));
        dep2(m) = str2double(myData{3}(i));
    else
        lon4(m) = str2double(myData{1}(i)); 
        lat4(m) = str2double(myData{2}(i));  
    end
end

ilon1p = lon1 >= zero_lon;
ilat1p = lat1 >= zero_lat;
ilon2p = lon2 >= zero_lon;
ilat2p = lat2 >= zero_lat;
ilon3p = lon3 >= zero_lon;
ilat3p = lat3 >= zero_lat;
ilon4p = lon4 >= zero_lon;
ilat4p = lat4 >= zero_lat;
ilon1n = lon1 < zero_lon;
ilat1n = lat1 < zero_lat;
ilon2n = lon2 < zero_lon;
ilat2n = lat2 < zero_lat;
ilon3n = lon3 < zero_lon;
ilat3n = lat3 < zero_lat;
ilon4n = lon4 < zero_lon;
ilat4n = lat4 < zero_lat;

xy1(:,1) = ilon1p.*deg2km(distance(lat1(:),lon1(:),lat1(:),zero_lon))...
    -ilon1n.*deg2km(distance(lat1(:),lon1(:),lat1(:),zero_lon));
xy2(:,1) = ilon2p.*deg2km(distance(lat2(:),lon2(:),lat2(:),zero_lon))...
    -ilon2n.*deg2km(distance(lat2(:),lon2(:),lat2(:),zero_lon));
xy3(:,1) = ilon3p.*deg2km(distance(lat3(:),lon3(:),lat3(:),zero_lon))...
    -ilon3n.*deg2km(distance(lat3(:),lon3(:),lat3(:),zero_lon));
xy4(:,1) = ilon4p.*deg2km(distance(lat4(:),lon4(:),lat4(:),zero_lon))...;
    -ilon4n.*deg2km(distance(lat4(:),lon4(:),lat4(:),zero_lon));

xy1(:,2) = ilat1p.*deg2km(distance(lat1(:),lon1(:),zero_lat,lon1(:)))...
    -ilat1n.*deg2km(distance(lat1(:),lon1(:),zero_lat,lon1(:)));
xy2(:,2) = ilat2p.*deg2km(distance(lat2(:),lon2(:),zero_lat,lon2(:)))...
    -ilat2n.*deg2km(distance(lat2(:),lon2(:),zero_lat,lon2(:)));
xy3(:,2) = ilat3p.*deg2km(distance(lat3(:),lon3(:),zero_lat,lon3(:)))...
    -ilat3n.*deg2km(distance(lat3(:),lon3(:),zero_lat,lon3(:)));
xy4(:,2) = ilat4p.*deg2km(distance(lat4(:),lon4(:),zero_lat,lon4(:)))...
    -ilat4n.*deg2km(distance(lat4(:),lon4(:),zero_lat,lon4(:)));

% dipc = ones(nel,1) * 90;
h = dep2-dep1;
d = sqrt((xy2(:,1)-xy3(:,1)).^2+(xy2(:,2)-xy3(:,2)).^2);
theta = atan(d./h);
dipc = ones(nel,1).*(90.0-rad2deg(theta));

% fseg_position = [xy1(:,1) xy1(:,2) xy2(:,1) xy2(:,2)];
fseg_position = [xy2(:,1) xy2(:,2) xy1(:,1) xy1(:,2)];
ELEMENT(1:nel,:) = [fseg_position right rever dipc dep1 dep2]; 

% 
% MIN_LON = -120.6048000;
% MAX_LON = -114.6048000;
% MIN_LAT = 32.7665000;
% MAX_LAT = 38.7665000;
% return

%========================================================== 
%           conversion to Coulomb input .mat file 
%==========================================================  
%----------------------------
% Several default parameters
%----------------------------
        CALC_DEPTH = 7.5;
        POIS = 0.25;
        YOUNG = 800000;
        FRIC = 0.4;
        SIZE = [2;1;10000];
        HEAD = cell(2,1);
            x1 = ['header line 1'];
            x2 = ['header line 2'];
        HEAD(1,1) = {(x1)};
        HEAD(2,1) = {(x2)};
        R_STRESS = [19.00 -0.01 100.0 0.0;
                    89.99 89.99  30.0 0.0;
                   109.00 -0.01   0.0 0.0];
        SECTION = [-200.; -10.; 200.; 10.; 5.; 50.; 5.];
        PREF = [1.0 0.0 0.0 1.2;...
               0.0 0.0 0.0 1.0;...
               0.7 0.7 0.0 0.2;...
               0.0 0.0 0.0 1.2;...
               1.0 0.5 0.0 3.0;...
               0.2 0.2 0.2 1.0;...
               2.0 0.0 0.0 0.0;...
               1.0 0.0 0.0 0.0];
        COAST_DATA  = [];
        AFAULT_DATA = [];
        EQ_DATA     = [];
        GTEXT_DATA     = [];
        FCOMMENT  = [];

%----------------------------
%   study area
%----------------------------
%     MIN_LON = 360; MAX_LON = -360;
%     MIN_LAT = 360; MAX_LAT = -360;
% for k = 1:invSEGM
%     if invSEGM == 1
%         lon{k} = eval([evTag,'.geoLON']);
%         lat{k} = eval([evTag,'.geoLAT']);
%     else
%         lon{k} = eval([evTag,'.seg',int2str(k),'geoLON']);
%         lat{k} = eval([evTag,'.seg',int2str(k),'geoLAT']);
%     end
%     minlon0 = min(rot90(min(lon{k}))); if minlon0<MIN_LON; MIN_LON=minlon0; end;
%     maxlon0 = max(rot90(max(lon{k}))); if maxlon0>MAX_LON; MAX_LON=maxlon0; end;
%     minlat0 = min(rot90(min(lat{k}))); if minlat0<MIN_LAT; MIN_LAT=minlat0; end;
%     maxlat0 = max(rot90(max(lat{k}))); if maxlat0>MAX_LAT; MAX_LAT=maxlat0; end;
% end
%     marginlon = (MAX_LON - MIN_LON);
%     marginlat = (MAX_LAT - MIN_LAT);
%     if marginlon > marginlat
%         marginlat = marginlon;
%     else
%         marginlon = marginlat;
%     end
%     MIN_LON = MIN_LON - marginlon;
%     MAX_LON = MAX_LON + marginlon;
%     MIN_LAT = MIN_LAT - marginlat;
%     MAX_LAT = MAX_LAT + marginlat;
    MIN_LON = min(lon1) - margin;
    MAX_LON = max(lon1) + margin;
    MIN_LAT = min(lat1) - margin;
    MAX_LAT = max(lat1) + margin;
    ZERO_LON = zero_lon;
    ZERO_LAT = zero_lat;
    INC_LON  = (MAX_LON - MIN_LON) / 20.0;
    INC_LAT  = (MAX_LAT - MIN_LAT) / 20.0;
    ndlon = int16((MAX_LON - MIN_LON) / INC_LON);
    ndlat = int16((MAX_LAT - MIN_LAT) / INC_LAT);
    modlon = mod((MAX_LON - MIN_LON),INC_LON);
    modlat = mod((MAX_LAT - MIN_LAT),INC_LAT);
    pcent_lon = (MAX_LON + MIN_LON)/2.0;
    pcent_lat = (MAX_LAT + MIN_LAT)/2.0;
    % total distance for x and Y
    try
    xdist = deg2km(distance(pcent_lat,MIN_LON,pcent_lat,MAX_LON));
    ydist = deg2km(distance(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon));
    xmin = deg2km(distance(pcent_lat,MIN_LON,pcent_lat,ZERO_LON));
    ymin = deg2km(distance(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon));
    xmax = deg2km(distance(pcent_lat,MAX_LON,pcent_lat,ZERO_LON));
	ymax = deg2km(distance(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon));
    catch
    xdist = distance2(pcent_lat,MIN_LON,pcent_lat,MAX_LON);
    ydist = distance2(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon);
    xmin = distance2(pcent_lat,MIN_LON,pcent_lat,ZERO_LON);
    ymin = distance2(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    xmax = distance2(pcent_lat,MAX_LON,pcent_lat,ZERO_LON);
	ymax = distance2(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    end
    
    if ZERO_LON > MIN_LON
        xmin = -xmin;
    end
    if ZERO_LAT > MIN_LAT
        ymin = -ymin;
    end
    if ZERO_LON > MAX_LON
        xmax = -xmax;
    end
    if ZERO_LAT > MAX_LAT
        ymax = -ymax;
    end
    GRID = zeros(6,1);
    GRID(1,1) = xmin;
    GRID(3,1) = xmax;
    GRID(2,1) = ymin;
    GRID(4,1) = ymax;
    GRID(5,1) = (xmax - xmin) / double(ndlon);
    GRID(6,1) = (ymax - ymin) / double(ndlat);
        
%----------------------------
%	fault element
%----------------------------
    NUM = int32(nel);
    ID = int8(ones(NUM,1));
    KODE = ID * 100;
    
%----------------------------------------------------------------------
%	saving dialog for .mat file (default directory is 'input_files')
%----------------------------------------------------------------------
    cdir = pwd;         % keep current directory
    try
        cd('input_files')
    catch
        mkdir('input_files_temp');
    end
        [filename,pathname] = uiputfile([fmodel '_' num2str(NUM,'%5i') 'f_coulomb.mat'],...
        ' Save Input File As');
    if isequal(filename,0) | isequal(pathname,0)
        disp('User selected Cancel');
        cd(cdir)
        return;
    else
        disp(['User saved as ', fullfile(pathname,filename)]);
    end
    save(fullfile(pathname,filename), 'HEAD','NUM','POIS','CALC_DEPTH',...
        'YOUNG','FRIC','R_STRESS','ID','KODE','ELEMENT','FCOMMENT',...
        'GRID','SIZE','SECTION','PREF','MIN_LAT','MAX_LAT','ZERO_LAT',...
        'MIN_LON','MAX_LON','ZERO_LON','COAST_DATA','AFAULT_DATA',...
        'EQ_DATA','GTEXT_DATA','-mat');
    cd(cdir)
