% This is a script for calculating the basic information of elements and
% grid that should be shared in the other functions and scripts
%
% This code should be placed after the input file reading (input_open)
%
global ELE_STRIKE
global AV_STRIKE AV_DIP AV_RAKE
global AV_DEPTH
global GRID XGRID YGRID
global ELEMENT
global NUM
global MIN_LAT MAX_LAT MIN_LON MAX_LON ZERO_LON ZERO_LAT
global LON_GRID LAT_GRID ICOORD
global IACT % =0: recalculation  =1: use the current DC3D values
ELE_STRIKE = [];
AV_STRIKE = [];
AV_DIP = [];
AV_RAKE = [];

% Calc grid position and hold them for all the other functions
xstart = GRID(1,1);
ystart = GRID(2,1);
xfinish = GRID(3,1);
yfinish = GRID(4,1);
xinc = GRID(5,1);
yinc = GRID(6,1);
nxinc = int32((xfinish-xstart)/xinc + 1);
nyinc = int32((yfinish-ystart)/yinc + 1);
xpp = [1:1:nxinc];
ypp = [1:1:nyinc];
% XGRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
% YGRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);
XGRID = double(xstart) + (double(1:1:nxinc)-1.0) * double(xinc);
YGRID = double(ystart) + (double(1:1:nyinc)-1.0) * double(yinc);

%===== if map info exist
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
xstart = double(MIN_LON);
ystart = double(MIN_LAT);
xfinish = double(MAX_LON);
yfinish = double(MAX_LAT);
xinc = double(MAX_LON - MIN_LON) / double(nxinc-1);
yinc = double(MAX_LAT - MIN_LAT) / double(nyinc-1);
% LON_GRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
% LAT_GRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);
LON_GRID = double(xstart) + (double(1:1:nxinc)-1.0) * double(xinc);
LAT_GRID = double(ystart) + (double(1:1:nyinc)-1.0) * double(yinc);
        end
    end
end
%=====

if isempty(NUM); return; end

for n = 1:NUM
% (ELEMENT: xs, ys, xf, yf, latslip, dipslip, dip, top, bottom)
    xs = ELEMENT(n,1);
    ys = ELEMENT(n,2);
    xf = ELEMENT(n,3);
    yf = ELEMENT(n,4);
    %
    a = rad2deg(atan((yf-ys)/(xf-xs)));
    if xs > xf
        ELE_STRIKE(n) = 270.0 - a;
    else
        ELE_STRIKE(n) = 90.0 - a;
    end
end
    AV_STRIKE = sum(ELE_STRIKE)/double(NUM);
    AV_DIP = sum(ELEMENT(:,7))/double(NUM);
    av_lat_slip = sum(ELEMENT(:,5))/double(NUM);
    av_dip_slip = sum(ELEMENT(:,6))/double(NUM);
	AV_DEPTH = (sum(ELEMENT(:,8))+sum(ELEMENT(:,9)))/(2*double(NUM));
%
%     latslip = -15;
%     dipslip = 7;
% to escape "divided by zero"
if av_lat_slip == 0.0
    av_lat_slip = 0.000001;
end

    b = rad2deg(atan(av_dip_slip/av_lat_slip));
if av_lat_slip >= 0.0
    if av_dip_slip >= 0.0
        AV_RAKE = 180.0 - b;
    else
        AV_RAKE = -180.0 - b;
    end
else
    if av_dip_slip >= 0.0
        AV_RAKE = -b;
    else
        AV_RAKE = -b;     
    end
end

% dummy calc to get some paramenters for map coordinate
% LON_GRID

if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a  = xy2lonlat([GRID(1,1) GRID(2,1)]);
end

%
IACT = 0;


