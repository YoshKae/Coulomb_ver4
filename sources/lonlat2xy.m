function a=lonlat2xy(b)
% This converts mapped coordinates to cartesian coordinates
%
% b is vector [lon lat] in the mapped coordinate
% a is converted [x y] in the cartesian coordinate
global GRID XGRID YGRID
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global LON_GRID LAT_GRID
global LON_PER_X LAT_PER_Y XY_RATIO

[m n] = size(b);
a = zeros(m,2);
dlon = zeros(m,1);
dlat = zeros(m,1);

loninc = LON_GRID(2) - LON_GRID(1);
latinc = LAT_GRID(2) - LAT_GRID(1);
xinc = XGRID(2) - XGRID(1);
yinc = YGRID(2) - YGRID(1);
x_per_lon = xinc / loninc;
y_per_lat = yinc / latinc;
dlon(:,1) = b(:,1) - MIN_LON;
dlat(:,1) = b(:,2) - MIN_LAT;
a(:,1) = GRID(1) + dlon .* x_per_lon;
a(:,2) = GRID(2) + dlat .* y_per_lat;
