function overlay_drawing
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global GPS_FLAG GPS_SEQN_FLAG
global VOLCANO
global ICOORD LON_GRID PREF
% global NH_COMMENT
global H_MAIN

% ----- coast line plot -----
h = findobj('Tag','menu_coastlines');
h1 = get(h,'Checked');
if isempty(COAST_DATA)~=1 && strcmp(h1,'on')
        coastline_drawing;
end

% ----- active fault plot -----
h = findobj('Tag','menu_activefaults');
h1 = get(h,'Checked');
if isempty(AFAULT_DATA)~=1 && strcmp(h1,'on')    
        afault_drawing;    
end

% --- earthquake plot ---------------
h = findobj('Tag','menu_earthquakes');
h1 = get(h,'Checked');
if isempty(EQ_DATA)~=1 && strcmp(h1,'on')
        earthquake_plot;
end

% --- Volcano PLUG-IN (not default) --------
try
    if ~isempty(VOLCANO)
%         volcano_overlay('MarkerFaceColor',[PREF(9,1) PREF(9,2) PREF(9,3)],'MarkerSize',PREF(9,4)*14);
        volcano_overlay('MarkerSize',PREF(9,4)*14);

    end
catch
    return
end

% --- gps plot ---------------
h = findobj('Tag','menu_gps');
h1 = get(h,'Checked');
if isempty(GPS_DATA)~=1 && strcmp(h1,'on')
        gps_plot;
end
