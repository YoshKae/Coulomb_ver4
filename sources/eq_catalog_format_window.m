function varargout = eq_catalog_format_window(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eq_catalog_format_window_OpeningFcn, ...
                   'gui_OutputFcn',  @eq_catalog_format_window_OutputFcn, ...
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


% --- Executes just before eq_catalog_format_window is made visible.
function eq_catalog_format_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.


% Choose default command line output for eq_catalog_format_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = eq_catalog_format_window_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     Select catalog format (listbox)  
%-------------------------------------------------------------------------
function listbox_format_Callback(hObject, eventdata, handles)


% Hints: contents = get(hObject,'String') returns listbox_format contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        listbox_format
global EQ_FORMAT_TYPE
EQ_FORMAT_TYPE = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function listbox_format_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     OK (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_catalog_ok_Callback(hObject, eventdata, handles)
global EQ_FORMAT_TYPE EQ_ZFORMAT_DATA
global HOME_DIR PLATFORM EQ_FLAG
persistent EQ_DIR
delete(figure(gcf));
try
    cd(EQ_DIR);
catch
    try
        cd('earthquake_data');
    catch
        cd(HOME_DIR);
    end
end
    
    if isempty(EQ_FORMAT_TYPE) == 1
            EQ_FORMAT_TYPE = 1;         % I do not know why this thing happpens....
    end

    
switch EQ_FORMAT_TYPE
    % read twice each function for stupid MATLAB 7.4 on Intel Mac .......
    case 1          % Harvard CMT
%            harvard_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = harvard_catalog;
    case 2          % JMA catalog
%           jma_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = jma_catalog; 
    case 3
%            scec_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = scec_catalog;
    case 4
%            ncsc_readable_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = ncsc_readable_catalog;
    case 5
%            ncsc_hypoinverse_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = ncsc_hypoinverse_catalog;
    case 6
%            ncsc_fpfit_catalog;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = ncsc_fpfit_catalog;
    case 7
%           neic_catalog_screenformat;  % ??? No idea. This is for Intel Mac (stupid...)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = neic_catalog_screenformat;
    case 8
%            zmap_catalog;  % ??? No idea. This is for Intel Mac            
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = zmap_catalog;
    case 9
%            nied_fnet_catalog;  % ??? No idea. This is for Intel Mac
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = nied_fnet_catalog;
    case 10
%            nied_hinet_auto_catalog;  % ??? No idea. This is for Intel Mac
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = nied_hinet_auto_catalog;
    case 11
%           kandilli Turkey earthquake catalog
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = kandilli_catalog;
    case 12
%           hypoDD/tomoDD earthquake catalog
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = hypoDD_tomoDD;
    case 13
%           Northern California DD filter
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = ncadd;
	case 14
%           Sosus (Sound Surveillance System) catalog 
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = sosus_catalog;
    case 15
%           Read receiver fault data (strike, dip, & rake info)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = receivers_data;
    case 16
%           Read receiver fault data (strike, dip, & rake info)
            [EQ_ZFORMAT_DATA,EQ_DIR,EQ_FLAG] = usgs_csv;      
    otherwise
        
end
cd(HOME_DIR);

%-------------------------------------------------------------------------
%     Cancel (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_catalog_cancel_Callback(hObject, eventdata, handles)
close(figure(gcf));


%------------------------
% dummy function
%------------------------
function dum_intel_mac
%
%   dummy to read EQ catalog on Intel Mac. For unknown reason,
%   uigetfile does not work properly for the first access.
%
    [filename,pathname] = uigetfile({'*.*'},' Open input file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        return
    end



