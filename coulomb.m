%========================================================================
%                           Program Coulomb 
%========================================================================
%  http://www.coulombstress.org/download
%
%       developed by Shinji Toda
%       coding started from March 5, 2005
%
%  To launch this software package, set the current directory coulomb33 and
%  then type 'coulomb' in the command window.
%

%   Copyright 2022 Shinji Toda (toda@irides.tohoku.ac.jp Internal Research 
%   Institute of Disaster Science, Tohoku University)
%   $Revision: 3.4 $  $Date: 2022/04/09$


%===== check if the user is opening anothr Coulomb ================
try         % weird code but it works to prevent another lauching
    get(H_MAIN,'HandleVisibility');
    msgbox('You already open Coulomb. Do not lauch another one.');
    return
catch


clear all;
% all global variables are expressed as capital letters in my code
% we can check those values on workspace while program working
%       see 'global_variable_explanatio.m' for detail.
global H_MAIN                           % handle for main graphic window
global SCRS SCRW_X SCRW_Y               % variable for screen size control
% ----- read from input file (fundamental variables) -----
global HEAD NUM POIS CALC_DEPTH YOUNG FRIC 
global R_STRESS ID INUM KODE ELEMENT
global FCOMMENT GRID SIZE SECTION
% ----- study area & coordinates control variables -----
global ICOORD
global XGRID YGRID XY_RATIO
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global LON_GRID LAT_GRID
% ----- variables control calculations ------
global IACT
global FUNC_SWITCH STRAIN_SWITCH
global SHADE_TYPE STRESS_TYPE DEPTH_RANGE_TYPE
% global AX AY AZ
global STRIKE DIP RAKE
global IRAKE
global MAPTLFLAG RECEIVERS
global IND_RAKE
global IIRET
% ----- outputs should be kept in the memory -----
global DC3D DC3DS DC3DE S_ELEMENT CC
% ----- variables associated with cross sections -----
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_FLAG SEC_DIP SEC_DOWNDIP_INC
% ----- variables retaining overlay data in memory & overlay control -----
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global GPS_FLAG % 'horizontal' or 'vertical'
global GPS_SEQN_FLAG % 'on' shows sequential numbers
global VOLCANO SEISSTATION
global OVERLAYFLAG OVERLAY_MARGIN EQPICK_WIDTH
% ----- graphic control variables ------
global ANATOLIA SEIS_RATE       % color codes (loaded in this file)
global C_SAT CONT_INTERVAL
% ----- computer id, directory control and preferences ------------------
global PLATFORM CURRENT_VERSION PREF_DIR HOME_DIR INPUT_FILE PREF 
global OUTFLAG          % 0: output file in users folder, 1: default folder
global C_SLIP_SAT
global IVECTOR
global IMAXSHEAR

CURRENT_VERSION = '3.4.2';
warning ('off','all');

%===== add file paths ==========================
%    file separator & current working directory
f = filesep;
w = cd;
% add the following paths
addpath([w f 'sources'],[w f 'sources/eq_format_filter'],[w f 'input_files'],...
    [w f 'coastline_data'],[w f 'gps_data'],...
    [w f 'slides'],[w f 'okada_source_conversion'],[w f 'output_files'],...
    [w f 'resources'],[w f 'resources/ge_toolbox'],[w f 'active_fault_data'],...
    [w f 'earthquake_data'],...
    [w f 'license'],[w f 'utm'],[w f 'preferences'],[w f 'plug_ins']);
% PLATFORM is used to handle some troublesome functions depending on
% platoforms
PLATFORM = computer;
if ispc
    addpath([w f 'sources/figures_for_windows']);   % windows
else
	addpath([w f 'sources/figures_for_mac']);       % mac
end
% keep user's home directory into memory
HOME_DIR = pwd;

%===== check licence =========================== (NOW OFF) 82930715
% 	flag = coulomb_registration_check;
%     if strcmp(flag,'out');
%         warndlg('Please register first and get the serial number.','!!!Warning!!!');
%         return
%     end

%===== version check =========================== (NOW OFF)
% try
%     new_version = urlread('http://www.coulombstress.org/version/version.txt');
% catch
%     % in case user cannot access our site
%     new_version = CURRENT_VERSION;
% end
% if ~strcmp(CURRENT_VERSION,new_version)
%     h = questdlg(['New version ' new_version ' is released. Download now?'],'Software update',...
%         'Yes','No','default');
%     switch h
%         case 'Yes'
%             try
% %                 web http://quake.wr.usgs.gov/research/deformation/modeling/coulomb/download.html
%                 cd ..
%                 ccd = pwd;
%                 try
%                 hm = msgbox('Downloading the new version to the parent directory... Be patient.');
%                 disp('Downloading... Pleae be patient.');
%                 url ='http://quake.wr.usgs.gov/research/deformation/modeling/coulomb/download/coulomb.zip';
%                 ncmFiles = unzip(url,ccd);
%                 close(hm);
%                 disp('Done!');
%                 disp('To use the new version, change the current directory to the new one,');
%                 disp('And then, type "coulomb" in command window.');
%                 msgbox(['The new version has been successfully downloaded into ' ccd]);
%                 catch
%                     errordlg('Cannot access the web.','Connection Error!');
%                     cd(HOME_DIR)
%                 end
%                 cd(HOME_DIR)
%             catch
%                 msgbox('Visit http://www.coulombstress.org to download the newest version')
%             end
%             clear all;
%             return
%         case 'No'
%         otherwise
%     end
% end

%====== check the users MATLAB version ============================
matlabv = version;  % we have a trouble about the license with version 7.0.x

% keep user's home directory
HOME_DIR = pwd;

%===== initialization =============================================
coulomb_init;
% additional initialization
IACT          = repmat(uint8(0),1,1);
OVERLAYFLAG   = repmat(uint8(0),1,1);
STRAIN_SWITCH = repmat(uint8(0),1,1);	% default sxx
PREF_DIR      = [];
OUTFLAG       = 1;                      % default

%===== load color maps of anatolia & SEIS_RATE when lauching ======
load('MyColormaps','ANATOLIA');
load('SEIS_RATE','SEIS_RATE');

% load database/global_coastline_data.mat
% load database/afaultdata_ca_ja_sich.mat
% load database/plate_trench.mat
% load database/plate_ridge.mat
% load database/plate_transform.mat
% load database/volcanoes_NGDC_NOAA.mat
% load database/global_eqs.mat
% load database/border.mat

%===== get screen parameters ======================================
SCRS = get(0,'ScreenSize'); %screen size [left,bottom,width,height]
margin_ratio = 0.03;
SCRW_X = int16(SCRS(1,3) * margin_ratio);   % margin width
SCRW_Y = int16(SCRS(1,4) * margin_ratio);   % margin height
if ispc
     SCRW_Y = SCRW_Y + 50;
end
if SCRS(1,3) <= 1000
    warndlg('Sorry that this screen size may not be enough wide to present all results',...
        '!!Warning!!');
end

%===== see if user has mapping toolbox or not ========
% current coulomb version does not need mapping toolbox
if exist([matlabroot '/toolbox/map'],'dir')==0
    MAPTLFLAG = 0;
else
    MAPTLFLAG = 1;
end

%===== Welcome screen ========
h = about_box_window;
pause(2);
close(h);

%===== open preference file ==========================
cd preferences
%    [filename,pathname] = uigetfile([ 'preferences.dat'],' Open input file');
    	fid = fopen('preferences.dat','r');  
        if isempty(fid)==1
            % make default values & then save them.
            PREF = [1.0 0.0 0.0 1.2;... % source fault
                    0.0 0.0 0.0 1.0;... % disp. vector
                    0.7 0.7 0.0 0.2;... % grid line
                    0.0 0.0 0.0 1.2;... % coastline
                    1.0 0.5 0.0 3.0;... % earthquake plot
                    0.2 0.2 0.2 1.0;... % active fault
                    1.0 0.0 0.0 0.0;... % color preference
                    1.0 0.0 0.0 0.0;... % coordinate preference
                    0.9 0.9 0.1 1.0];   % volcano
        else
                fault_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                a = [fault_pref{:}];
                vector_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                b = [vector_pref{:}];
                grid_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                c = [grid_pref{:}];
                coast_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                d = [coast_pref{:}];
                eq_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                e = [eq_pref{:}];
                afault_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                f = [afault_pref{:}];
                color_pref  = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                g = [color_pref{:}];
                coord_pref  = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                h = [coord_pref{:}];
            if size(PREF,1)==8
                i = [0.9 0.9 0.1 1.0];
            else
                volcano_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
                i = [volcano_pref{:}];
            end
                PREF = [a; b; c; d; e; f; g; h; i];
        end
        try
            load('preferences2.mat');       % additional binary preference setting
            if isempty(OUTFLAG) == 1
                OUTFLAG = 1;
            end
            if isempty(PREF_DIR) == 1
                PREF_DIR = HOME_DIR;
            end
            if isempty(INPUT_FILE) == 1
                INPUT_FILE = 'empty';
            end
        catch
            save preferences2.mat PREF_DIR INPUT_FILE OUTFLAG;
            if isempty(OUTFLAG) == 1
                OUTFLAG = 1;
            end
        end        
cd ..
ICOORD = repmat(uint8(PREF(8,1)),1,1);     % ICOORD = 1: x y coordinate, 2: lon. & lat.
% clear local unnecessary variables
clear a afault_pref b c coast_pref color_pref d e eq_pref f fault_pref volcano_pref
clear fid g grid_pref h h_grid margin_ratio vector_pref w

%===== opening main window =====================
% try
%     findobj(H_MAIN,'Tag','main_menu_window');
%     msgbox('You already open Coulomb.');
%     return
% catch
    H_MAIN = main_menu_window;
    set(H_MAIN,'Toolbar','figure');
    set(H_MAIN,'Name',['Coulomb ',CURRENT_VERSION]);
% end

%===== opening message in console ==============
disp('====================================================');
disp(['            Welcome to Coulomb ' CURRENT_VERSION]);
disp('====================================================');
disp('Start from Input menu to read or build an input file.');
disp('  ');

end
