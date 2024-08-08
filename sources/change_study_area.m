% Change study area...
%
% first set the handvisibility for the main window on
global ICOORD LON_GRID
% global variables only with 'change_study_area_window.m'
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global FUNC_SWITCH COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
global MIN_LON MAX_LON MIN_LAT MAX_LAT

set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);


h1 = change_study_area_window;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(findobj('Tag','text_study_area_x'),'String','Longitude (degree)');
    set(findobj('Tag','text_study_area_y'),'String','Latitude  (degree)'); 
else
    set(findobj('Tag','text_study_area_x'),'String','X axis (km)');
    set(findobj('Tag','text_study_area_y'),'String','Y axis (km)');
end
waitfor(h1);

% if ICOORD == 2 && isempty(LON_GRID) ~= 1
%     a1 = lonlat2xy([MIN_LON MAX_LAT]);
%     a2 = lonlat2xy([MAX_LON MAX_LAT]);
%     a3 = lonlat2xy([MAX_LON MIN_LAT]);
%     a4 = lonlat2xy([MIN_LON MIN_LAT]);
%     GRID(1,1) = (a1(1)+a4(1))/2.0;
%     GRID(2,1) = (a3(2)+a4(2))/2.0;
%     GRID(3,1) = (a2(1)+a3(1))/2.0;
%     GRID(4,1) = (a1(2)+a2(2))/2.0;
%     MIN_LON = TEMP_MINLON;
%     MAX_LON = TEMP_MAXLON;
%     MIN_LAT = TEMP_MINLAT;
%     MAX_LAT = TEMP_MAXLAT;
% %     a1 = lonlat2xy([TEMP_MINLON TEMP_MAXLAT]);
% %     a2 = lonlat2xy([TEMP_MAXLON TEMP_MAXLAT]);
% %     a3 = lonlat2xy([TEMP_MAXLON TEMP_MINLAT]);
% %     a4 = lonlat2xy([TEMP_MINLON TEMP_MINLAT]);
% %     GRID(1,1) = (a1(1)+a4(1))/2.0;
% %     GRID(2,1) = (a3(2)+a4(2))/2.0;
% %     GRID(3,1) = (a2(1)+a3(1))/2.0;
% %     GRID(4,1) = (a1(2)+a2(2))/2.0;
% %     MIN_LON = TEMP_MINLON;
% %     MAX_LON = TEMP_MAXLON;
% %     MIN_LAT = TEMP_MINLAT;
% %     MAX_LAT = TEMP_MAXLAT;
% % % else
% % %     a1 = xy2lonlat([GRID(1) GRID(4)]);
% % %     a2 = xy2lonlat([GRID(3) GRID(4)]);
% % %     a3 = xy2lonlat([GRID(3) GRID(2)]);
% % %     a4 = xy2lonlat([GRID(1) GRID(2)]); 
% % %     MIN_LON = (a1(1)+a4(1))/2.0;
% % %     MAX_LON = (a2(1)+a3(1))/2.0;
% % %     MIN_LAT = (a3(2)+a4(2))/2.0;
% % %     MAX_LAT = (a1(2)+a2(2))/2.0;    
% end

calc_element;

% ----- from grid drawing function in main_menu_window.m ----------
% function menu_grid_mapview_Callback(hObject, eventdata, handles)
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
h = msgbox('If you want to keep precise locations of the overlays, reload them from original data.',...
    'Notice','warn');
end
% ------------------------------------------------------------------

% clear some variables you made and then set the handvisibility of the main
% window callback.

set(H_MAIN,'HandleVisibility','callback');

