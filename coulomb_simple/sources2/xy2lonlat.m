function a = xy2lonlat(b)
% This converts cartesian coordinate to mapped coordinate following
% information from input file
% it requires 'calc_element.m' calculation in advance.
%
% b is vector [x y] in the cartesian coordinate
% a is converted [lon lat] in the mapped coordinate
global INPUT_VARS
global COORD_VARS
global LON_PER_X LAT_PER_Y

% flag is prepared for not assigning and taking over the temporal but wrong
% info about LON_GRID which influences the coordinate mapping
flag1 = 0;
flag2 = 0;
flag3 = 0;
flag4 = 0;

%in case (to prevent error message)
if isempty(COORD_VARS.MIN_LAT)
    COORD_VARS.MIN_LAT = 0.0;
    flag1 = 1;
end
if isempty(COORD_VARS.MIN_LON)
    COORD_VARS.MIN_LON = 0.0;
    flag2 = 1;
end
if isempty(COORD_VARS.LON_GRID)
    COORD_VARS.LON_GRID(2) = 1.0;
    COORD_VARS.LON_GRID(1) = 0.0;
    flag3 = 1;
end
if isempty(COORD_VARS.LAT_GRID)
    COORD_VARS.LAT_GRID(2) = 1.0;
    COORD_VARS.LAT_GRID(1) = 0.0;
    flag4 = 1;
end
%

[m, n] = size(b);
a = zeros(m,2);
dx = zeros(m,1);
dy = zeros(m,1);

xinc = COORD_VARS.XGRID(2) - COORD_VARS.XGRID(1);
yinc = COORD_VARS.YGRID(2) - COORD_VARS.YGRID(1);
loninc = COORD_VARS.LON_GRID(2) - COORD_VARS.LON_GRID(1);
latinc = COORD_VARS.LAT_GRID(2) - COORD_VARS.LAT_GRID(1);
LON_PER_X = loninc / xinc;
LAT_PER_Y = latinc / yinc;
COORD_VARS.XY_RATIO = LON_PER_X / LAT_PER_Y;  % x / y
dx(:,1) = b(:,1) - INPUT_VARS.GRID(1);
dy(:,1) = b(:,2) - INPUT_VARS.GRID(2);
a(:,1) = COORD_VARS.MIN_LON + dx .* LON_PER_X;
a(:,2) = COORD_VARS.MIN_LAT + dy .* LAT_PER_Y;

flag = flag1 + flag2 + flag3 + flag4;
if flag >= 1
    COORD_VARS.MIN_LAT = [];
    COORD_VARS.MIN_LON = [];
    COORD_VARS.LON_GRID = [];
    COORD_VARS.LAT_GRID = [];
end
