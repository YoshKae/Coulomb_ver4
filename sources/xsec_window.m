function varargout = xsec_window(varargin)
% XSEC_WINDOW M-file for xsec_window.fig
%      XSEC_WINDOW, by itself, creates a new XSEC_WINDOW or raises the existing
%      singleton*.
%
%      H = XSEC_WINDOW returns the handle to a new XSEC_WINDOW or the handle to
%      the existing singleton*.
%
%      XSEC_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XSEC_WINDOW.M with the given input arguments.
%
%      XSEC_WINDOW('Property','Value',...) creates a new XSEC_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xsec_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xsec_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xsec_window

% Last Modified by GUIDE v2.5 08-Aug-2006 16:25:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xsec_window_OpeningFcn, ...
                   'gui_OutputFcn',  @xsec_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before xsec_window is made visible.
function xsec_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global ICOORD LON_GRID SECTION GRID
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC SECTION
global SEC_DIP SEC_DOWNDIP_INC
global AV_DEPTH
global H_MAIN HO HT1 HT2
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
	h = get(dummy,'Position');
end
xpos = h(1) + h(3) + 5;
dummy1 = findobj('Tag','coulomb_window');
dummy2 = findobj('Tag','displ_h_window');
dummy3 = findobj('Tag','vertical_displ_window');
dummy4 = findobj('Tag','strain_window');
if isempty(dummy1)~=1
	h = get(dummy1,'Position');
elseif isempty(dummy2)~=1
	h = get(dummy2,'Position');
elseif isempty(dummy3)~=1
	h = get(dummy3,'Position'); 
else
	h = get(dummy4,'Position');     
end
ypos = h(2) - wind_height - 30;
set(hObject,'Position',[xpos ypos wind_width wind_height]);
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(findobj('Tag','text_A_x'),'String','lon.');
    set(findobj('Tag','text_A_y'),'String','lat.');
    set(findobj('Tag','text_B_x'),'String','lon.');
    set(findobj('Tag','text_B_y'),'String','lat.');
    set(findobj('Tag','text_A_km'),'String','deg.');
    set(findobj('Tag','text_B_km'),'String','deg.');
end
if ~isempty(SECTION)
    SEC_XS = SECTION(1); SEC_YS = SECTION(2); SEC_XF = SECTION(3); SEC_YF = SECTION(4);
    SEC_INCRE = SECTION(5); SEC_DEPTH = SECTION(6); SEC_DEPTHINC = SECTION(7);
    SEC_DIP = 90.0;
else
    SEC_XS = GRID(1)+(GRID(3)-GRID(1))/4;
    SEC_YS = GRID(2)+(GRID(4)-GRID(2))/4;
    SEC_XF = GRID(3)-(GRID(3)-GRID(1))/4;
    SEC_YF = GRID(4)-(GRID(4)-GRID(2))/4;
    SEC_DEPTHINC = (GRID(5)+GRID(6))/5.0;
    SEC_INCRE = SEC_DEPTHINC;
    SEC_DEPTH = AV_DEPTH + AV_DEPTH/2.0;
    SEC_DIP = 90.0;
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([SEC_XS SEC_YS]);
    b = xy2lonlat([SEC_XF SEC_YF]);
    set(findobj('Tag','edit_sec_xs'),'String',num2str(a(1),'%6.2f'));
    set(findobj('Tag','edit_sec_ys'),'String',num2str(a(2),'%6.2f'));
    set(findobj('Tag','edit_sec_xf'),'String',num2str(b(1),'%6.2f'));
    set(findobj('Tag','edit_sec_yf'),'String',num2str(b(2),'%6.2f'));
else
    set(findobj('Tag','edit_sec_xs'),'String',num2str(SEC_XS,'%6.2f'));
    set(findobj('Tag','edit_sec_ys'),'String',num2str(SEC_YS,'%6.2f'));
    set(findobj('Tag','edit_sec_xf'),'String',num2str(SEC_XF,'%6.2f'));
    set(findobj('Tag','edit_sec_yf'),'String',num2str(SEC_YF,'%6.2f'));
end
set(findobj('Tag','edit_sec_incre'),'String',num2str(SEC_INCRE,'%6.2f'));
set(findobj('Tag','edit_sec_depth'),'String',num2str(SEC_DEPTH,'%6.2f'));
set(findobj('Tag','edit_section_dip'),'String',num2str(SEC_DIP,'%6.2f'));
set(findobj('Tag','edit_sec_depthinc'),'String',num2str(SEC_DEPTHINC,'%6.2f'));
draw_dipped_cross_section;  % function in this file
%end
% Choose default command line output for xsec_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = xsec_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     START X POSITION (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_xs_Callback(hObject, eventdata, handles)
global SEC_XS ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    a = lonlat2xy([b 0.0]);
    SEC_XS = a(1);
    set(hObject,'String',num2str(b,'%6.2f'));
else
    SEC_XS = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(SEC_XS,'%6.2f'));
end
check_sec_input;
% sec_line_drawing;
draw_dipped_cross_section;

%--------------------
function edit_sec_xs_CreateFcn(hObject, eventdata, handles)
global SEC_XS
global ICOORD LON_GRID
global SECTION GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([SEC_XS 0.0]);
	set(hObject,'String',num2str(a(1),'%6.2f'));    
else
	set(hObject,'String',num2str(SEC_XS,'%6.2f'));
end

%-------------------------------------------------------------------------
%     START Y POSITION (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_ys_Callback(hObject, eventdata, handles)
global SEC_YS ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    a = lonlat2xy([0.0 b]);
    SEC_YS = a(2);
    set(hObject,'String',num2str(b,'%6.2f'));
else
    SEC_YS = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(SEC_YS,'%6.2f'));
end
check_sec_input;
% sec_line_drawing
draw_dipped_cross_section;

%--------------------
function edit_sec_ys_CreateFcn(hObject, eventdata, handles)
global SEC_YS
global ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([0.0 SEC_YS]);
	set(hObject,'String',num2str(a(2),'%6.2f'));    
else
	set(hObject,'String',num2str(SEC_YS,'%6.2f'));
end

%-------------------------------------------------------------------------
%     FINISH X POSITION (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_xf_Callback(hObject, eventdata, handles)
global SEC_XF ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    a = lonlat2xy([0.0 b]);
    SEC_XF = a(2);
    set(hObject,'String',num2str(b,'%6.2f'));
else
    SEC_XF = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(SEC_XF,'%6.2f'));
end
check_sec_input;
% sec_line_drawing
draw_dipped_cross_section;

%--------------------
function edit_sec_xf_CreateFcn(hObject, eventdata, handles)
global SEC_XF
global ICOORD LON_GRID
% global H_MAIN HO
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([SEC_XF 0.0]);
	set(hObject,'String',num2str(a(1),'%6.2f'));    
else
	set(hObject,'String',num2str(SEC_XF,'%6.2f'));
end

%-------------------------------------------------------------------------
%     FINISH Y POSITION (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_yf_Callback(hObject, eventdata, handles)
global SEC_YF ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    a = lonlat2xy([b 0.0]);
    SEC_YF = a(1);
    set(hObject,'String',num2str(b,'%6.2f'));
else
    SEC_YF = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(SEC_YF,'%6.2f'));
end
check_sec_input;
% sec_line_drawing
draw_dipped_cross_section;

%--------------------
function edit_sec_yf_CreateFcn(hObject, eventdata, handles)
global SEC_YF
global ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([0.0 SEC_YF]);
	set(hObject,'String',num2str(a(2),'%6.2f'));    
else
	set(hObject,'String',num2str(SEC_YF,'%6.2f'));
end

%-------------------------------------------------------------------------
%     DISTANCE INCREMENT (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_incre_Callback(hObject, eventdata, handles)
global SEC_INCRE
SEC_INCRE = str2double(get(hObject,'String'));
set(hObject,'String',num2str(SEC_INCRE,'%6.2f'));
check_sec_input;

%--------------------
function edit_sec_incre_CreateFcn(hObject, eventdata, handles)
global SEC_INCRE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SEC_INCRE,'%6.2f'));

%-------------------------------------------------------------------------
%     DEPTH (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_depth_Callback(hObject, eventdata, handles)
global SEC_DEPTH
SEC_DEPTH = str2double(get(hObject,'String'));
set(hObject,'String',num2str(SEC_DEPTH,'%6.2f'));
check_sec_input;
draw_dipped_cross_section;

%--------------------
function edit_sec_depth_CreateFcn(hObject, eventdata, handles)
global SEC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SEC_DEPTH,'%6.2f'));

%-------------------------------------------------------------------------
%     SECTION DIP (Textfield)  
%-------------------------------------------------------------------------
function edit_section_dip_Callback(hObject, eventdata, handles)
global SEC_DIP SEC_DOWNDIP_INC SEC_DEPTHINC
SEC_DIP = str2double(get(hObject,'String'));
if SEC_DIP > 90.0 | SEC_DIP < -90.0
    warndlg('Put number between -90 and 90','!!Warning!!');
end
SEC_DOWNDIP_INC = str2double(get(findobj('Tag','edit_downdip_inc'),'String'));
SEC_DEPTHINC = SEC_DOWNDIP_INC * sin(deg2rad(SEC_DIP));
set(findobj('Tag','edit_sec_depthinc'),'String',num2str(SEC_DEPTHINC,'%6.2f'));
draw_dipped_cross_section

%--------------------
function edit_section_dip_CreateFcn(hObject, eventdata, handles)
global SEC_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SEC_DIP,'%4.1f'));


%-------------------------------------------------------------------------
%     DEPTH INCREMENT (Textfield)  
%-------------------------------------------------------------------------
function edit_sec_depthinc_Callback(hObject, eventdata, handles)
global SEC_DEPTHINC SEC_DIP SEC_DOWNDIP_INC
SEC_DEPTHINC = str2double(get(hObject,'String'));
check_sec_input;
SEC_DOWNDIP_INC = SEC_DEPTHINC / sin(deg2rad(SEC_DIP));
set(hObject,'String',num2str(SEC_DEPTHINC,'%6.2f'));
set(findobj('Tag','edit_downdip_inc'),'String',num2str(SEC_DOWNDIP_INC,'%6.2f'));

%--------------------
function edit_sec_depthinc_CreateFcn(hObject, eventdata, handles)
global SEC_DEPTHINC SEC_DOWNDIP_INC SEC_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SEC_DEPTHINC,'%4.1f'));

%-------------------------------------------------------------------------
%     DOWNDIP INCREMENT (Textfield)  
%-------------------------------------------------------------------------
function edit_downdip_inc_Callback(hObject, eventdata, handles)
global SEC_DEPTHINC SEC_DOWNDIP_INC SEC_DIP
SEC_DOWNDIP_INC = str2double(get(hObject,'String'));
SEC_DEPTHINC = SEC_DOWNDIP_INC * sin(deg2rad(SEC_DIP));
set(hObject,'String',num2str(SEC_DOWNDIP_INC,'%6.2f'));
set(findobj('Tag','edit_sec_depthinc'),'String',num2str(SEC_DEPTHINC,'%6.2f'));

%--------------------
function edit_downdip_inc_CreateFcn(hObject, eventdata, handles)
global SEC_DEPTHINC SEC_DOWNDIP_INC SEC_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% set(hObject,'String',num2str(SEC_DOWNDIP_INC,'%4.1f'));
set(hObject,'String',num2str(SEC_DOWNDIP_INC,'%4.1f'));

%-------------------------------------------------------------------------
%     MOUSE CLICK (mouse click)  
%-------------------------------------------------------------------------
function sec_mouse_clicks_Callback(hObject, eventdata, handles)
global H_MAIN HO HT1 HT2
global SEC_XS SEC_YS SEC_XF SEC_YF ICOORD LON_GRID
xy = zeros(2,2);
n = 0;
but = 1;
while (but == 1 && n <= 2)
    h = figure(H_MAIN);
   [xi,yi,but] = ginput(1);
%	plot(A_MAIN,xi,yi,'ro'); 
	n = n+1;
   xy(:,n) = [xi;yi];
end
   SEC_XS = xy(1,1);
   SEC_YS = xy(2,1);
   SEC_XF = xy(1,2);
   SEC_YF = xy(2,2);
   set(findobj('Tag','edit_sec_xs'),'String',num2str(SEC_XS,'%7.2f'));
   set(findobj('Tag','edit_sec_ys'),'String',num2str(SEC_YS,'%7.2f'));
   set(findobj('Tag','edit_sec_xf'),'String',num2str(SEC_XF,'%7.2f'));
   set(findobj('Tag','edit_sec_yf'),'String',num2str(SEC_YF,'%7.2f'));
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
       a = lonlat2xy([SEC_XS 0.0]); SEC_XS = a(1);
       a = lonlat2xy([SEC_XF 0.0]); SEC_XF = a(1);
       a = lonlat2xy([0.0 SEC_YS]); SEC_YS = a(2);
       a = lonlat2xy([0.0 SEC_YF]); SEC_YF = a(2);
	end
draw_dipped_cross_section;

%-------------------------------------------------------------------------
%     OPEN POSITION FILE (push button)  
%-------------------------------------------------------------------------
function sec_open_file_Callback(hObject, eventdata, handles)
global H_MAIN HO HT1 HT2
global SEC_XS SEC_YS SEC_XF SEC_YF
global SEC_INCRE SEC_DEPTH SEC_DEPTHINC SEC_DIP SEC_DOWNDIP_INC
global ICOORD LON_GRID
    [filename,pathname] = uigetfile('*.*',' Open section position file');
    if isequal(filename,0)
        disp('  User selected Cancel')
        return
    else
        disp(['  User selected', fullfile(pathname, filename)])
    end
    fid = fopen(fullfile(pathname, filename),'r');
%     cs0 = textscan(fid,'%*45c %16i',1);
    cs  = textscan(fid,'%*45c %16.7f32',10);
%     section = [cs0{:} cs{:}];
    section = [cs{:}];
    if isempty(section)
        disp('   No info for a cross section line');
        return
    else
        coordflag   = int8(section(1));
        if coordflag == 2
            a = lonlat2xy([section(2) 0.0]); SEC_XS = a(1);          
            a = lonlat2xy([0.0 section(3)]); SEC_YS = a(2);
            a = lonlat2xy([section(4) 0.0]); SEC_XF = a(1);
            a = lonlat2xy([0.0 section(5)]); SEC_YF = a(2);
        else
            SEC_XS          = section(2);          
            SEC_YS          = section(3);
            SEC_XF          = section(4); 
            SEC_YF          = section(5);
        end
            SEC_INCRE       = section(6);
            SEC_DEPTH       = section(7);
            SEC_DEPTHINC    = section(8);
            SEC_DIP         = section(9);
            SEC_DOWNDIP_INC = section(10);

    set(findobj('Tag','edit_sec_incre'),'String',num2str(section(6),'%6.2f'));
    set(findobj('Tag','edit_sec_depth'),'String',num2str(section(7),'%6.2f'));
    set(findobj('Tag','edit_sec_depthinc'),'String',num2str(section(8),'%6.2f'));
    set(findobj('Tag','edit_section_dip'),'String',num2str(section(9),'%4.1f'));
    set(findobj('Tag','edit_downdip_inc'),'String',num2str(section(10),'%6.2f'));
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
       a = xy2lonlat([SEC_XS 0.0]); SEC_XS = a(1);
       a = xy2lonlat([SEC_XF 0.0]); SEC_XF = a(1);
       a = xy2lonlat([0.0 SEC_YS]); SEC_YS = a(2);
       a = xy2lonlat([0.0 SEC_YF]); SEC_YF = a(2);
        set(findobj('Tag','edit_sec_xs'),'String',num2str(SEC_XS,'%6.2f'));
        set(findobj('Tag','edit_sec_ys'),'String',num2str(SEC_YS,'%6.2f'));
        set(findobj('Tag','edit_sec_xf'),'String',num2str(SEC_XF,'%6.2f'));
        set(findobj('Tag','edit_sec_yf'),'String',num2str(SEC_YF,'%6.2f'));
    else
        set(findobj('Tag','edit_sec_xs'),'String',num2str(SEC_XS,'%6.2f'));
        set(findobj('Tag','edit_sec_ys'),'String',num2str(SEC_YS,'%6.2f'));
        set(findobj('Tag','edit_sec_xf'),'String',num2str(SEC_XF,'%6.2f'));
        set(findobj('Tag','edit_sec_yf'),'String',num2str(SEC_YF,'%6.2f'));
    end
    draw_dipped_cross_section;
    end
	fclose(fid);

   
%===============================================================
%  CALC & VIEW
%===============================================================
function sec_calc_Callback(hObject, eventdata, handles)
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global FUNC_SWITCH
global ICOORD LON_GRID
global IACTS
global OUTFLAG PREF_DIR HOME_DIR
IACTS = 0;
check_sec_input;
% section_grid_drawing;
SEC_XS = str2double(get(findobj('Tag','edit_sec_xs'),'String'));
SEC_YS = str2double(get(findobj('Tag','edit_sec_ys'),'String'));
SEC_XF = str2double(get(findobj('Tag','edit_sec_xf'),'String'));
SEC_YF = str2double(get(findobj('Tag','edit_sec_yf'),'String'));
% if SEC_XS >= SEC_XF
%     errordlg('Start X should be smaller than finish x. Change the numbers.','!!Error!!');
%     return;
% end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
       temp = zeros(1,4);
       temp = [SEC_XS SEC_XF SEC_YS SEC_YF];
       a = lonlat2xy([SEC_XS 0.0]); SEC_XS = a(1);
       a = lonlat2xy([SEC_XF 0.0]); SEC_XF = a(1);
       a = lonlat2xy([0.0 SEC_YS]); SEC_YS = a(2);
       a = lonlat2xy([0.0 SEC_YF]); SEC_YF = a(2);
end
SEC_INCRE = str2double(get(findobj('Tag','edit_sec_incre'),'String'));
SEC_DEPTH = str2double(get(findobj('Tag','edit_sec_depth'),'String'));
SEC_DEPTHINC = str2double(get(findobj('Tag','edit_sec_depthinc'),'String'));
SEC_DIP = str2double(get(findobj('Tag','edit_section_dip'),'String'));
SEC_DOWNDIP_INC = str2double(get(findobj('Tag','edit_downdip_inc'),'String'));
switch FUNC_SWITCH
    case 2              % vector plot
        displacement_section;
	case 3              % distorted wireframe
        displacement_section;
    case 4              % distorted wireframe
        displacement_section;
    case 6              % dilatation section
        coulomb_section;
	case 7              % shear stress change
        coulomb_section;
	case 8              % normal stress change
        coulomb_section;
    case 9              % coulomb stress change
        coulomb_section;
    otherwise
        disp('Something wrong with FUNC_SWITCH.');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    SEC_XS = temp(1); SEC_XF = temp(2); SEC_YS = temp(3); SEC_YF = temp(4);
end

%     if OUTFLAG == 1 | isempty(OUTFLAG) == 1
% 	cd output_files;
%     else
% 	cd (PREF_DIR);
%     end
%     header1 = ['Input file selected: ',INPUT_FILE];
%     header2 = 'x y z UX UY UZ';
%     header3 = '(km) (km) (km) (m) (m) (m)';
%     dlmwrite('Displacement.cou',header1,'delimiter',''); 
%     dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
%     dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
%     dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
%     disp(['Displacement.cou is saved in ' pwd]);
%     cd (HOME_DIR);

if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
else
	cd (PREF_DIR);
end
fid = fopen('Cross_section.dat','wt');
fprintf(fid,'  0  --------- coordinate (1:xy, 2:lonlat) =    %1i\n',ICOORD);
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',SEC_XS);
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',SEC_YS);
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',SEC_XF);
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',SEC_YF);
fprintf(fid,'  5  ------------------  Distant-increment = %16.7f\n',SEC_INCRE);
fprintf(fid,'  6  ----------------------------  Z-depth = %16.7f\n',(-1.0)*SEC_DEPTH);
fprintf(fid,'  7  ------------------------  Z-increment = %16.7f\n',SEC_DEPTHINC);
fprintf(fid,'  8  ------------------------  section dip = %16.7f\n',SEC_DIP);
fprintf(fid,'  9  ------------------------  downdip inc = %16.7f\n',SEC_DOWNDIP_INC);
fclose(fid);
disp(['Cross_section.dat is saved in ' pwd]);
cd (HOME_DIR);


% %-------------------------------------------------------------------------
% %     Draw cross section projection on the map
% %-------------------------------------------------------------------------
% function draw_dipped_cross_section
% global H_MAIN
% global HF HO HT1 HT2
% global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
% global SEC_DIP SEC_DOWNDIP_INC
% global ICOORD LON_GRID
% % section_grid_drawing;
% SEC_XS = str2double(get(findobj('Tag','edit_sec_xs'),'String'));
% SEC_YS = str2double(get(findobj('Tag','edit_sec_ys'),'String'));
% SEC_XF = str2double(get(findobj('Tag','edit_sec_xf'),'String'));
% SEC_YF = str2double(get(findobj('Tag','edit_sec_yf'),'String'));
% if ICOORD == 2 && isempty(LON_GRID) ~= 1
%            temp = zeros(1,4);
%            temp  = [SEC_XS SEC_XF SEC_YS SEC_YF];
%        a = lonlat2xy([SEC_XS 0.0]); SEC_XS = a(1);
%        a = lonlat2xy([SEC_XF 0.0]); SEC_XF = a(1);
%        a = lonlat2xy([0.0 SEC_YS]); SEC_YS = a(2);
%        a = lonlat2xy([0.0 SEC_YF]); SEC_YF = a(2);
% end
% SEC_INCRE = str2double(get(findobj('Tag','edit_sec_incre'),'String'));
% SEC_DEPTH = str2double(get(findobj('Tag','edit_sec_depth'),'String'));
% SEC_DEPTHINC = str2double(get(findobj('Tag','edit_sec_depthinc'),'String'));
% SEC_DID = str2double(get(findobj('Tag','edit_section_dip'),'String'));
% SEC_DOWNDIP_INC = str2double(get(findobj('Tag','edit_downdip_inc'),'String'));
% 
%    figure(H_MAIN);
%    hold on;
%    h = findobj('Tag','dipped_cross_section_lines');
%    if isempty(HF)~=1 && isempty(h)~=1
%    delete(HF);
%    end
%    h = findobj('Tag','cross_section_line');
%    if isempty(HO)~=1 && isempty(h)~=1
%    delete(HO);
%    end
%    h = findobj('Tag','cross_section_A');
%    if isempty(HT1)~=1 && isempty(h)~=1
%    delete(HT1);
%    end
%    h = findobj('Tag','cross_section_B');
%    if isempty(HT2)~=1 && isempty(h)~=1
%    delete(HT2);
%    end
%    hold on;
%    c = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,SEC_DEPTH);
%     hold on;
%     if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         a = zeros(4,2);
%         a = xy2lonlat([c(:,1) c(:,2)]);
%         HF = plot([a(1,1) a(2,1) a(3,1) a(4,1) a(1,1)],...
%           [a(1,2) a(2,2) a(3,2) a(4,2) a(1,2)]);
%     else
%         HF = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
%           [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)]);
%     end
%     set (HF,'Tag','dipped_cross_section_lines','Color','b','LineWidth',0.5);
% 
% 	if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         HO = plot([temp(1) temp(2)],[temp(3) temp(4)]);
%     else
%         HO = plot([SEC_XS SEC_XF],[SEC_YS SEC_YF]);
%     end
%         set(HO,'Tag','cross_section_line','Color','b','LineWidth',1.5);         %TAG cross_section_line
%         check_sec_input;
% 	if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         HT1 = text(temp(1),temp(3),'A','FontSize',18,'Color','k');
%         HT2 = text(temp(2),temp(4),'B','FontSize',18,'Color','k');
%     else
%         HT1 = text(SEC_XS,SEC_YS,'A','FontSize',18,'Color','k');
%         HT2 = text(SEC_XF,SEC_YF,'B','FontSize',18,'Color','k');
%     end
% set(HT1,'HorizontalAlignment','center');
% set(HT2,'HorizontalAlignment','center');
% set(HT1,'Tag','cross_section_A');         %TAG cross_section_A
% set(HT2,'Tag','cross_section_B');         %TAG cross_section_B
% 
% 
% 
% 
% 
% 
% 
