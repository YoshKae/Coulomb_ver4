function a = xy2lonlat(b)
% This converts cartesian coordinate to mapped coordinate following
% information from input file
% it requires 'calc_element.m' calculation in advance.
%
% b is vector [x y] in the cartesian coordinate
% a is converted [lon lat] in the mapped coordinate
global GRID XGRID YGRID
global MIN_LAT MIN_LON
global LON_GRID LAT_GRID
global LON_PER_X LAT_PER_Y XY_RATIO

% flag is prepared for not assigning and taking over the temporal but wrong
% info about LON_GRID which influences the coordinate mapping
flag  = 0;
flag1 = 0;
flag2 = 0;
flag3 = 0;
flag4 = 0;

%in case (to prevent error message)
if isempty(MIN_LAT)
    MIN_LAT = 0.0;
    flag1 = 1;
end
if isempty(MIN_LON)
    MIN_LON = 0.0;
    flag2 = 1;
end
if isempty(LON_GRID)
    LON_GRID(2) = 1.0;     LON_GRID(1) = 0.0;
    flag3 = 1;
end
if isempty(LAT_GRID)
    LAT_GRID(2) = 1.0;     LAT_GRID(1) = 0.0;
    flag4 = 1;
end
%

[m n] = size(b);
a = zeros(m,2);
dx = zeros(m,1);
dy = zeros(m,1);

xinc = XGRID(2) - XGRID(1);
yinc = YGRID(2) - YGRID(1);
loninc = LON_GRID(2) - LON_GRID(1);
latinc = LAT_GRID(2) - LAT_GRID(1);
LON_PER_X = loninc / xinc;
LAT_PER_Y = latinc / yinc;
% XY_RATIO = loninc / latinc;  % x / y
XY_RATIO = LON_PER_X / LAT_PER_Y;  % x / y
dx(:,1) = b(:,1) - GRID(1);
dy(:,1) = b(:,2) - GRID(2);
a(:,1) = MIN_LON + dx .* LON_PER_X;
a(:,2) = MIN_LAT + dy .* LAT_PER_Y;

flag = flag1 + flag2 + flag3 + flag4;
if flag >= 1
    MIN_LAT = []; MIN_LON = []; LON_GRID = []; LAT_GRID = [];
end
    


