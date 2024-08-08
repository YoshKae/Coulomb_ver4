function coulomb_input_file_converter(n)
%   For reading Coulomb input file
%  
%   n = 1: inp to inr
%   n = 2: inr to inp
%
num_buffer = 100; % to adjust NUM in case #fixed & #fault lines are different

%=================================================================
%   READING PROCESS
%=================================================================
homedir = pwd;
try
	cd('input_files');
catch
	cd(homedir);
end
    currentdir = pwd;
    if n == 1
    [filename,pathname] = uigetfile( ...
                {'*.inp','Open input file (*.inp)';
                '*.inp',  'ascii input (*.inp)'}, ...
                 'Pick a file');
    else
    [filename,pathname] = uigetfile( ...
                {'*.inr','Open input file (*.inr)';
                '*.inr',  'ascii input (*.inr)'}, ...
                 'Pick a file');
    end
	if isequal(filename,0)
            disp('---------------------------------------------------');
            disp('User selected Cancel');
            cd(homedir);
            return
	else
            disp('---------------------------------------------------');
            disp(['User selected', fullfile(pathname, filename)]);
	end
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
	fid = fopen(fullfile(pathname, filename),'r');              % for ascii file
catch
	errordlg('The file might be corrupted or wrong one');
    return;
end 
% default fault # indication
INUM = repmat(int16(1),1,1);
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
IRAKE = 0;
for k = 1:20
%    dum0{k}(:);
    if isempty(strmatch('rake',dum0{k}(:)))~=1
        IRAKE = 1;
    end
end

% dummy for passing through "xxxxxxxxxx xxxxxxxxxx" line
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',1);


% fault elements
% flt = textscan(fid,...
%     '%3u16 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %3u16 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %s %s %s %s %s %s %s %s %s %s', NUM);
flt = textscan(fid,...
    '%3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %s %s %s %s %s %s %s %s %s %s', NUM);

ID = uint16([flt{1}]);
if length(ID) ~= NUM - num_buffer
	disp('************************************************************************');
    disp('**  Please change #fixed in the 3rd row in the input file afterward.  **');
    disp('************************************************************************');
end
% if length(ID) < NUM - num_buffer
NUM = length(ID);
% end

% KODE = int16([flt{6}])
KODE = uint16([flt{6}]);
% (ELEMENT: xs, ys, xf, yf, latslip, dipslip, dip, top, bottom)
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
mi = textscan(fid,'%*45c %16.7f32',6);
mapinfo = double([mi{:}]);
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

% to change "rake" and "net slip" type to "right-lat" and "reverse" type
if IRAKE == 1
    if mean(KODE) == 100
        count = 0;
        for j=1:NUM
            for i=1:ID(j)
                count = count + 1;
%        IND_RAKE(count,1) = zeros(length(ELEMENT(j,5)),1);
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
% calc_element;
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


% %----- calc Moment -------------------------
seis_moment;

disp('The input file was properly read.');

%========================================================
%   File saving process
%========================================================
% global HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
% global FCOMMENT GRID SIZE SECTION
% global MIN_LON MAX_LON MIN_LAT MAX_LAT ZERO_LON ZERO_LAT
% global IRAKE IND_RAKE
% global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
if n == 1
    filename = [filename(1:end-4) '_converted.inr'];
elseif n == 2
    filename = [filename(1:end-4) '_converted.inp'];
end

fid = fopen(filename,'wt');
fprintf(fid,[HEAD{1}]); fprintf(fid,' \n');
fprintf(fid,[HEAD{2}]); fprintf(fid,' \n');
fprintf(fid,'#reg1=  0  #reg2=  0  #fixed= %3i  sym=  1\n',NUM);
fprintf(fid,' PR1=%12.3f     PR2=%12.3f   DEPTH=%12.3f\n',POIS,POIS,CALC_DEPTH);
fprintf(fid,'  E1=%15.3e   E2=%15.3e\n',YOUNG,YOUNG);
fprintf(fid,'XSYM=       .000     YSYM=       .000\n');
fprintf(fid,'FRIC=%15.3f\n',FRIC);
fprintf(fid,'S1DR=%15.3f',R_STRESS(1,1));
fprintf(fid,' S1DP=%15.3f',R_STRESS(1,2));
fprintf(fid,' S1IN=%15.3f',R_STRESS(1,3));
fprintf(fid,' S1GD=%15.3f\n',R_STRESS(1,4));
fprintf(fid,'S2DR=%15.3f',R_STRESS(2,1));
fprintf(fid,' S2DP=%15.3f',R_STRESS(2,2));
fprintf(fid,' S2IN=%15.3f',R_STRESS(2,3));
fprintf(fid,' S2GD=%15.3f\n',R_STRESS(2,4));
fprintf(fid,'S3DR=%15.3f',R_STRESS(3,1));
fprintf(fid,' S3DP=%15.3f',R_STRESS(3,2));
fprintf(fid,' S3IN=%15.3f',R_STRESS(3,3));
fprintf(fid,' S3GD=%15.3f\n\n',R_STRESS(3,4));
%
temp_element = ELEMENT; % to avoid accidental overwriting
%
if n == 2           % right-lat & reverse slip format
    fprintf(fid,'  #   X-start    Y-start     X-fin      Y-fin   Kode  rt.lat    ');
    fprintf(fid,'reverse   dip angle     top      bot\n');
    fprintf(fid,'xxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxx xxxxxxxxxx ');
    fprintf(fid,'xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx\n');
elseif n == 1       % rake & net-slip format
    fprintf(fid,'  #   X-start    Y-start     X-fin      Y-fin   Kode   rake     ');
    fprintf(fid,'netslip   dip angle     top        bot\n');
    fprintf(fid,'xxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxx xxxxxxxxxx ');
    fprintf(fid,'xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx\n');
    imessage = 0;
    if n == 1
        for k = 1:NUM
            if ELEMENT(k,5)==0.0 && ELEMENT(k,6)==0.0
                temp_element(k,5) = 0.0;
                temp_element(k,5) = 0.0;
                imessage = 1;
            else
                [temp_element(k,5) temp_element(k,6)] = comp2rake(ELEMENT(k,5),ELEMENT(k,6));
            end
        end
        if imessage == 1
        warndlg({'No slip element exists.';'See command window for details.'});
        disp('Since slip is zero, rake and net slip have been set to 0.0; you must assign a rake to this patch if you want to use it as receiver.');
        end
    else
        for k = 1:NUM
            if ELEMENT(k,5)==0.0 && ELEMENT(k,6)==0.0
                temp_element(k,5) = IND_RAKE(k,1);
                temp_element(k,5) = 0.0;
            else
                [temp_element(k,5) temp_element(k,6)] = comp2rake(ELEMENT(k,5),ELEMENT(k,6));
            end
        end
    end
end
sp = '   ';
for k=1:NUM
    fprintf(fid,'%3i %10.4f %10.4f %10.4f %10.4f ',ID(k),ELEMENT(k,1),ELEMENT(k,2),...
        ELEMENT(k,3),ELEMENT(k,4));
    if KODE(k) == 100
    fprintf(fid,'%3i %10.4f %10.4f %10.4f %10.4f %10.4f %s',KODE(k),...
        temp_element(k,5),temp_element(k,6),ELEMENT(k,7),ELEMENT(k,8),ELEMENT(k,9),sp);
    else
    fprintf(fid,'%3i %10i %10i %10.4f %10.4f %10.4f %s',KODE(k),...
        int64(temp_element(k,5)),int64(temp_element(k,6)),ELEMENT(k,7),ELEMENT(k,8),ELEMENT(k,9),sp);
    end
    try
    if iscell(FCOMMENT(k).ref) == 1
%     fprintf(fid,mat2str(cell2mat(FCOMMENT(k).ref))); fprintf(fid,' \n');
    fprintf(fid,cell2mat(FCOMMENT(k).ref)); fprintf(fid,' \n');
    elseif iscell(FCOMMENT(k).ref) == 0
%     fprintf(fid,mat2str(FCOMMENT(k).ref)); fprintf(fid,' \n');
    fprintf(fid,FCOMMENT(k).ref); fprintf(fid,' \n');
    end
    catch
        fprintf(fid,' \n');
    end
end
fprintf(fid,'  \n');
fprintf(fid,'    Grid Parameters\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',GRID(1,1));
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',GRID(2,1));
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',GRID(3,1));
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',GRID(4,1));
fprintf(fid,'  5  ------------------------  x-increment = %16.7f\n',GRID(5,1));
fprintf(fid,'  6  ------------------------  y-increment = %16.7f\n',GRID(6,1));
fprintf(fid,'     Size Parameters\n');
fprintf(fid,'  1  --------------------------  Plot size = %16.7f\n',SIZE(1,1));
fprintf(fid,'  2  --------------  Shade/Color increment = %16.7f\n',SIZE(2,1));
fprintf(fid,'  3  ------  Exaggeration for disp.& dist. = %16.7f\n',SIZE(3,1));
fprintf(fid,'  \n');
if ~isempty(SEC_XS) && ~isempty(SEC_YS) && ~isempty(SEC_XF) && ~isempty(SEC_YF)...
        && ~isempty(SEC_INCRE) && ~isempty(SEC_DEPTH) && ~isempty(SEC_DEPTHINC)
fprintf(fid,'     Cross section default\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',SEC_XS);
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',SEC_YS);
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',SEC_XF);
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',SEC_YF);
fprintf(fid,'  5  ------------------  Distant-increment = %16.7f\n',SEC_INCRE);
fprintf(fid,'  6  ----------------------------  Z-depth = %16.7f\n',(-1.0)*SEC_DEPTH);
fprintf(fid,'  7  ------------------------  Z-increment = %16.7f\n',SEC_DEPTHINC);
elseif isempty(SECTION) ~= 1
fprintf(fid,'     Cross section default\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',SECTION(1,1));
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',SECTION(2,1));
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',SECTION(3,1));
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',SECTION(4,1));
fprintf(fid,'  5  ------------------  Distant-increment = %16.7f\n',SECTION(5,1));
fprintf(fid,'  6  ----------------------------  Z-depth = %16.7f\n',SECTION(6,1));
fprintf(fid,'  7  ------------------------  Z-increment = %16.7f\n',SECTION(7,1));
end
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
fprintf(fid,'     Map info\n');
fprintf(fid,'  1  ---------------------------- min. lon = %16.7f\n',MIN_LON);
fprintf(fid,'  2  ---------------------------- max. lon = %16.7f\n',MAX_LON);
fprintf(fid,'  3  ---------------------------- zero lon = %16.7f\n',ZERO_LON);
fprintf(fid,'  4  ---------------------------- min. lat = %16.7f\n',MIN_LAT);
fprintf(fid,'  5  ---------------------------- max. lat = %16.7f\n',MAX_LAT);
fprintf(fid,'  6  ---------------------------- zero lat = %16.7f\n',ZERO_LAT);
        end
    end
end
fclose(fid);
disp(' ');
disp(['File name ' pathname filename ' is saved.']);


