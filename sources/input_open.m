function input_open(N)
%   For reading Coulomb input file
% input_open reads the Coulomb formatted input file into MATLAB
%
% N is the number indentifies if file content should be shown or not.
%   N=1: show dialog to confirm and change the parameters
%   N=2: making new file
%   N=3: skip showing the dialog
%
global H_INPUT % handle of figure
global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global FCOMMENT GRID SIZE SECTION
global IACT IACTS
global FLAG_SLIP_LINE
global PREF_DIR HOME_DIR INPUT_FILE
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA VOLCANO
global S_ELEMENT
global IRAKE % flag for input file style (0:lateral/reverse, 1:rake/netslip)
global IND_RAKE % to keep individual rake (one column data)
global DIALOG_SKIP % signal to skip open the input dialog (1: skip, others:not skip)
global PREF
global SEC_XS SEC_XF SEC_YS SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global LAT_GRID LON_GRID

IACT  = 0;
IACTS = 0;
FLAG_SLIP_LINE = 0;
num_buffer = 100; % to adjust NUM in case #fixed & #fault lines are different
 
if DIALOG_SKIP ~= 1 | isempty(DIALOG_SKIP)
    if isempty(PREF_DIR) ~= 1
        try
            cd(PREF_DIR);
        catch
            cd(HOME_DIR);
        end
    else
        try
            cd('input_files');
        catch
            cd(HOME_DIR);
        end
    end
    try

        [filename,pathname] = uigetfile( ...
                {'*.inp;*.inr;*.mat','Open input file (*.inp,*.inr,*.mat)';
                '*.inp',  'ascii input (*.inp)'; ...
                '*.inr',  'ascii input (*.inr)'; ...
                '*.mat','binary input (*.mat)'}, ...
                 'Pick a file');
        if isequal(filename,0)
            disp('---------------------------------------------------');
            disp('User selected Cancel');
            cd(HOME_DIR);
            IACT = 1; % to keep information for the previous session
            return
        else
            disp('---------------------------------------------------');
            disp(['User selected', fullfile(pathname, filename)]);
        end
    catch
        errordlg('You might have opened wrong formatted file');
        return;
    end
else % corresponding to if DIALOG_SKIP ~= 1 (when last_input function read)
    pathname = PREF_DIR;
    filename = INPUT_FILE;
    if strcmp(filename,'empty')
        disp('No file most recently used. Use menu ''Open existing input file''');
        return
    end
    disp('---------------------------------------------------');
    disp(['User selected', fullfile(pathname, filename)]);
end % corresponding to if DIALOG_SKIP ~= 1

% initialization
HEAD=[]; NUM=[]; POIS=[]; CALC_DEPTH=[]; YOUNG=[];
FRIC=[]; R_STRESS=[]; ID=[]; KODE=[]; ELEMENT=[];
FCOMMENT=[]; GRID=[]; SIZE=[]; SECTION=[];
MIN_LAT = []; MAX_LAT = []; ZERO_LAT = [];
MIN_LON = []; MAX_LON = []; ZERO_LON = [];
COAST_DATA = []; AFAULT_DATA = []; EQ_DATA = []; VOLCANO = [];
GPS_DATA = []; S_ELEMENT = [];
LAT_GRID = []; LON_GRID = [];

    try
        load (fullfile(pathname, filename));    % for .mat file
    catch
        try
            try
            fid = fopen(fullfile(pathname, filename),'r');              % for ascii file
            catch
            errordlg('The file might be corrupted or wrong one');
            return;
            end
        catch
            errordlg('The file might be corrupted. Check the content.');
            return;
        end
    end
    
    if isempty(HEAD) ~= 1                       % for .mat file
        disp('mat formatted file was read.');
        if size(PREF,1)==8
            dummy = PREF;
            PREF  = [dummy; [0.9 0.9 0.1 1.0]];
        end
        calc_element;
        if N == 1
            H_INPUT = input_window;
        end
            PREF_DIR   = pathname;
            INPUT_FILE = filename;
            cd(HOME_DIR);
            INUM = repmat(uint8(1),1,1);
            return
    end                                         % return...
                                                % no more for .mat file
    PREF_DIR   = pathname;
    INPUT_FILE = filename;
    cd(HOME_DIR);

% default fault # indication
INUM = repmat(int16(1),1,1);

if N~=2
% header
%   painful process to read text... (tell me more easy way...)
%   This process for reading only works for within 15 words...
sp = ' ';
head1 = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1);
head1{:};
head2 = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1);
head2{:};
a = [head1{:};head2{:}];
b1 = char(a(1,:));
c1 = cellstr([deblank(b1(1,:)) sp deblank(b1(2,:)) sp deblank(b1(3,...
    :)) sp deblank(b1(4,:)) sp deblank(b1(5,:)) sp deblank(b1(6,...
    :)) sp deblank(b1(7,:)) sp deblank(b1(8,:)) sp deblank(b1(9,...
    :)) sp deblank(b1(10,:)) sp deblank(b1(11,:)) sp deblank(b1(12,...
    :)) sp deblank(b1(13,:)) sp deblank(b1(14,:)) sp deblank(b1(15,:))]);    
b2 = char(a(2,:));
c2 = cellstr([deblank(b2(1,:)) sp deblank(b2(2,:)) sp deblank(b2(3,...
    :)) sp deblank(b2(4,:)) sp deblank(b2(5,:)) sp deblank(b2(6,...
    :)) sp deblank(b2(7,:)) sp deblank(b2(8,:)) sp deblank(b2(9,...
    :)) sp deblank(b2(10,:)) sp deblank(b2(11,:)) sp deblank(b2(12,...
    :)) sp deblank(b2(13,:)) sp deblank(b2(14,:)) sp deblank(b2(15,:))]);
HEAD = [c1; c2];

% number of faults
d = textscan(fid,'%*s %*s %*s %*s %*s %4u16 %*s %*s',1);  %need dummy reading
NUM = int32([d{1}]);    % which means the maximum number of elements are 65,535.
NUM = NUM + num_buffer;

% Poisson's ratio & calculation depth
e = textscan(fid,'%*s %15.3f32 %*s %*s %*s %15.3f32',1);
POIS = double([e{1}]);
CALC_DEPTH = double([e{2}]);

% Young's modulus
f = textscan(fid,'%*s %n %*s %*s',1);
YOUNG = double([f{1}]);

% Passing symmetry parameters (no longer used for Coulomb)
g = textscan(fid,'%*s %*s %*s %*s', 1);

% friction coefficient
h = textscan(fid,'%*s %15.3f32', 1);
FRIC = double([h{1}]);

% regional stress field
s = textscan(fid,'%*s %15.6f32 %*s %15.6f32 %*s %15.6f32 %*s %15.6f32',3);
R_STRESS = [s{:}];

% To detect slip component type
% Normally "right-lat" and "reverse"
% But if the label contains "rake", it changes to "rake" and "net slip"
% Units are degree and meter.
dum0 = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
IRAKE    = 0;
IND_RAKE = [];
for k = 1:20
    if isempty(strmatch('rake',dum0{k}(:)))~=1
        IRAKE = 1;
    end
end

% dummy for passing through "xxxxxxxxxx xxxxxxxxxx" line
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',1);


% fault elements

flt = textscan(fid,...
    '%3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %s %s %s %s %s %s %s %s %s %s', NUM);

ID = uint16([flt{1}]);
if length(ID) ~= NUM - num_buffer
	disp('************************************************************************');
    disp('**  Please change #fixed in the 3rd row in the input file afterward.  **');
    disp('************************************************************************');
end

NUM = length(ID);

KODE = uint16([flt{6}]);
ELEMENT = [flt{2:5} flt{7:11}];
ELEMENT = double(ELEMENT);
% for comments after element param lineup
a = [flt{12:21}];
for k = 1:NUM
b = char(a(k,:));
c = cellstr([deblank(b(1,:)) sp deblank(b(2,:)) sp deblank(b(3,...
    :)) sp deblank(b(4,:)) sp deblank(b(5,:)) sp deblank(b(6,...
    :)) sp deblank(b(7,:)) sp deblank(b(8,:)) sp deblank(b(9,:))]);    
FCOMMENT(k).ref = [c];
end

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% grid parameters
gr = textscan(fid,'%*45c %16.7f32',6);
GRID = double([gr{:}]);

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% size
sz = textscan(fid,'%*45c %16.7f32',3);
SIZE = [sz{:}];

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% cross section
cs = textscan(fid,'%*45c %16.7f32',7);
SECTION = [cs{:}];
if isempty(SECTION) == 1
   disp('   No info for a cross section line is included in the input file.');
end

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% map info parameters
mi = textscan(fid,'%*45c %16.7f32',6)
mapinfo = double([mi{:}])
if isempty(mapinfo) ~= 1
MIN_LON = mapinfo(1,1); MAX_LON = mapinfo(2,1); ZERO_LON = mapinfo(3,1);
MIN_LAT = mapinfo(4,1); MAX_LAT = mapinfo(5,1); ZERO_LAT = mapinfo(6,1);
else
    disp('   No lat. & lon. information is included in the input file.');
end

% check if all parameters are properly read or not.
if isempty(NUM) == 1
	errordlg('Number of faults is not read. Make sure the input file.');
	return;
end
if isempty(POIS) == 1
    errordlg('Poisson ratio is not read. Make sure the input file.');
    return;
end
if isempty(YOUNG) == 1
    errordlg('Young modulus is not read. Make sure the input file.');
    return;
end
if isempty(FRIC) == 1
    errordlg('Coefficient of friction is not read. Make sure the input file.');
    return;
end
if isempty(R_STRESS) == 1
    errordlg('Regional stress values are not read. Make sure the input file.');
    return;
end
if isempty(GRID) == 1
    errordlg('Grid info for study area is not read properly. Make sure the input file.');
    return;
end
fclose (fid);

clear a b1 b2 c1 c2 d e f g h s dum flt gr sz cd mi;
end

% to change "rake" and "net slip" type to "right-lat" and "reverse" type
if IRAKE == 1
    if mean(KODE) == 100
        count = 0;
        for j=1:NUM
            for i=1:ID(j)
                count = count + 1;
                IND_RAKE(count,1) = ELEMENT(j,5);   % To keep the rake information
            end
        end
    [ELEMENT(:,5) ELEMENT(:,6)] = rake2comp(ELEMENT(:,5),ELEMENT(:,6));
    else
        h = warndlg('Rake & net slip style should be with Kode 100',...
            '!! Warning !!');
        waitfor(h);
        return
    end
end

% to calculate and save numbers for basic info
calc_element;
if ~isempty(SECTION)
   a = xy2lonlat([SECTION(1) SECTION(2)]);
   SEC_XS = a(1,1);          
   SEC_XF = a(1,2);
   a = xy2lonlat([SECTION(3) SECTION(4)]);
   SEC_YS = a(1,1); 
   SEC_YF = a(1,2);
   SEC_INCRE = SECTION(5);
   SEC_DEPTH = SECTION(6);
   SEC_DEPTHINC = SECTION(7);
   SEC_DIP      = 90.0;
   SEC_DOWNDIP_INC = SECTION(7);
end

if N == 1
% open input window dialog %%%% temporarily shut off %%%%%%%%%%%%%%
H_INPUT = input_window;
end

% %----- calc Moment -------------------------
seis_moment;
disp('---> To calculate deformation, select one of the submenus from ''Functions''.');
disp(' ');
