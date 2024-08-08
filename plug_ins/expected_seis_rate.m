% function expected_seis_rate
%
% This function calculates expected seismicity rate during
% a certain time period which contains multiple mainshocks assigned as
% 'dcff' (structure) which is loaded from a selected file in the dialog
%
%       dcff.time (time stamp for each mainshock)
%       dcff.name (name of the mainshock)
%       dcff.cc   (a matrix of the coulomb stress change due to the shock)
%
%       xms xmf xmi xmn yms ymf ymi ymn
%                                       are also loaded
%
%  BACKGROUND is the background seismicity rate (if not existed, it sets to
%  all ones)
%
%   TWO INPUT VARIABLES NEEDED:
%   (1) dcff.cc (a matrix of coulomb stress change produced by
%   "make_multi_dcffs" function.
%   (2) BACKGROUND (produced by "smoothed_background.m". To load this
%   variable use "load function to incorporate this variable")
%
global BACKGROUND ANATOLIA

if exist('seisRate')
    clear seisRate
end

% *********** PARAMETER SETTINGS ***********************************
% ===== time series ================================================ 
%  start (syr smo sdy shr smn)    finish (fyr fmo fdy fhr smn)
%  (starting time should be before the earthquake)
        syr = 2017;                     fyr = 2019;
        smo =    8;                     fmo =    2;
        sdy =   19;                     fdy =   28;
        shr =   11;                     fhr =   23;
        smn =   59;                     fmn =   59;
        
        % 2017/12/31 : 145 days
        % 2018/12/31 : 510 days
% ===== rate and state parameters (assuming homogeneous media) =====
        asigma =  0.5;          % bar
        ta     =  5.;          % year
        taud   = asigma / ta;	% bar/yr
        
        sl = 1000.0;  % max coulomb value
% ===== calc. & visualization setting ===============================
        dyinc = 1.0;             % unit = day (increment for calc.)
        nfinc = 13;
                                % icrement of frames (days), number of frames N
                                % N = total calc. days / nfinc
        flag = 2;               % switching rate types (1) time shot & (2) cummulative at each time
        fint = 1;               % switching images : tiled or interporated (1: tiled, 2: interp)
        nsat = 0.25;              % saturation value for the color mapping

        % 
% setting for one year calc. starting 2017/8/9
%
%         dyinc = 10.0;             % unit = day (increment for calc.)
%         nfinc = 3;            % icrement of frames (days), number of frames N
%                                 % N = total calc. days / nfinc
%         flag = 2;               % switching rate types (1) time shot & (2) cummulative at each time
%         fint = 1;               % switching images : tiled or interporated (1: tiled, 2: interp)
%         nsat = 0.05;              % saturation value for the color mapping
% *****************************************************************
        
    [filename,pathname] = uigetfile({'*.mat'},' Open multi-dcff file');
    if isequal(filename,0)
        disp('  User selected Cancel');
         return
    else
        disp('  ----- Multi-dcff data set -----');
        disp(['  User selected', fullfile(pathname, filename)]);
        fid = fopen(fullfile(pathname, filename),'r');
        try
            load (fullfile(pathname, filename));    % for .mat file
        catch
            disp('A trouble when reading *.mat file');
            return
        end
    end
    fclose(fid);

neq = length(dcff);
try        
if isempty(BACKGROUND)
    disp('No coulomb and background data. Rate on each cell is set to all one.');
    BACKGROUND = ones(ymn,xmn);    
end
catch
	BACKGROUND = ones(ymn,xmn);  
end
[mb,nb] = size(BACKGROUND);

%  set to yr unit from dy unit using datenum function
	tstart0  = datenum(syr,1,1,0,0,0);
	tstart   = datenum(syr,smo,sdy,shr,smn,0);
	tfinish0 = datenum(fyr,1,1,0,0,0);
	tfinish  = datenum(fyr,fmo,fdy,fhr,fmn,0);
    tstart   = syr + (tstart  - tstart0)  / 365.25;
    tfinish  = fyr + (tfinish - tfinish0) / 365.25;
	tinc     = dyinc / 365.25; % a day (=1/365.25)
    tn       = int32((tfinish - tstart) / tinc) + 1;
    t1       = tstart+tinc*double(tn);
    tser     = tstart:tinc:t1;
    
    length(tser);

	for j = 1:length(dcff)
        [m,n] = size(dcff(j).cc);
    if m > mb
            temp = dcff(j).cc(1:mb,:);
            dcff(j).cc = temp;
            m = mb;
    elseif m < mb
            BACKGROUND = BACKGROUND(1:m,:);
    end
    if n > nb
        temp = dcff(j).cc(:,1:nb);
        dcff(j).cc = temp;
        n = nb;
    elseif n < nb
        BACKGROUND = BACKGROUND(:,1:n);
    end
    end
    xmn = size(BACKGROUND,2);
    ymn = size(BACKGROUND,1);
    
    for j=1:length(dcff)
        size(dcff(j).cc)
    end
    
for i = 1:length(tser)
% initial gamma (steady state)
    seisRate(i).gamma = zeros(ymn,xmn);
% initialization for each seismicity rate
	seisRate(i).rate  = zeros(ymn,xmn);
	seisRate(i).cumrate = zeros(ymn,xmn,'int32');
% simple summation of coulomb stress change matrices
    seisRate(i).sumcc = zeros(ymn,xmn);
end
    seisRate(1).gamma = zeros(ymn,xmn) + 1/taud;
    
    
% initialization
for j = 1:length(dcff)
[m,n] = size(dcff(j).cc);
% if m > mb
%     temp = dcff(j).cc(1:mb,:);
%     dcff(j).cc = temp;
%     m = mb;
% elseif m < mb
%     BACKGROUND = BACKGROUND(1:m,:);
% end
% MATLAB does not accept double precision for the exponential calculation
dcff(1).cc = single(dcff(1).cc);    %NEEDED ??????????????????
% To cut a certain stress values
for k = 1:m*n
    if dcff(j).cc(k) >= sl
        dcff(j).cc(k) = sl;
    elseif dcff(j).cc(k) <= -sl
        dcff(j).cc(k) = -sl;
    end
end
end
    
    
    
    for i = 1:length(tser)
        seisRate(i).time   = tser(i);
%        elapsedTime = seisRate(i).time - tstart;
        if i > 1
        % --- count number of shocks in this time period ---
        nsc_total = 0;
        for k = 1:neq
            if dcff(k).time > seisRate(i-1).time && dcff(k).time <= seisRate(i).time
                nsc_total = nsc_total + 1;
            end
        end
        
        nsc = 0;            % counter for number of stress change
        for k = 1:neq
            if dcff(k).time > seisRate(i-1).time && dcff(k).time <= seisRate(i).time
                if nsc == 0
                    clockb = dcff(k).time - seisRate(i-1).time;
                    % gamma decay with time (before the shock)
                    seisRate(i).gamma  = (seisRate(i-1).gamma-1.0/taud)...
                                        .* exp(((-clockb)*taud)/asigma)+1.0/taud;
                end
                % ****** gamma updated by signle stress change ********
                size(seisRate(i).gamma)
                size(dcff(k).cc)
                
                seisRate(i).gamma = seisRate(i).gamma .* exp((-1.0).*dcff(k).cc/asigma);
                
                if nsc_total == 1
                    clocka = seisRate(i).time - dcff(k).time;
                    if clocka == 0.0
                        clcka = 0.000001;
                    end
                elseif k ~= neq
                    clocka = dcff(k+1).time - dcff(k).time;
                end
                    % gamma decay with time (after the shock)
                    seisRate(i).gamma  = (seisRate(i).gamma-1.0/taud)...
                        .* exp(((-clocka)*taud)/asigma)+1.0/taud;
                if nsc == 0
                    seisRate(i).sumcc  = seisRate(i-1).sumcc + dcff(k).cc;
                else
                    seisRate(i).sumcc  = seisRate(i).sumcc + dcff(k).cc;
                end
                nsc = nsc + 1;
                if nsc == nsc_total
                    break
                end
            else
                % gamma decay with time
                seisRate(i).gamma  = (seisRate(i-1).gamma-1.0/taud)...
                                .* exp(((-tinc)*taud)/asigma)+1.0/taud;
                seisRate(i).sumcc  = seisRate(i-1).sumcc;
            end
        end
        end
        
          seisRate(i).rate   = flipud(BACKGROUND) ./ (seisRate(i).gamma .* taud);
%         seisRate(i).rate   = seisRate(i).gamma * taud;
         if i == 1
            seisRate(i).cumrate = seisRate(i).rate * tinc;
         else
            seisRate(i).cumrate = seisRate(i-1).cumrate + seisRate(i).rate * tinc;
         end
% PROBLEM PRODUCING INF & NAN ???????
%          sum(rot90(sum(isinf(seisRate(i).cumrate))))
%          sum(rot90(sum(isnan(seisRate(i).cumrate))))
% To remove INF & NAN element (?)
%         cinf   = isinf(seisRate(i).cumrate);
%         cnan   = isnan(seisRate(i).cumrate);
%         if sum(rot90(sum(cinf)))>=1 || sum(rot90(sum(cnan)))>=1
%             cerror = abs((cinf + cnan) - 1.0);
%             seisRate(i).cumrate = seisRate(i).cumrate .* cerror;
%         end
        cnan   = isnan(seisRate(i).cumrate);
        if sum(rot90(sum(cnan)))>=1
            cerror = abs(cnan - 1.0);
            seisRate(i).cumrate = seisRate(i).cumrate .* cerror;
        end
        
    end
    
return
    
%======= making image =================================
counter = 0;
% for nn = 1:nfinc:length(tser)
for nn = 1:nfinc:length(tser)
%     counter = counter + 1;    
counter = nn;
    h = figure('Name','Expected number of aftershocks','NumberTitle','off');
    hold on;
    if flag == 1
        if fint == 2
        [out,new_xgrid,new_ygrid] = interporation(seisRate(counter).cumrate, ...
                                    10, XGRID, YGRID);
        ac = image(out,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
        else
        ac = image(seisRate(counter).rate,'CDataMapping','scaled','XData',[xms xmf],...
            'YData',[ymf yms]);colormap(ANATOLIA); 
        end
    else
        if fint == 2
         [out,new_xgrid,new_ygrid] = interporation(seisRate(counter).cumrate, ...
                                     10, XGRID, YGRID);
        ac = image(out,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
        else
        ac = image(seisRate(counter).cumrate,'CDataMapping','scaled','XData',[xms xmf],...
            'YData',[ymf yms]);colormap(ANATOLIA);
        end
    end
    set(gca,'YDir','normal');

    dum0 = int32(seisRate(counter).time);
    dum1 = (seisRate(counter).time - double(dum0))*365.25;
    dum2 = datenum(double(dum0),1,1,0,0,0)+dum1;
    [yr mo dy hr mn sc] = datevec(dum2);
    
    title(['Cumulative aftershocks at ' num2str(yr,'%4i') '/' num2str(mo,'%2i'...
        ) '/' num2str(dy,'%2i') ' ' num2str(hr,'%2i') ':' num2str(mn,'%2i')]);
%     nsat = max(rot90(max(seisRate(nn).rate)))*1.0;
%    nsat = 1;
%    nsat = 0.1;


    % nsat = 50.0;
    caxis([-nsat nsat]);
    axis image;
    colorbar('location','EastOutside');
%    set(gcf,'render','opengl');

% --- to draw reliable rectangular area determined from radius
hold on;
r = 0;
xr0 = GRID(1)+r; yr0 = GRID(2)+r;
xr1 = GRID(3)-r; yr1 = GRID(4)-r;
plot([xr0 xr1 xr1 xr0 xr0],...
    [yr0 yr0 yr1 yr1 yr0]);
    set(gca,'DataAspectRatio',[1 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1]);

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

%     m(counter) = getframe(gcf);
    hold off;
end

%=== moview ======== (having a trouble)
%  movie(m,2);
   
    
    
    