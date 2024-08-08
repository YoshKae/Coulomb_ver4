% 

thrB = 0.000001;
thrA = 0.05;
sat_control = 0.000001;

nn = numel(BKG_BF);
% c1 = reshape(BKG_BF,nn,1);
% c2 = reshape(BKG_AF,nn,1);
% scatter(c1,c2);
% xlim([0 0.2]);
% xlabel('Background');
% ylabel('Aftershocks');

BKG_CC = zeros(size(BKG_BF,1),size(BKG_BF,2));
db = BKG_BF <= thrB;
da = BKG_AF >= thrA;
BKG_CC = (-1.0) * db .* da;

%===========================================
fint = 1;
figure('Name','Annual seismicity rate in each grid area','NumberTitle','off');
hold on;
if fint == 2
	[out,new_xgrid,new_ygrid] = interporation(BKG_CC, ...
                                    10, XGRID, YGRID(1:end-1));
	ac = image(flipud(out),'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
else
    ac = image(BKG_CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(1) YGRID(end)]);colormap(ANATOLIA);
end
set(gca,'YDir','normal');
title(['Background seismicity rate [ / yr / ' num2str(GRID(5)*GRID(6),'%5.3f') ' km^2]']);
% nsat = max(rot90(max(BACKGROUND)))*sat_control;
nsat = abs(sat_control);

caxis([-nsat nsat]);
axis image;
colorbar('location','EastOutside');


%======== overlay drawing ============================
% global COAST_DATA EQ_DATA AFAULT_DATA GTEXT_DATA
% global ICOORD LON_GRID PREF
% global NH_COMMENT
% global H_MAIN

% ----- coast line plot -----
if isempty(COAST_DATA)~=1
        hold on;
    [m,n] = size(COAST_DATA);
%     if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
%         y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
%     else
    if n == 9
        x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
        y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
    else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
    end
%    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
%         set(h,'Tag','CoastlineObj');
        hold on;
end
% % ----- active fault plot -----
if isempty(AFAULT_DATA)~=1
         hold on;
    [m,n] = size(AFAULT_DATA);
    if n == 9
        x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
        y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
    else
        x1 = AFAULT_DATA(:,3);
        y1 = AFAULT_DATA(:,4);
    end
    h = plot(gca,x1,y1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
%     set(h,'Tag','AfaultObj');
  
end
