% change_coordinates (script)
if ICOORD == 1
    ICOORD = 2;
    if isempty(LON_GRID)
        h = warndlg('No lon. & lat. information');
        waitfor(h);
        return
    end
else
    ICOORD = 1;
end

% function menu_grid_mapview_Callback(hObject, eventdata, handles)
global FUNC_SWITCH ICOORD LON_GRID COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
subfig_clear;
FUNC_SWITCH = 1;
grid_drawing;
fault_overlay;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
    end
%end
FUNC_SWITCH = 0; %reset
flag = check_lonlat_info;
if flag == 1
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');
set(findobj('Tag','menu_gps'),'Enable','On'); 
set(findobj('Tag','menu_annotations'),'Enable','On'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end