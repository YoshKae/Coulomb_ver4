function srcmod2coulomb2
% 
% This function convert a SRCMOD earthquake source fault file to coulomb
% input file automatically. To do this, first visit Martin Mai's SRCMOD
% site. http://www.seismo.ethz.ch/srcmod/Homepage.html  and get
% SRCMOD_JUL07_v7.mat file and place into the coulomb home folder. Then,
% type srcmod2coulomb.
%
% All CAPITALIZED variables are ones used in program Coulomb. Some default
% values are set.
%
% CAUTION: Need distance function from mapping tool box
%
% Aknowledgements. I appreciate Martin to make such wonderful database.
%
%  Copyright 2007 Shinji Toda
%  Written by:  Shinji Toda (Active Fault Research Center, AIST, Japan)
%
%   $Revision: 1.0 $    $Date: 2007/08/13 12:30:45 $

% To load the SRCMOD data to the home directory.
try
%    load SRCMOD_JUL07_v7;
    load SRCMOD_2019.mat
catch
    h = errordlg(['SRCMOD data is not in ''plug-ins'' directory.','File Error']);
    waitfor(h);
    return
end

%----- list box dialog & select one fault model data ---------
d = whos('-regexp', 's1','s2');
str = {d.name};
[s,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single',...
                'ListString',str);
if ~isempty(s)
    evTag = d(s).name;
    disp([evTag ' was selected.']);
else
    return
end

%------ read general parameters --------
evLON = eval([evTag,'.evLON']);         % hypocenter longitude
evLAT = eval([evTag,'.evLAT']);         % hypocenter latitude
evDPT = eval([evTag,'.evDPT']);         % hypocenter depth
srcDimWL = eval([evTag,'.srcDimWL']);   % general Width & Length
srcDipAn = eval([evTag,'.srcDipAn']);   % general dip angle (degrees)
srcARake = eval([evTag,'.srcARake']);   % general rake angle (degrees)
srcHypXZ = eval([evTag,'.srcHypXZ']);   % hypocenter location in fault plane
                                        %   rupture nucleation point in fault-plane coordinates
                                        %   (starting at top-left corner)
invSEGM = eval([evTag,'.invSEGM']);     % number of segments
invNzNx = eval([evTag,'.invNzNx']);     % number of subfaults in each direction (x: along-strike, z: down-dip)
invDzDx = eval([evTag,'.invDzDx']);     % subfault size in along-strike and down-dip direction
invNoTW = eval([evTag,'.invNoTW']);     % number of time window (nothing to do with static stress)
        Dx = invDzDx(2);    % subfault length along strike
        Dz = invDzDx(1);    % subfault length along donw-dip

%----------- Calculate total number of patches (subfaults) ---------------
% counter = 0;    % counter but eventually going to be number of all patches
nsegs = 1;
ELEMENT = zeros(int32(invSEGM),9,'double'); %(:,1)xstart,(:,2)ystart,(:,3)xfinish
                                            %(:,4)yfinish,(:,5)right-lat. slip
                                            %(:,6)reverse slip,(:,7)dip,(:,8)top,(:,9)bottom
% FCOMMENT = struct('ref',[]);

ncounter = 1;
if isempty(invSEGM)==1          % -- NO SEGMENT --
    disp('No segment!');
    return
else                            % -- SEGMENTED FAULT --
    for k = 1:invSEGM                   % SEGMENT loop start
%         if invSEGM == 1
%             hypo    = eval([evTag,'.srcHypXZ']);    % top-left corner of the segment
%             strike  = eval([evTag,'.srcAStke']);    % strike of the segment
%             dip     = eval([evTag,'.srcDipAn']);    % dip of the segment
%             try
%                 rake    = eval([evTag,'.srcARake']);    % general rake of the segment
%             catch
%                 rake    = srcARake;
%             end
%             htop    = eval([evTag,'.srcZ2top']);    % top depth of the segment
%             nzx = eval([evTag,'.invNzNx']);         % number of subfaults in the segment
%             nz = nzx(1); nx = nzx(2);
%             try
%                 rake    = eval([evTag,'.rakeSPL']);     % 
%             catch
%                 rake    = srcARake;     % 
%             end
%             geoX{k} = eval([evTag,'.geoX']);
%             geoY{k} = eval([evTag,'.geoY']);
%             geoZ{k} = eval([evTag,'.geoZ']);
%             num_subfs = nz * nx;
%             for mm = 1:num_subfs
%                 FCOMMENT(mm).ref = ['seg-1 subf-' int2str(mm)];
%             end
%         else
            strike  = eval([evTag,'.seg',int2str(k),'AStke']);
            dip     = eval([evTag,'.seg',int2str(k),'DipAn']);
            slip    = eval([evTag,'.seg',int2str(k),'SLIP']);
            SS      = eval([evTag,'.seg',int2str(k),'SS']);
            DS      = eval([evTag,'.seg',int2str(k),'DS']);
            unit   = eval([evTag,'.seg',int2str(k),'invDzDx']);
            unitW  = unit(1);
            unitL  = unit(2);
            
            top     = eval([evTag,'.seg',int2str(k),'Z2top']);
            try
                rake    = eval([evTag,'.seg',int2str(k),'RAKE']);
            catch
                try
                    rake    = eval([evTag,'.seg',int2str(k),'ARake']);
                    format short
%                    disp(['Seg',num2str(k,'%3i'),'  SS = ',num2str(SS,'%8.4f'),'  DS = ',num2str(DS,'%8.4f')]);
                    disp([num2str(k,'%3i'),' ',num2str(SS,'%8.4f'),' ',num2str(DS,'%8.4f')]);
%                     k
%                     SS
%                     DS
                    rake = 180.0 - rake;
                catch
                    rake    = eval([evTag,'.srcARake']);
                end
            end
            geoX = eval([evTag,'.seg',int2str(k),'geoX']);
            geoY = eval([evTag,'.seg',int2str(k),'geoY']);
            geoZ = eval([evTag,'.seg',int2str(k),'geoZ']);
%             num_subfs = nz * nx;
%             for mm = 1:num_subfs
                FCOMMENT(ncounter).ref = ['seg-' int2str(k)];
%             end
            ncounter = ncounter + 1;
 %       end
%         slip = zeros(nz,nx,'double');        
%         if invSEGM == 1
%             if invNoTW == 0
%                     slip = eval([evTag,'.slipSPL']);
%             else
%                 for m = 1:invNoTW       % cumulative displacement
%                     try
%                         twslip    = eval([evTag,'.slipTW',int2str(m)]);
%                     catch
%                         twslip    = eval([evTag,'.slipSPL']);     %
%                     end
%                     slip = slip + twslip;
%                 end
%             end
%         else 

%             if invNoTW == 0
%                     slip = eval([evTag,'.seg',int2str(k),'SLIP']);
%                         [ms,ns] = size(slip);
%                     try
%                         rake = ones(ms,ns,'double') * eval([evTag,'.seg',int2str(k),'ARake']);
%                     catch
%                         rake = ones(ms,ns,'double') * srcARake;
%                     end
%             else
%                 for m = 1:invNoTW       % cumulative displacement
%                     try
%                         twslip    = eval([evTag,'.seg',int2str(k),'TW',int2str(m)]);
%                         slip = slip + twslip;
%                     catch
%                         slip = eval([evTag,'.seg',int2str(k),'SLIP']);
%                     end
%                 end
%             end
            
%         end
        slip = slip / 100.0;    % if unit is "cm"
        right   = slip .* (-1.0) .* cos(deg2rad(rake));
        reverse = slip .* sin(deg2rad(rake));        
%         xs = zeros(nx,1);
%         ys = zeros(nx,1);
%         xf = zeros(nx,1);
%         yf = zeros(nx,1);
%         xxs = zeros(nx*nz,1);
%         yys = zeros(nx*nz,1);
%         xxf = zeros(nx*nz,1);
%         yyf = zeros(nx*nz,1);
%         fseg_position = zeros(nx,4);        
%         lcounter = 0;
%         top = ones(nx*nz,1);
%         bottom = ones(nx*nz,1);

        xPos = geoX;
        yPos = geoY;
        zPos = geoZ;
%         if size(zPos,1) == 1
%              zunit = srcDimWL(1) * sin(deg2rad(srcDipAn)); 
% %            zunit = invDzDx(1) * sin(deg2rad(dip)); %%%
%         else
%             zunit = zPos(2,1) - zPos(1,1);
% %            zunit = invDzDx(1) * sin(deg2rad(dip)); %%%
%         end
%         if size(xPos,2) == 1
            xunit = unitL * sin(deg2rad(strike));
            yunit = unitL * cos(deg2rad(strike));
            zunit = unitW * sin(deg2rad(dip));
%         else
%             xunit = xPos(1,2) - xPos(1,1);
%             yunit = yPos(1,2) - yPos(1,1);
%         end
%         
%         for m = 1:nx
%                 xs(m) = xPos(1,m) - xunit/2.;
%                 ys(m) = yPos(1,m) - yunit/2.;
%                 xf(m) = xPos(1,m) + xunit/2.;
%                 yf(m) = yPos(1,m) + yunit/2.;
%                 for n = 1:nz
%                     lcounter = lcounter + 1;
                    xxs  = xPos - xunit/2.;
                    yys  = yPos - yunit/2.;
                    xxf  = xPos + xunit/2.;
                    yyf  = yPos + yunit/2.;
%                     top(lcounter)    = zPos(n,m);
                    bottom = zPos + zunit;
%                 end
%         end
        fseg_position = [xxs yys xxf yyf];
        right_slip = right;
        reverse_slip = reverse;
        dipc = dip;
        ELEMENT(k,:) = [fseg_position right_slip reverse_slip dipc top bottom];        

    end
end

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

%----------------------------
%   study area
%----------------------------
    MIN_LON = 360; MAX_LON = -360;
    MIN_LAT = 360; MAX_LAT = -360;
for k = 1:invSEGM
    if invSEGM == 1
        lon{k} = eval([evTag,'.geoLON']);
        lat{k} = eval([evTag,'.geoLAT']);
    else
        lon{k} = eval([evTag,'.seg',int2str(k),'geoLON']);
        lat{k} = eval([evTag,'.seg',int2str(k),'geoLAT']);
    end
    minlon0 = min(rot90(min(lon{k}))); if minlon0<MIN_LON; MIN_LON=minlon0; end;
    maxlon0 = max(rot90(max(lon{k}))); if maxlon0>MAX_LON; MAX_LON=maxlon0; end;
    minlat0 = min(rot90(min(lat{k}))); if minlat0<MIN_LAT; MIN_LAT=minlat0; end;
    maxlat0 = max(rot90(max(lat{k}))); if maxlat0>MAX_LAT; MAX_LAT=maxlat0; end;
end
    marginlon = (MAX_LON - MIN_LON);
    marginlat = (MAX_LAT - MIN_LAT);
    if marginlon > marginlat
        marginlat = marginlon;
    else
        marginlon = marginlat;
    end
    MIN_LON = MIN_LON - marginlon;
    MAX_LON = MAX_LON + marginlon;
    MIN_LAT = MIN_LAT - marginlat;
    MAX_LAT = MAX_LAT + marginlat;
    ZERO_LON = evLON;
    ZERO_LAT = evLAT;
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
    NUM = int32(invSEGM);
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
        [filename,pathname] = uiputfile([evTag '_' num2str(NUM,'%5i') 'f_coulomb.mat'],...
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


