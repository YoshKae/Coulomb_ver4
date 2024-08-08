function varargout = new_fault_pos_dialog(varargin)
% NEW_FAULT_POS_DIALOG M-file for new_fault_pos_dialog.fig
%      NEW_FAULT_POS_DIALOG, by itself, creates a new NEW_FAULT_POS_DIALOG or raises the existing
%      singleton*.
%
%      H = NEW_FAULT_POS_DIALOG returns the handle to a new NEW_FAULT_POS_DIALOG or the handle to
%      the existing singleton*.
%
%      NEW_FAULT_POS_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEW_FAULT_POS_DIALOG.M with the given input arguments.
%
%      NEW_FAULT_POS_DIALOG('Property','Value',...) creates a new NEW_FAULT_POS_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before new_fault_pos_dialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to new_fault_pos_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help new_fault_pos_dialog

% Last Modified by GUIDE v2.5 08-Jul-2006 20:54:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_fault_pos_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @new_fault_pos_dialog_OutputFcn, ...
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


% --- Executes just before new_fault_pos_dialog is made visible.
function new_fault_pos_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = int16((h(1) + h(3))/2.0);
% ypos = h(1,2) + 50;
ypos = int16((h(2) + h(4))/2.0);
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for new_fault_pos_dialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes new_fault_pos_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = new_fault_pos_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     OK (button)
%-------------------------------------------------------------------------
function pushbutton_fp_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fp_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.new_fault_pos_dialog);

%-------------------------------------------------------------------------
%     checkbox
%-------------------------------------------------------------------------
function checkbox_fp_again_Callback(hObject, eventdata, handles)
global DONOTSHOW
DONOTSHOW = get(hObject,'Value');

