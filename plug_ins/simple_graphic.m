function simple_graphic(titleStr,longrid,latgrid,cmax,colorSat)
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
% load DATABASE/global_coastline_data.mat
% load DATABASE/afaultdata_ca_ja_sich.mat
% load DATABASE/plate_trench.mat
% load DATABASE/plate_ridge.mat
% load DATABASE/plate_transform.mat
% load DATABASE/volcanoes_NGDC_NOAA.mat
% load DATABASE/global_eqs.mat
% load DATABASE/border.mat
figure;
set(gcf,'Position',[24 100 800 920]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPosition',[0.15 0.15 8 10.7]);
%-------- graphic parameters --------------------
    load('MyColormaps','ANATOLIA'); % color map
%    colorSat = 0.1;                 % color saturation (bar)
% ********** imaging coulomb ****************************************
    figure(gcf);
%     h  = subplot(2,1,j); hold on
    image(cmax,'CDataMapping','scaled','XData',[longrid(1) longrid(end)],...
        'YData',[latgrid(1) latgrid(end)]);colormap(ANATOLIA);
    set(gca,'YDir','normal');
    caxis([-colorSat colorSat]);    % color saturation control
    colorbar('location','EastOutside');
    title(titleStr);