
%----------------------------------------------------
% dc3de_calc (internal function)
%----------------------------------------------------
function [dc3de] = dc3de_calc(xx,yy)
global H_MAIN
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global ICOORD
global EQ_DATA
global NUM ELEMENT YOUNG POIS FRIC
global ANATOLIA
global N_CELL
global OUTFLAG PREF_DIR HOME_DIR
global INODAL H_NODAL NODAL_ACT NODAL_STRESS
[m,n] = size(xx);
N_CELL = m;
% initialization
zz = zeros(m,1,'double'); % calculate at surface
dc3de = zeros(m,14,'double');
dc3de0 = zeros(m,14,'double');
UX  = zeros(m,1,'double');
UY  = zeros(m,1,'double');
UZ  = zeros(m,1,'double');
UXX = zeros(m,1,'double');
UYX = zeros(m,1,'double');
UZX = zeros(m,1,'double');
UXY = zeros(m,1,'double');
UYY = zeros(m,1,'double');
UZY = zeros(m,1,'double');
UXZ = zeros(m,1,'double');
UZZ = zeros(m,1,'double');
IRET = zeros(m,1);
for k = 1:NUM
depth = (ELEMENT(k,8)+ELEMENT(k,9))/2.0;  % depth should be positive
[c1,c2,c3,c4] = coord_conversion(xx,yy,ELEMENT(k,1),ELEMENT(k,2),...
                ELEMENT(k,3),ELEMENT(k,4),ELEMENT(k,8),ELEMENT(k,9),ELEMENT(k,7));
alpha  =  1.0/(2.0*(1.0-POIS));
z  = double(zz) * (-1.0);
aa = zeros(m,1,'double') + double(alpha);
zc = zeros(m,1,'double') + double(z);
dp = zeros(m,1,'double') + double(depth);
e7 = zeros(m,1,'double') + double(ELEMENT(k,7));
e5 = zeros(m,1,'double') - double(ELEMENT(k,5));    % left-lat positive in Okada's code
e6 = zeros(m,1,'double') + double(ELEMENT(k,6));
zr = zeros(m,1,'double');
x  = zeros(m,1,'double') + double(c1);
y  = zeros(m,1,'double') + double(c2);
al = zeros(m,1,'double') + double(c3);
aw = zeros(m,1,'double') + double(c4);
a = [aa x y zc dp e7 al al aw aw e5 e6 zr];
[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
     UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
     a(:,4),a(:,5),a(:,6),...
     a(:,7),a(:,8),a(:,9),...
     a(:,10),a(:,11),a(:,12),a(:,13));
% cell to matrices
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
%-- Displacement Conversion from Okada's field to Given field -------------
%    ELEMENT = double(ELEMENT);
    sw = sqrt((ELEMENT(k,4)-ELEMENT(k,2))^2+(ELEMENT(k,3)-ELEMENT(k,1))^2);
    sina = (ELEMENT(k,4)-ELEMENT(k,2))/double(sw);
    cosa = (ELEMENT(k,3)-ELEMENT(k,1))/double(sw);
    UXG = UX*cosa-UY*sina;
    UYG = UX*sina+UY*cosa;
    UZG = UZ;
% C-- Strain to Stress for the normal component -----------------------------
% strain to stress
    sk = YOUNG/(1.0+POIS);
    gk = POIS/(1.0-2.0*POIS);
    vol = UXX + UYY + UZZ;
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (YOUNG/(2.0*(1.0+POIS))) * (UXY + UYX) * 0.001;
    sxz = (YOUNG/(2.0*(1.0+POIS))) * (UXZ + UZX) * 0.001;
    syz = (YOUNG/(2.0*(1.0+POIS))) * (UYZ + UZY) * 0.001;
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
        dc3de = horzcat(xx,yy,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    else
        dc3de0 = horzcat(zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),...
                UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    end
        dc3de = dc3de + dc3de0;
%          UZG
end