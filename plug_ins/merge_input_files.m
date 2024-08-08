function merge_input_files
% This function merges two input files into one input file. Keep open one
% input file to put another one.
global H_MAIN INPUT_FILE
global NUM HEAD ELEMENT KODE ID FCOMMENT GRID FRIC CALC_DEPTH
global POIS YOUNG R_STRESS
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA GTEXT_DATA
global MIN_LON MAX_LON MIN_LAT MAX_LAT ZERO_LON ZERO_LAT
global LON_PER_X LAT_PER_Y XY_RATIO XGRID YGRID
global FUNC_SWITCH IRAKE IND_RAKE

% first set the handvisibility for the main window on
set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);

% Keep current input parameters as different variable...
    filename1    = INPUT_FILE;
    num1         = int16(NUM);
    header1      = HEAD;
    element1     = ELEMENT;
    kode1        = KODE;
    id1          = ID;
    fcomment1    = FCOMMENT;
    
    irake1       = IRAKE;
    ind_rake1    = IND_RAKE;

    calcdepth1   = CALC_DEPTH;
    fric1        = FRIC;
    pois1        = POIS;
    young1       = YOUNG;
    r_stress1    = R_STRESS;
    
    coast_data1  = COAST_DATA;
    afault_data1 = AFAULT_DATA;
    eq_data1     = EQ_DATA;
    gtext_data1  = GTEXT_DATA;
    
    minlon1      = MIN_LON;
    maxlon1      = MAX_LON;
    minlat1      = MIN_LAT;
    maxlat1      = MAX_LAT;
    zerolon1     = ZERO_LON;
    zerolat1     = ZERO_LAT;
	grid1        = GRID;
    lonperx1     = LON_PER_X;
    latpery1     = LAT_PER_Y;
    xyratio1     = XY_RATIO;
    nxgrid1      = length(XGRID);
    nygrid1      = length(YGRID);
    
%-------------------------------------------------------------------------
%           read another file
%-------------------------------------------------------------------------
    input_open(3);          % 3 means skipping the open window
    filename2    = INPUT_FILE;
    num2         = int16(NUM);
    header2      = HEAD;
    element2     = ELEMENT;
    kode2        = KODE;
    id2          = ID;
    fcomment2    = FCOMMENT;
    
    IND_RAKE     = [];
    irake2       = IRAKE;
    ind_rake2    = IND_RAKE;
    
	minlon2      = MIN_LON;
    maxlon2      = MAX_LON;
    minlat2      = MIN_LAT;
    maxlat2      = MAX_LAT;
    zerolon2     = ZERO_LON;
    zerolat2     = ZERO_LAT;
    grid2        = GRID;
    a = xy2lonlat([GRID(1) GRID(2)]); % dummy to get XY_RATIO
    lonperx2     = LON_PER_X;
    latpery2     = LAT_PER_Y;
    xyratio2     = XY_RATIO;
    
    LON_PER_X = (lonperx1 + lonperx2) / 2.0;
    LAT_PER_Y = (latpery1 + latpery2) / 2.0;
    XY_RATIO  = LON_PER_X / LAT_PER_Y;  % x / y
    XY_RATIO  = (xyratio1 + xyratio2) / 2.0;

    x1 = deg2km(distance(zerolat1,zerolon1,zerolat1,zerolon2));
    x2 = deg2km(distance(zerolat2,zerolon1,zerolat2,zerolon2));
    xshift = (x1+x2)/2.0;
    y1 = deg2km(distance(zerolat1,zerolon1,zerolat2,zerolon1));
    y2 = deg2km(distance(zerolat1,zerolon2,zerolat2,zerolon2));
    yshift = (y1+y2)/2.0;
    if zerolon2 > zerolon1
        xshift = -xshift;
    end
    if zerolat2 > zerolat1
        yshift = -yshift;
    end

    check_rake_format = irake1 - irake2;
    if check_rake_format ~= 0
        disp('  Input formats are different between two. Do you prefer');
        disp('  right-lat slip & dip slip format (1) or ');
        disp('  rake           & net slip format (2)?');
        rake_format = input('  Type 1 or 2 here.', 's');
        if isempty(rake_format)
            IRAKE = 0;
        else
            if str2num(rake_format) == 1
                IRAKE = 0;
            else
                IRAKE = 1;
            end
        end
        if IRAKE == 0        % set two slip comp columns
            if irake1 == 1
                [element1(:,5),element1(:,6)] = rake2comp(element1(:,5),...
                                                          element1(:,6));
            else
                [element2(:,5),element2(:,6)] = rake2comp(element2(:,5),...
                                                          element2(:,6));
            end
            IND_RAKE = [];
        else                 % set netslip and rake columns
            if irake1 == 0
                [element1(:,5),element1(:,6)] = comp2rake(element1(:,5),...
                                                          element1(:,6));
                ind_rake1(:,1) = element1(:,5);
            else
                [element2(:,5),element2(:,6)] = comp2rake(element2(:,5),...
                                                          element2(:,6));
                ind_rake2(:,1) = element2(:,5);
            end 
        end
    end
    NUM = int16(num1) + int16(num2);
%     NUM = num1 + num2;
    num11 = int16(num1 + 1);
    ELEMENT = zeros(NUM,9,'double');
    HEAD = header1;
    ELEMENT(1:num1,:) = element1;
    if IRAKE == 1
        IND_RAKE = [ind_rake1; ind_rake2];
    end
%     num1
%     num2
%     NUM
%     size(ELEMENT)
%     size(element2)
%     isfloat(ELEMENT)
%     isfloat(element2)
%    ELEMENT(num1+1:NUM,:) = element2;
        ELEMENT(num11:NUM,:) = element2;
    ID(1:num1,:) = id1;
    ID(num11:NUM,:) = id2;
        ELEMENT(num11:NUM,1) = element2(:,1) - xshift;
        ELEMENT(num11:NUM,3) = element2(:,3) - xshift;
        ELEMENT(num11:NUM,2) = element2(:,2) - yshift;
        ELEMENT(num11:NUM,4) = element2(:,4) - yshift;
%     KODE = zeros(NUM,1,'unit8');
    KODE(1:num1,1)     = kode1;
    KODE(num1+1:NUM,1) = kode2;
    
    try
        for mm = 1:num1
            FCOMMENT(mm).ref = fcomment1(mm).ref;
        end
        for nn = num11:NUM
            FCOMMENT(nn).ref = fcomment2(nn-num1).ref;
        end
    catch
%    FCOMMENT.ref(1:NUM) = [];
    end
    grid2(1) = grid2(1) - xshift; grid2(3) = grid2(3) - xshift;
    grid2(2) = grid2(2) - yshift; grid2(4) = grid2(4) - yshift;
    if grid2(1) < grid1(1)
        GRID(1) = grid2(1); MIN_LON = minlon2;
    else
        GRID(1) = grid1(1); MIN_LON = minlon1;
    end
    if grid2(3) > grid1(3)
        GRID(3) = grid2(3); MAX_LON = maxlon2;
    else
        GRID(3) = grid1(3); MAX_LON = maxlon1;
    end
    if grid2(2) < grid1(2)
        GRID(2) = grid2(2); MIN_LAT = minlat2;
    else
        GRID(2) = grid1(2); MIN_LAT = minlat1;
    end
    if grid2(4) > grid1(4)
        GRID(4) = grid2(4); MAX_LAT = maxlat2;
    else
        GRID(4) = grid1(4); MAX_LAT = maxlat1;
    end
        GRID(5) = int16((GRID(3)-GRID(1)) / nxgrid1);
        GRID(6) = int16((GRID(4)-GRID(2)) / nxgrid1);
    HEAD = header1;
    CALC_DEPTH = calcdepth1;
    FRIC = fric1;
    POIS = pois1;
    YOUNG = young1;
    R_STRESS= r_stress1;
    INPUT_FILE = filename1;
    ZERO_LON = zerolon1;
    ZERO_LAT = zerolat1;
    
calc_element;
% ---- draw grid 2D again using new variables ---------------
subfig_clear;
FUNC_SWITCH = 1;
grid_drawing;
fault_overlay;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
    end
%end
FUNC_SWITCH = 0; %reset
set(H_MAIN,'HandleVisibility','callback');




    
    
    
    