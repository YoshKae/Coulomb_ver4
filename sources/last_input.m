%-------------------------------------------------------------------------
%           OPEN (submenu)  
%-------------------------------------------------------------------------
function last_input
global GRID
global H_MAIN FUNC_SWITCH EQ_DATA COAST_DATA AFAULT_DATA GPS_DATA GTEXT_DATA
global PREF_DIR INPUT_FILE
global DIALOG_SKIP % signal to skip open the input dialog (1: skip, others:not skip)

% --- first set the handvisibility for the main window on ---
set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);

coulomb_init;
clear_obj_and_subfig;
    DIALOG_SKIP = 1;
    
input_open(3);
FUNC_SWITCH = 0;
if isempty(GRID)==0
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
end
if isempty(EQ_DATA) == 1
    set(findobj('Tag','menu_focal_mech'),'Enable','Off');
else
    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end
% ---- making grid map view -----------------------------
% put try-catch-end in case user push "cancel button"
try
    if ~isempty(COAST_DATA)
        set(findobj('Tag','menu_coastlines'),'Checked','On');
    end
    if ~isempty(AFAULT_DATA)
        set(findobj('Tag','menu_activefaults'),'Checked','On');
    end
    if ~isempty(EQ_DATA)
        set(findobj('Tag','menu_earthquakes'),'Checked','On');
    end
    if ~isempty(GPS_DATA)
        set(findobj('Tag','menu_gps'),'Checked','On');
    end
    if ~isempty(GTEXT_DATA)
        set(findobj('Tag','menu_annotations'),'Checked','On');
    end
    % -----
    subfig_clear;
    FUNC_SWITCH = 1;
    grid_drawing;
    fault_overlay;
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 | isempty(AFAULT_DATA)~=1
        hold on;
        overlay_drawing;
    end
    FUNC_SWITCH = 0; %reset
    flag = check_lonlat_info;
    if flag == 1
        all_overlay_enable_on;   
    end
    % -----
catch
    return
end
    DIALOG_SKIP = 0; % reset
% --- clear some variables you made and then set the handvisibility of the main
% window callback. ---
set(H_MAIN,'HandleVisibility','callback');


%----------------------------------------------------------
function all_functions_enable_on
set(findobj('Tag','menu_grid'),'Enable','On');
set(findobj('Tag','menu_displacement'),'Enable','On');
set(findobj('Tag','menu_strain'),'Enable','On');
set(findobj('Tag','menu_stress'),'Enable','On');
set(findobj('Tag','menu_change_parameters'),'Enable','On');
set(findobj('Tag','menu_taper_split'),'Enable','On');

%----------------------------------------------------------
function all_overlay_enable_on
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');
set(findobj('Tag','menu_gps'),'Enable','On');
set(findobj('Tag','menu_annotations'),'Enable','On'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 

%----------------------------------------------------------
function all_overlay_enable_off
set(findobj('Tag','menu_coastlines'),'Enable','Off');
set(findobj('Tag','menu_activefaults'),'Enable','Off');
set(findobj('Tag','menu_earthquakes'),'Enable','Off');
set(findobj('Tag','menu_gps'),'Enable','Off');
set(findobj('Tag','menu_annotations'),'Enable','Off'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','Off'); 
set(findobj('Tag','menu_trace_put_faults'),'Enable','Off'); 

