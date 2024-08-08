function [x,y,z,el,kode,pois,young,cdepth,fric,rstress] = open_input_file_cui(filename)
% varargout = open_input_file_cui(filename)
%   For reading Coulomb input file
% input_open reads the Coulomb formatted input file into MATLAB
%

num_buffer = 100; % to adjust NUM in case #fixed & #fault lines are different

fid = fopen(filename,'r');              % for ascii file
     
% default fault # indication
Inum = repmat(int16(1),1,1);

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
num = int32([d{1}]);    % which means the maximum number of elements are 65,535.
num = num + num_buffer;

% Poisson's ratio & calculation depth
e = textscan(fid,'%*s %15.3f32 %*s %*s %*s %15.3f32',1);
pois = double([e{1}]);
cdepth = double([e{2}]);

% Young's modulus
f = textscan(fid,'%*s %n %*s %*s',1);
young = double([f{1}]);

% Passing symmetry parameters (no longer used for Coulomb)
g = textscan(fid,'%*s %*s %*s %*s', 1);

% friction coefficient
h = textscan(fid,'%*s %15.3f32', 1);
fric = double([h{1}]);

% regional stress field
s = textscan(fid,'%*s %15.6f32 %*s %15.6f32 %*s %15.6f32 %*s %15.6f32',3);
rstress = [s{:}];

% To detect slip component type
% Normally "right-lat" and "reverse"
% But if the label contains "rake", it changes to "rake" and "net slip"
% Units are degree and meter.
dum0 = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);


% dummy for passing through "xxxxxxxxxx xxxxxxxxxx" line
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',1);


% fault elements
% flt = textscan(fid,...
%     '%3u16 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %3u16 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %10.4f32 %s %s %s %s %s %s %s %s %s %s', num);
flt = textscan(fid,...
    '%3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %s %s %s %s %s %s %s %s %s %s', num);

id = uint16([flt{1}]);
if length(id) ~= num - num_buffer
	disp('************************************************************************');
    disp('**  Please change #fixed in the 3rd row in the input file afterward.  **');
    disp('************************************************************************');
end
% if length(id) < num - num_buffer
    num = length(id);
% end

% kode = int16([flt{6}])
kode = uint16([flt{6}]);
% (el: xs, ys, xf, yf, latslip, dipslip, dip, top, bottom)
el = [flt{2:5} flt{7:11}];
el = double(el);
% for comments after element param lineup
a = [flt{12:21}];
for k = 1:num
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
grid = double([gr{:}]);

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% size
sz = textscan(fid,'%*45c %16.7f32',3);
size = [sz{:}];

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% cross section
cs = textscan(fid,'%*45c %16.7f32',7);
section = [cs{:}];
if isempty(section) == 1
   disp('   No info for a cross section line is included in the input file.');
end

%       passing through
dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);

% map info parameters
mi = textscan(fid,'%*45c %16.7f32',6);
mapinfo = double([mi{:}]);


% check if all parameters are properly read or not.
if isempty(num) == 1
	errordlg('Number of faults is not read. Make sure the input file.');
	return;
end
if isempty(pois) == 1
    errordlg('Poisson ratio is not read. Make sure the input file.');
    return;
end
if isempty(young) == 1
    errordlg('Young modulus is not read. Make sure the input file.');
    return;
end
if isempty(fric) == 1
    errordlg('Coefficient of friction is not read. Make sure the input file.');
    return;
end
if isempty(rstress) == 1
    errordlg('Regional stress values are not read. Make sure the input file.');
    return;
end
if isempty(grid) == 1
    errordlg('Grid info for study area is not read properly. Make sure the input file.');
    return;
end
fclose (fid);

x = grid(1):grid(5):grid(3);
y = grid(2):grid(6):grid(4);
z = cdepth;

% xvec  = grid(1):grid(5):grid(3);
% yvec  = grid(2):grid(6):grid(4);
% [x,y] = meshgrid(xvec,yvec);
% z     = ones(length(yvec),length(xvec)) * cdepth;

% clear a b1 b2 c1 c2 d e f g h s dum flt gr sz cd mi;

% if isempty(mapinfo) ~= 1
% MIN_LON = mapinfo(1,1); MAX_LON = mapinfo(2,1); ZERO_LON = mapinfo(3,1);
% MIN_LAT = mapinfo(4,1); MAX_LAT = mapinfo(5,1); ZERO_LAT = mapinfo(6,1);
% else
%     disp('   No lat. & lon. information is included in the input file.');
%     lon = [];
%     lat = [];
% end

return

% to calculate and save numbers for basic info
calc_element;
if ~isempty(section)
   a = xy2lonlat([section(1) section(2)]);
   SEC_XS = a(1,1);          
   SEC_XF = a(1,2);
   a = xy2lonlat([section(3) section(4)]);
   SEC_YS = a(1,1); 
   SEC_YF = a(1,2);
   SEC_INCRE = section(5);
   SEC_DEPTH = section(6);
   SEC_DEPTHINC = section(7);
   SEC_DIP      = 90.0;
   SEC_DOWNDIP_INC = section(7);
end


%----- calc Moment -------------------------
check = max(kode);
if check == 100     % moment can be calcualted only if kode = 100
    amo = 0.0;
    for k = 1:num
        shearmod = young / (2.0 * (1.0 + pois));
        flength = sqrt((el(k,1)-el(k,3))^2+(el(k,2)-el(k,4))^2);
        hfault = el(k,9) - el(k,8);
        wfault = hfault / sin(deg2rad(el(k,7)));
        slip = sqrt(el(k,5)^2.0 + el(k,6)^2.0);
        smo = shearmod * flength * wfault * slip * 1.0e+18;
        amo = amo + smo;
    end
    mw = (2/3) * log10(amo) - 10.7;
    disp(['   Total seismic moment = ' num2str(amo,'%6.2e') ' dyne cm (Mw = ', num2str(mw,'%4.2f') ')']);
%    disp(amo);
end

disp('---> To calculate deformation, select one of the submenus from ''Functions''.');
disp(' ');


