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

% --- Lavel or comment plot ---------------
% h = findobj('Tag','menu_put_comment');
% h1 = get(h,'Checked');
% if isempty(GTEXT_DATA)~=1 && strcmp(h1,'on')
%     ch = get(H_MAIN,'Children');
%     NH_COMMENT(1) = length(get(ch(1),'Children'))+1;
%     [m,n] = size(GTEXT_DATA);
%     for k = 1:n-1
%     GTEXT_DATA(k).handle = text(GTEXT_DATA(k).x,GTEXT_DATA(k).y,GTEXT_DATA(k).text);
%     set(GTEXT_DATA(k).handle,'FontSize',str2num(GTEXT_DATA(k).font));
%     end
%     NH_COMMENT(2) = length(get(ch(1),'Children'))-NH_COMMENT(1);
%     NH_COMMENT(1) = 1; order_overlay_handle(4);
% end

