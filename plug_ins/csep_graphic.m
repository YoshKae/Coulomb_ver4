function csep_graphic(titleStr,longrid,latgrid,cmax,colorSat)
%
% This is a simple function to render color image using a output matrix
%
% INPUT
%	titleStr: Strings for the graphic title e.g.'delta CFF map'
%   longrid:  a vector along longitude such as [start_long:incr_long:end_long]
%   latgrid:  a vector along latitude such as [start_lat: incr_lat:end_lat]
%   cmax:    matrix data to be rendered (length(latgrid) x length(longrid))
%   colorSat: color saturation value (scalar, e.g.,10)
%
%   DATA from 'DATABASE folder' should be placed in the same directory
%
% OUTPUT
%   single graphic window
%

%--------------------------------------------------------------------
%       Graphic output
%--------------------------------------------------------------------
load plug_ins/DATABASE/global_coastline_data.mat
load plug_ins/DATABASE/afaultdata_ca_ja_sich.mat
load plug_ins/DATABASE/plate_trench.mat
load plug_ins/DATABASE/plate_ridge.mat
load plug_ins/DATABASE/plate_transform.mat
load plug_ins/DATABASE/volcanoes_NGDC_NOAA.mat
load plug_ins/DATABASE/global_eqs.mat
load plug_ins/DATABASE/border.mat
figure;
set(gcf,'Position',[24 100 800 920]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPosition',[0.15 0.15 8 10.7]);
%-------- graphic parameters --------------------
load('MyColormaps','ANATOLIA'); % color map
load('MyColormap2','ANATOLIA_gray'); % color map
%    colorSat = 0.1;                 % color saturation (bar)

% xy aspect ratio for Japanese islands (dist lat deg / dist lon deg)
% aspect_ratio = 1.2526;
aspect_ratio = 1.0;

imageflag = 2;
cmax = flipud(cmax);

% ********** imaging coulomb ****************************************
    figure(gcf);
%     image(cmax,'CDataMapping','scaled','XData',[longrid(1) longrid(end)],...
%         'YData',[latgrid(1) latgrid(end)]);colormap(jet);

if imageflag == 1
    image(cmax,'CDataMapping','scaled','XData',[longrid(1) longrid(end)],...
        'YData',[latgrid(1) latgrid(end)]);colormap(ANATOLIA_gray);
else
    image(cmax,'CDataMapping','scaled','XData',[longrid(1) longrid(end)],...
        'YData',[latgrid(1) latgrid(end)]);colormap(ANATOLIA);
end
	set(gca,'YDir','normal');
%    set(gca,'YDir','reverse');
    set(gca,'DataAspectRatio',[aspect_ratio 1 1]);
    caxis([-colorSat colorSat]);    % color saturation control
    colorbar('location','EastOutside');
    title(titleStr);

% ********** plotting earthquakes ***********************************
%     hold on;
%     hs = scatter(outData(:,1), outData(:,2), 2 + outData(:,6)*10.,...
%         'MarkerEdgeColor','k',...
%         'MarkerFaceColor','r');

% ********** draw coastlines ****************************************
    if isempty(COAST_DATA)~=1
        [m,n] = size(COAST_DATA);   % to distinguish old or new format
        x1 = COAST_DATA(:,1);
        y1 = COAST_DATA(:,2);
        hold on;
        h = plot(gca,x1,y1,'Color','k','LineWidth',1.0);
        set(h,'Tag','CoastlineObj');
        hold on;
    end
% ********** draw active faults ****************************************
%     if isempty(AFAULT_DATA)~=1
%         [m,n] = size(AFAULT_DATA);
%         x1 = AFAULT_DATA(:,1);
%         y1 = AFAULT_DATA(:,2);
%         hold on;
%         h = plot(gca,x1,y1,'Color','b','LineWidth',1.0);
%         set(h,'Tag','AfaultObj');
%         hold on;
%     end

% ********** draw trench ****************************************
    if isempty(PLATE_TRENCH)~=1
        [m,n] = size(PLATE_TRENCH);
        x1 = PLATE_TRENCH(:,1);
        y1 = PLATE_TRENCH(:,2);
        hold on;
        h = plot(gca,x1,y1,'Color','b','LineWidth',1.0);
        set(h,'Tag','TrenchObj');
        hold on;
    end
    
% ********** plot volcanos *****************************    
%     if ~isempty(VOLCANO)
%         x = [VOLCANO(:).lon];
%         y = [VOLCANO(:).lat];
%         hold on;
%         h = plot(gca,x,y,'^',...
%             'MarkerFaceColor','m',...
%             'MarkerEdgeColor','k',...
%             'MarkerSize',7);
%         set(h,'Tag','VolcanoObj');
%         hold on;
%     end
    
%     a = plot([min_lon max_lon max_lon min_lon min_lon],...
%         [min_lat min_lat max_lat max_lat min_lat]);
%     set(a,'Color',[0.2 0.2 0.2]);
%     hold on;
%     xlim([min_lon max_lon]);
%     ylim([min_lat max_lat]);

% axis square % in reality (x axis should be stretched by 125%)
    
