function element_condition(e90,poisson,young,friction,id)
global N_CELL
global DC3DE
global COULOMB_RIGHT COULOMB_UP COULOMB_PREF COULOMB_RAKE EC_NORMAL
global EC_RAKE
global S_ELEMENT
global KODE
global FUNC_SWITCH
global OUTFLAG PREF_DIR HOME_DIR
global IND_RAKE
global IMAXSHEAR
global FCOMMENT

% INPUT:
% Each fault element (supposed to be directly taken over from ELEMENT)
%       e90(:,1) xstart (km)
%       e90(:,2) ystart (km)
%       e90(:,3) xfinish (km)
%       e90(:,4) yfinish (km)
%       e90(:,5) right-lat. slip (m)
%       e90(:,6) reverse slip (m)
%       e90(:,7) dip (degree)
%       e90(:,8) fault top depth (km)
%       e90(:,9) fault bottom depth (km)
%       poisson: Poisson ratio
%       young: Young modulus
%       friction: friction of coefficient
%       id: ID of the element

% function [s_element] = split_element(id,e9)
e100 = [e90 double(KODE)];
[m,n] = size(e100);
e9 = zeros(m,10,'double');
nid = ones(m,1);
[e9 nid] = split_element(id,e100);

[m,n] = size(e9);
temp = N_CELL;  % to keep the number for origilan non-splitted elements
N_CELL = m;
% to keep the numbers for other usages
S_ELEMENT = zeros(m,10);
S_ELEMENT = e9;
%

DC3DE = zeros(m,14,'double');
DC3DE0 = zeros(m,14,'double');
UX = zeros(m,1,'double');
UY = zeros(m,1,'double');
UZ = zeros(m,1,'double');
UXX = zeros(m,1,'double');
UYX = zeros(m,1,'double');
UZX = zeros(m,1,'double');
UXY = zeros(m,1,'double');
UYY = zeros(m,1,'double');
UZY = zeros(m,1,'double');
UXZ = zeros(m,1,'double');
UZZ = zeros(m,1,'double');
IRET = zeros(m,1);

s0 = zeros(6,m,'double');
s1 = zeros(6,m,'double');

e7 = zeros(m,7);
e_comp = zeros(m,3);
f_length = zeros(m,1);
a = zeros(m,1); b = zeros(m,1);
ind1 = zeros(m,1); ind2 = zeros(m,1); ind3 = zeros(m,1);
ind4 = zeros(m,1); ind5 = zeros(m,1); ind6 = zeros(m,1);
ind7 = zeros(m,1); ind8 = zeros(m,1);

%--------------(strike, dip for each element)
a = rad2deg(atan((e9(:,4)-e9(:,2))./(e9(:,3)-e9(:,1))));
% fault length
f_length = sqrt((e9(:,3)-e9(:,1)).^2+(e9(:,4)-e9(:,1)).^2);
ind1 = e9(:,1) > e9(:,3);
ind2 = e9(:,1) <= e9(:,3);
% strike
e_comp(:,1) = (270.0 - a).*ind1 + (90.0 - a).*ind2;
% dip
e_comp(:,2) = e9(:,7);
% rake
ind3 = e9(:,5) ~= 0.0;
ind4 = e9(:,5) == 0.0;
b = rad2deg(atan(e9(:,6)./e9(:,5))).*ind3 + rad2deg(atan(e9(:,6)./0.000001)).*ind4;
ind5 = e9(:,5) >= 0.0;
ind6 = e9(:,5) < 0.0;
ind7 = e9(:,6) >= 0.0;
ind8 = e9(:,6) < 0.0;
e_comp(:,3) = (180.0-b).*ind5.*ind7 + (-180.0-b).*ind5.*ind8 ...
    + (-b).*ind6;

%--------------

% Each fault element
%       ELEMENT(:,1) xstart (km)
%       ELEMENT(:,2) ystart (km)
%       ELEMENT(:,3) xfinish (km)
%       ELEMENT(:,4) yfinish (km)
%       ELEMENT(:,5) right-lat. slip (m)
%       ELEMENT(:,6) reverse slip (m)
%       ELEMENT(:,7) dip (degree)
%       ELEMENT(:,8) fault top depth (km)
%       ELEMENT(:,9) fault bottom depth (km)

e7 = [e9(:,1) e9(:,2) e9(:,3) e9(:,4),e9(:,7) e9(:,8) e9(:,9)];
% for k = 1:m
% e7(k,:) = [e9(k,1) e9(k,2) e9(k,3) e9(k,4),e9(k,7) e9(k,8) e9(k,9)];
% end

% fc = zeros(m,8);
% e_center = zeros(m,3);     % 3 columns (x,y,z)
% middle = zeros(m,1);
% middle = (e7(:,6)+e7(:,7))./2.0;
% fc = fault_corners_vec(e7(:,1),e7(:,2),e7(:,3),e7(:,4),e7(:,5),e7(:,6),...
%         middle);
% %    fc = [xs ys xf yf xf_bottom yf_bottom xs_bottom ys_bottom];
% e_center(:,1) = (fc(:,7) + fc(:,5))./2.0;
% e_center(:,2) = (fc(:,8) + fc(:,6))./2.0;
% e_center(:,3) = middle;
% 

for k = 1:m
    middle = (e7(k,6)+e7(k,7))/2.0;
    fc = fault_corners(e7(k,1),e7(k,2),e7(k,3),e7(k,4),e7(k,5),e7(k,6),...
        middle);
    e_center(k,1) = (fc(4,1) + fc(3,1)) / 2.0;
    e_center(k,2) = (fc(4,2) + fc(3,2)) / 2.0;
%fc = [xs,ys; xf,yf; xf_bottom,yf_bottom; xs_bottom,ys_bottom];
    e_center(k,3) = middle;    
end

if FUNC_SWITCH ~= 1
% ========================================== k loop (start)
%        this loop is for making 'DC3DE'
%  loop for receiver points (internal matrix corresponds to a set of
%  sources)
for k = 1:m
    if e9(k,5)==0.0 && e9(k,6)==0.0
        continue
    end
        depth = (e9(k,8)+e9(k,9))/2.0;  % depth should be positive
[c1,c2,c3,c4] = coord_conversion(e_center(:,1),e_center(:,2),e9(k,1),e9(k,2),...
                e9(k,3),e9(k,4),e9(k,8),e9(k,9),e9(k,7));

alpha  =  1.0/(2.0*(1.0-poisson));
z  = e_center(:,3) * (-1.0);
aa = zeros(m,1,'double') + double(alpha);
zz = zeros(m,1,'double') + double(z);
dp = zeros(m,1,'double') + double(depth);
e7 = zeros(m,1,'double') + double(e9(k,7));
e5 = zeros(m,1,'double') - double(e9(k,5));    % left-lat positive in Okada's code
e6 = zeros(m,1,'double') + double(e9(k,6));
zr = zeros(m,1,'double');
        if int16(e9(k,10)) == 200
            e5 = zeros(m,1,'double') + double(e9(k,5));
            e6 = zeros(m,1,'double');
            zr = zeros(m,1,'double') + double(e9(k,6));    
        elseif int16(e9(k,10)) == 300
            e5 = zeros(m,1,'double');
            e6 = zeros(m,1,'double') + double(e9(k,6));
            zr = zeros(m,1,'double') + double(e9(k,5));   
        end
        x = zeros(m,1,'double') + double(c1);
        y = zeros(m,1,'double') + double(c2);
        al = zeros(m,1,'double') + double(c3);
        aw = zeros(m,1,'double') + double(c4);
        if int16(e9(k,10)) == 400
            aw = zeros(m,1,'double') - double(e9(k,5));
            e5 = zeros(m,1,'double') + double(e9(k,6));
            e6 = zeros(m,1,'double');
            zr = zeros(m,1,'double');    
        elseif int16(e9(k,10)) == 500
            aw = zeros(m,1,'double');
            e5 = zeros(m,1,'double');
            e6 = zeros(m,1,'double') + double(e9(k,5));
            zr = zeros(m,1,'double') + double(e9(k,6));   
        end
a = [aa x y zz dp e7 al al aw aw e5 e6 zr];
b = zeros(m,20,'double');

adj = 0.0001; % to avoid singular point for Kode 400 and Kode 500 (point source)

if int16(e9(k,10)) == 100 | int16(e9(k,10)) == 200 | int16(e9(k,10)) == 300
    [UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
     UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
     a(:,4),a(:,5),a(:,6),...
     a(:,7),a(:,8),a(:,9),...
     a(:,10),a(:,11),a(:,12),a(:,13));
elseif int16(e9(k,10)) == 400 | int16(e9(k,10)) == 500
    [UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D0(a(:,1),a(:,2)+adj,a(:,3),...
    a(:,4),a(:,5),a(:,6),a(:,10),a(:,11),a(:,12),a(:,13));
end

% cell to matrices
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
%-- Displacement Conversion from Okada's field to Given field -------------
%    ELEMENT = double(ELEMENT);
    sw = sqrt((e9(k,4)-e9(k,2))^2+(e9(k,3)-e9(k,1))^2);
    sina = (e9(k,4)-e9(k,2))/double(sw);
    cosa = (e9(k,3)-e9(k,1))/double(sw);
    UXG = UX*cosa-UY*sina;
    UYG = UX*sina+UY*cosa;
    UZG = UZ;

% C-- Strain to Stress for the normal component -----------------------------
% strain to stress
    sk = young/(1.0+poisson);
    gk = poisson/(1.0-2.0*poisson);
    vol = UXX + UYY + UZZ;
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (young/(2.0*(1.0+poisson))) * (UXY + UYX) * 0.001;
    sxz = (young/(2.0*(1.0+poisson))) * (UXZ + UZX) * 0.001;
    syz = (young/(2.0*(1.0+poisson))) * (UYZ + UZY) * 0.001;
    ssxx = reshape(sxx,1,m);
    ssyy = reshape(syy,1,m);
    sszz = reshape(szz,1,m);
    ssxy = reshape(sxy,1,m);
    ssxz = reshape(sxz,1,m);
    ssyz = reshape(syz,1,m);
    
    s0 = [ssxx; ssyy; sszz; ssyz; ssxz; ssxy];

%-- Strain Conversion from Okada's field to Given field -------------
    s1 = tensor_trans(sina,cosa,s0,m);

    SXX = reshape(s1(1,:),m,1);
    SYY = reshape(s1(2,:),m,1);
    SZZ = reshape(s1(3,:),m,1);
    SYZ = reshape(s1(4,:),m,1);
    SXZ = reshape(s1(5,:),m,1);
    SXY = reshape(s1(6,:),m,1); 
    if k == 1
        DC3DE0 = horzcat(e_center(:,1:2),X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    else
        DC3DE0 = horzcat(zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),...
                UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    end
        DC3DE = DC3DE + DC3DE0;
end

% ========================================== k loop (end)

%--- Calc coulomb --------
ss = zeros(6,m);
s9 = reshape(DC3DE(:,9),1,m);
s10 = reshape(DC3DE(:,10),1,m);
s11 = reshape(DC3DE(:,11),1,m);
s12 = reshape(DC3DE(:,12),1,m);
s13 = reshape(DC3DE(:,13),1,m);
s14 = reshape(DC3DE(:,14),1,m);
ss = [s9; s10; s11; s12; s13; s14];

shear_right = zeros(m,1,'double');
shear_up    = zeros(m,1,'double');
shear_max   = zeros(m,1,'double');
EC_NORMAL   = zeros(m,1,'double');
COULOMB_RIGHT = zeros(m,1,'double');
COULOMB_UP    = zeros(m,1,'double');
COULOMB_PREF  = zeros(m,1,'double');
spec_cl_shear = zeros(m,1,'double');
rake_cl_shear = zeros(m,1,'double');
COULOMB_RAKE  = zeros(m,1,'double');
coulomb_max    = ones(m,1,'double') * (-10000);
coulomb_max_dir = zeros(m,1,'double');
spec_coul = zeros(m,1,'double');
each_rake = zeros(m,1,'double');    % rake for each fault
rake_coul = zeros(m,1,'double');    % rake for each fault
dummy2 = zeros(m,1,'double');
dummy3 = zeros(m,1,'double');
c1 = zeros(m,1,'double') + e_comp(:,1);
c2 = zeros(m,1,'double') + e_comp(:,2);
% c3 = zeros(m,1) + e_comp(m,3);
c4 = zeros(m,1,'double') + friction;

% right-lat. calc.
c3 = zeros(m,1,'double') + 180.0;
[shear_right,EC_NORMAL,COULOMB_RIGHT] = calc_coulomb(c1,c2,c3,c4,ss);

% reverse slip. calc.
c3 = zeros(m,1,'double') + 90.0;
[shear_up,EC_NORMAL,COULOMB_UP] = calc_coulomb(c1,c2,c3,c4,ss);

% preferred slip. calc.
if isempty(EC_RAKE) == 1
    EC_RAKE = 140.0;    % dummy in case
end
ec_calc_rake = zeros(m,1,'double') + EC_RAKE;
c3 = zeros(m,1,'double') + EC_RAKE;
[spec_cl_shear,EC_NORMAL,COULOMB_PREF] = calc_coulomb(c1,c2,c3,c4,ss);

% rake assigned for each fault. calc.
% [each_rake dummy1] = comp2rake(e9(:,5),e9(:,6));
% c3 = each_rake;
if isempty(IND_RAKE)
    c3 = zeros(m,1,'double') + EC_RAKE;
    each_rake = zeros(m,1,'double') + EC_RAKE;
    disp('Warning: No individual rake is assgined in this file.');
else
%    c3 = IND_RAKE;
    each_rake = zeros(m,1,'double') + IND_RAKE;
end
[rake_cl_shear,EC_NORMAL,COULOMB_RAKE] = calc_coulomb(c1,c2,each_rake,c4,ss);

%====================================
% IMAXSHEAR = 1: Search
% IMAXSHEAR = 2 or others: skip the max shear direction to speed up

if IMAXSHEAR == 1
% shear max direction (grid search)
% deg_inc = 0.1;
deg_inc = 1.0;
nsearch = round(360.0 / deg_inc);
    for k = 1:nsearch
        crake = -180.0 + k * deg_inc;
        c3 = zeros(m,1,'double') + crake;
        [dummy1,dummy2,dummy3] = calc_coulomb(c1,c2,c3,c4,ss);
        for l = 1:m
            if dummy3(l) > coulomb_max(l)
                coulomb_max(l) = dummy3(l);
                coulomb_max_dir(l) = crake;
            end
        end
    end
else
    for l = 1:m
    coulomb_max(l) = NaN;
    coulomb_max_dir(l) = NaN;
    end
end
    
b = [double(nid(:,1)) DC3DE(:,1) DC3DE(:,2) -DC3DE(:,5) f_length(:) e_comp(:,1) e_comp(:,2)...
    e9(:,5) e9(:,6) shear_right(:) shear_up(:) EC_NORMAL(:) COULOMB_RIGHT(:) COULOMB_UP(:)...
    coulomb_max_dir(:) coulomb_max(:) ec_calc_rake(:) COULOMB_PREF(:) each_rake(:) COULOMB_RAKE(:)];

    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
header1 = 'Fault,X-center,Y-center,Z-center,length,strike,dip,lat-slip,dip-slip,sig-right,sig_reverse,normal,coul-right,coul-reverse,opt-rake,opt-coul,spec-rake,spec-coul,element-rake,el-rake-coul\n';
header2 = '#,(km),(km),(km),(km),(km),(deg),(m),(m),(bar),(bar),(bar),(bar),(bar),(deg),(bar),(deg),(bar),(deg),(bar)\n';
%footer1 = ' \n'; %removed by ZKM on 29.04.16 so that the output files can
%be used with my patch script
%footer2 = 'opt-rake and opt-coul are found using grid search method of 0.1 deg increment.\n';
fid = fopen('Element_conditions.csv','wt');
sp = '   ';
cm = ',';
fprintf(fid,header1);
fprintf(fid,header2);
for m=1:size(b,1)
    fprintf(fid,'%5i %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.3f %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.6f %c %15.3f %c %15.6f %c %15.3f %c %15.6f %c %15.3f %c %15.6f %s',...
        b(m,1),cm,b(m,2),cm,b(m,3),cm,b(m,4),cm,b(m,5),cm,b(m,6),cm,b(m,7),...
        cm,b(m,8),cm,b(m,9),cm,b(m,10),cm,b(m,11),cm,b(m,12),cm,...
        b(m,13),cm,b(m,14),cm,b(m,15),cm,b(m,16),cm,b(m,17),cm,...
        b(m,18),cm,b(m,19),cm,b(m,20),cm);
    if iscell(FCOMMENT(m).ref) == 1
        fprintf(fid,cell2mat(FCOMMENT(m).ref)); fprintf(fid,' \n');
    elseif iscell(FCOMMENT(m).ref) == 0
        fprintf(fid,FCOMMENT(m).ref); fprintf(fid,' \n');
    end
end
%fprintf(fid,footer1); %removed by ZKM on 29.04.16 so that the output files can
%be used with my patch script
%fprintf(fid,footer2);
fclose(fid);

%          dlmwrite('Element_conditions.csv',header1,'delimiter','');  
%          dlmwrite('Element_conditions.csv',header2,'delimiter','','-append');  
%          dlmwrite('Element_conditions.csv',b,'delimiter',',','precision','%15.6f','-append');  
%          dlmwrite('Element_conditions.csv',footer1,'delimiter','','-append');  
%          dlmwrite('Element_conditions.csv',footer2,'delimiter','','-append');
%          disp(['Element_conditions.csv is saved in ' pwd]);
	cd (HOME_DIR);
coulomb_in_3D;
end
N_CELL = temp;

