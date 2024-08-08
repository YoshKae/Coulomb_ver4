% Script to render I2 (second invariant) of strain tensor
%
% 
% I2 = |T22 T32|+|T11 T21|+|T11 T31|
%      |T23 T33| |T12 T22| |T13 T33|
%
% Warning: Execute after any operation of strain calc functions on Coulomb.
% Otherwise it uses stress or empty info from DC3D.
% 
%   coded by Shinji Toda on Jan. 5, 2013
%


% set up the value for color saturation
nsat = 1.0E-9;

global ANATOLIA

t11  = DC3D(:,9);  %SXX
t22  = DC3D(:,10); %SYY
t33  = DC3D(:,11); %SZZ
t12  = DC3D(:,14); %SXY
t13  = DC3D(:,13); %SXZ
t21  = DC3D(:,14); %SXY
t23  = DC3D(:,12); %SYZ
t31  = DC3D(:,13); %SXZ
t32  = DC3D(:,12); %SYZ

m    = size(DC3D,1);
temp = zeros(m,1);

for j = 1:m
    temp(j) =  det([t22(j) t32(j); t23(j) t33(j)])...
             + det([t11(j) t21(j); t12(j) t22(j)])...
             + det([t11(j) t31(j); t13(j) t33(j)]);
end
    i2 = flipud(reshape(temp,length(YGRID),length(XGRID)));

h = figure('Name','Second invariant (I2) of strain tensor','NumberTitle','off');
[out,new_xgrid,new_ygrid] = interporation(i2,10, XGRID, YGRID);
ac = image(out,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
set(gca,'YDir','normal');
title('Second invariant (I2)');
caxis([-nsat nsat]);
axis image;
colorbar('location','EastOutside');

% ----- coast line plot -----
if isempty(COAST_DATA)~=1
        hold on;
    [m,n] = size(COAST_DATA);
    if n == 9
        x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
        y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
    else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
        hold on;
end
% ----- active fault plot -----
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
end
    hold off;

    
    