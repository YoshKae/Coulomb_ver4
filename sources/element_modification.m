function element_modification(n)
global H_MAIN H_ELEMENT_MOD
global NSELECTED ELEMENT POIS YOUNG KODE

% Instruction to write your own plug-in script
%
% first set the handvisibility for the main window on
% set(H_MAIN,'HandleVisibility','on');
% h = figure(H_MAIN);

% % show explanation dialog
% h0 = msgbox('By a mouse click, chose one of the fault edges to be moved.',...
%     'position selected','help');
% waitfor(h0);

NSELECTED = n;
if KODE(NSELECTED) ~= 100 
    h = errordlg('This menu only works for KODE=100 so far. Sorry.');
    waitfor(h);
    return;
end
[mo,mw] = calc_seis_moment(ELEMENT(NSELECTED,1),ELEMENT(NSELECTED,2),ELEMENT(NSELECTED,3),...
    ELEMENT(NSELECTED,4),ELEMENT(NSELECTED,5),ELEMENT(NSELECTED,6),ELEMENT(NSELECTED,7),...
    ELEMENT(NSELECTED,8),ELEMENT(NSELECTED,9),POIS,YOUNG);
H_ELEMENT_MOD = figure(element_modification_window);
set(findobj('Tag','text_md_mo'),'String',num2str(mo,'%3.1e'));
set(findobj('Tag','text_md_mw'),'String',num2str(mw,'%3.1f'));
waitfor(H_ELEMENT_MOD);
% figure(H_ELEMENT_MOD);

%----------------------------------------
% %function menu_grid_mapview_Callback(hObject, eventdata, handles)
global FUNC_SWITCH COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
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

% set(H_MAIN,'HandleVisibility','callback');