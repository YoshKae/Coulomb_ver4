function varargout = coulomb_help_window(varargin)
% COULOMB_HELP_WINDOW M-file for coulomb_help_window.fig
%      COULOMB_HELP_WINDOW, by itself, creates a new COULOMB_HELP_WINDOW or raises the existing
%      singleton*.
%
%      H = COULOMB_HELP_WINDOW returns the handle to a new COULOMB_HELP_WINDOW or the handle to
%      the existing singleton*.
%
%      COULOMB_HELP_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COULOMB_HELP_WINDOW.M with the given input arguments.
%
%      COULOMB_HELP_WINDOW('Property','Value',...) creates a new COULOMB_HELP_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before coulomb_help_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to coulomb_help_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help coulomb_help_window

% Last Modified by GUIDE v2.5 08-Oct-2006 21:34:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @coulomb_help_window_OpeningFcn, ...
                   'gui_OutputFcn',  @coulomb_help_window_OutputFcn, ...
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


% --- Executes just before coulomb_help_window is made visible.
function coulomb_help_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global SHADE_TYPE
j = get(hObject,'Position');
wind_width = j(1,3);
wind_height = j(1,4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);
%---
% Choose default command line output for coulomb_help_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes coulomb_help_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = coulomb_help_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%   Close button 
%-------------------------------------------------------------------------
function pushbutton_help_close_Callback(hObject, eventdata, handles)
h = figure(gcf);
close(h);


%-------------------------------------------------------------------------
%   Output search result 
%-------------------------------------------------------------------------
function edit_search_result_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_search_result_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%   Input search word (text_field) 
%-------------------------------------------------------------------------
function edit_search_word_Callback(hObject, eventdata, handles)
% ve = str2mat(version);
% matlabv = ve(1:3);
% matlabv = '7.4';
% % % === I do not know why version 7.4 do not properly understand 'mat2str'.
% % isstr(version)
% % matlabv = '7.4';
% % matlabv = version;
% % ==============================
% if strcmp(matlabv,'7.4')        % for MATLAB version 7.4
    srcword = get(hObject,'String');
    % read help text data
    n = 500;
    c = cell(n);
    hresult = cell(n);
    help_list;  % (script...)
    help_result;    % script
    x = strmatch(srcword,hlist); % hlist from 'help_list'
    if isempty(x) ~= 1
        m = length(x);
        a = cellstr(hlist);
        for k = 1:m
            c{k} = a{x(k)};
        end
        set(findobj('Tag','listbox_help_title'),'String',strvcat(c{:}));
    else
        dummy = ['No match found';'              '];
        set(findobj('Tag','listbox_help_title'),'String',dummy);
    end
    %-----------
    x = 1;
%    y = str2mat(deblank(get(findobj('Tag','listbox_help_title'),'String')));
    y = deblank(get(findobj('Tag','listbox_help_title'),'String'));
    if isempty(y) ~= 1
%         keyword0 = mat2str(y(x,1:end));
        keyword0 = y(x,1:end);
        z = strmatch(keyword0,hlist); % hlist from 'help_list'
        if isempty(z) ~= 1
            m = length(z);
            for k = 1:m
                b = [hresult{z}];
%                 set(findobj('Tag','edit_search_result'),'String',mat2str(b));
                set(findobj('Tag','edit_search_result'),'String',b);
            end
        else
            set(findobj('Tag','edit_search_result'),'String','No match found');
            if ~isempty(dummy)
            set(findobj('Tag','edit_search_result'),'String','              ');
            end
        end
    end
% else                    % for MATLAB version 7.0-7.3
%     srcword = get(hObject,'String');
%     % read help text data
%     n = 500;
%     c = cell(n);
%     hresult = cell(n);
%     help_list;  % (script...)
%     help_result;    % script
%     x = strmatch(srcword,hlist); % hlist from 'help_list'
%     if isempty(x) ~= 1
%         m = length(x);
%         for k = 1:m
% %             c{k} = mat2str(hlist(x(k),1:end));
%             c{k} = hlist(x(k),1:end);
%         end
%         %    c = strvcat
%         set(findobj('Tag','listbox_help_title'),'String',strvcat(c{:}));
%     else
%         set(findobj('Tag','listbox_help_title'),'String','No match found');
%     end
%     %-----------
%     x = 1;
% %     y = str2mat(get(findobj('Tag','listbox_help_title'),'String'));
%     y = get(findobj('Tag','listbox_help_title'),'String');
%     if isempty(y) ~= 1
%         keyword = mat2str(y(x,1:end));
%         z = strmatch(keyword,hlist); % hlist from 'help_list'
%         if isempty(z) ~= 1
%             m = length(z);
%             for k = 1:m
%                 b = [hresult{z}];
%                 set(findobj('Tag','edit_search_result'),'String',mat2str(b));
%             end
%         else
%             set(findobj('Tag','edit_search_result'),'String','No match found');
%         end
%     end
% end

% --- Executes during object creation, after setting all properties.
function edit_search_word_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%   Output searched title (listbox) 
%-------------------------------------------------------------------------
function listbox_help_title_Callback(hObject, eventdata, handles)
% ve = str2mat(version);
% matlabv = ve(1:3);
% matlabv = '7.4';
% % matlabv = '7.4';
% % matlabv = version;
% if strcmp(matlabv,'7.4') % for MATLAB version 7.4
    x = get(hObject,'Value');
    n = 500;
    hresult = cell(n);
    help_list;      % script
    help_result;    % script
    % z = strmatch(keyword,hlist); % hlist from 'help_list'
%     y = str2mat(deblank(get(findobj('Tag','listbox_help_title'),'String')));
    y = deblank(get(findobj('Tag','listbox_help_title'),'String'));
    if isempty(y) ~= 1
%         keyword0 = mat2str(y(x,1:end));
        keyword0 = y(x,1:end);
%         z = strmatch(eval(keyword0),hlist); % hlist from 'help_list'
        z = strmatch(keyword0,hlist); % hlist from 'help_list'
        if isempty(z) ~= 1
            m = length(z);
            for k = 1:m
                b = [hresult{z}];
%                 set(findobj('Tag','edit_search_result'),'String',mat2str(b));
                set(findobj('Tag','edit_search_result'),'String',b);
            end
        else
            set(findobj('Tag','edit_search_result'),'String','No match found');
        end
    end
% else                % for MATLAB version 7.0-7.3
%     x = get(hObject,'Value');
%     y = str2mat(get(hObject,'String'));
%     keyword = mat2str(y(x,1:end));
%     n = 500;
%     hresult = cell(n);
%     help_list;      % script
%     help_result;    % script
%     z = strmatch(keyword,hlist); % hlist from 'help_list'
%     if isempty(z) ~= 1
%         m = length(z);
%         for k = 1:m
%             b = [hresult{z}];
%             set(findobj('Tag','edit_search_result'),'String',mat2str(b));
%         end
%     else
%         set(findobj('Tag','edit_search_result'),'String','No match found');
%     end
% end

% --- Executes during object creation, after setting all properties.
function listbox_help_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_help_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



