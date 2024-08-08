function [shear,normal,coulomb] = calc_coulomb(strike_m,dip_m,rake_m,friction_m...
                       ,ss)
% For calculating shear, normal and Coulomb stresses in a given 
% fault strike, dip, and rake
%
% INPUT: strike_m,dip_m,rake_m,friction_m,SXX,SYY,SZZ,SXY,SXZ,SYZ
% 
% OUTPUT: shear,normal,coulomb
%

% "_m" means matrix. So, for "if" condition, we can only use scalar.
% So here we convert it into scalar since there are the all same numbers in
% a matrix.

n = size(strike_m,1);

strike = zeros(n,1);
dip    = zeros(n,1);
rake   = zeros(n,1);
friction = friction_m(1,1);

% adjustment for our coordinate system from Aki & Richards convension
c1 = strike_m >= 180.0; c2 = strike_m < 180.0;

strike = (strike_m - 180.0) .* c1 + strike_m .* c2;
dip    = (-1.0) * dip_m .* c1 + dip_m .* c2;
rake_m   = rake_m - 90.0;

c1 = rake_m <= -180.0; c2 = rake_m > -180.0;
rake = (360.0 + rake_m) .* c1 + rake_m .* c2;

% CAUTION.....................................  
strike = deg2rad(strike);
dip = deg2rad(dip);
rake = deg2rad(rake);

% % for rake rotation (this was fixed by Zhang ZQ)
for i=1:n
    rsc = -rake(i,1); % flipped
    rr = makehgtform('xrotate',rsc);
    mtran(1:3,1:3,i) = rr(1:3,1:3);
end

% Now corrected scalar value is to matrix (n x 1) as "...m"
% strikem = zeros(n,1) + strike;
% dipm = zeros(n,1) + dip;
rakem = zeros(n,1) + rake;

sn  = zeros(6,length(strike));
sn9 = zeros(3,3,length(strike));

ver = pi/2.0;

c1 = strike>=0.0;  c2 = strike<0.0; c3 = strike<=ver; c4 = strike>ver;
c24 = c2 + c4; cc24 = c24 > 0;
d1 = dip>=0.0; d2 = dip<0.0;
xbeta = (-1.0)*strike .* d1 + (pi - strike) .* d2;
ybeta = (pi-strike).*d1 + (-1.0)*strike.*d2;
zbeta = (ver-strike).*d1 + ((-1.0)*ver-strike).*d2.*c1.*c3 + (pi+ver-strike).*d2.*cc24;
xdel = ver - abs(dip);
ydel = abs(dip);
zdel = 0.0;

% scalar to matrix (n x 1)
xbetam = zeros(n,1) + xbeta;
ybetam = zeros(n,1) + ybeta;
zbetam = zeros(n,1) + zbeta;
xdelm  = zeros(n,1) + xdel;
ydelm  = zeros(n,1) + ydel;
zdelm  = zeros(n,1) + zdel;

xl = cos(xdelm) .* cos(xbetam);
xm = cos(xdelm) .* sin(xbetam);
xn = sin(xdelm);
yl = cos(ydelm) .* cos(ybetam);
ym = cos(ydelm) .* sin(ybetam);
yn = sin(ydelm);
zl = cos(zdelm) .* cos(zbetam);
zm = cos(zdelm) .* sin(zbetam);
zn = sin(zdelm);

t(1,1,:) = xl .* xl;
t(1,2,:) = xm .* xm;
t(1,3,:) = xn .* xn;
t(1,4,:) = 2.0 * xm .* xn;
t(1,5,:) = 2.0 * xn .* xl;
t(1,6,:) = 2.0 * xl .* xm;
t(2,1,:) = yl .* yl;
t(2,2,:) = ym .* ym;
t(2,3,:) = yn .* yn;
t(2,4,:) = 2.0 * ym .* yn;
t(2,5,:) = 2.0 * yn .* yl;
t(2,6,:) = 2.0 * yl .* ym;
t(3,1,:) = zl .* zl;
t(3,2,:) = zm .* zm;
t(3,3,:) = zn .* zn;
t(3,4,:) = 2.0 * zm .* zn;
t(3,5,:) = 2.0 * zn .* zl;
t(3,6,:) = 2.0 * zl .* zm;
t(4,1,:) = yl .* zl;
t(4,2,:) = ym .* zm;
t(4,3,:) = yn .* zn;
t(4,4,:) = ym .* zn + zm .* yn;
t(4,5,:) = yn .* zl + zn .* yl;
t(4,6,:) = yl .* zm + zl .* ym;
t(5,1,:) = zl .* xl;
t(5,2,:) = zm .* xm;
t(5,3,:) = zn .* xn;
t(5,4,:) = xm .* zn + zm .* xn;
t(5,5,:) = xn .* zl + zn .* xl;
t(5,6,:) = xl .* zm + zl .* xm;
t(6,1,:) = xl .* yl;
t(6,2,:) = xm .* ym;
t(6,3,:) = xn .* yn;
t(6,4,:) = xm .* yn + ym .* xn;
t(6,5,:) = xn .* yl + yn .* xl;
t(6,6,:) = xl .* ym + yl .* xm;

for k = 1:n
    sn(:,k) = t(:,:,k) * ss(:,k);
    sn9(1,1,k) = sn(1,k);
    sn9(1,2,k) = sn(6,k);
    sn9(1,3,k) = sn(5,k);
    sn9(2,1,k) = sn(6,k);
    sn9(2,2,k) = sn(2,k);
    sn9(2,3,k) = sn(4,k);
    sn9(3,1,k) = sn(5,k);
    sn9(3,2,k) = sn(4,k);
    sn9(3,3,k) = sn(3,k);
    sn9(:,:,k) = sn9(:,:,k) * mtran(:,:,k);
end

shear   = reshape(sn9(1,2,:),n,1);
normal  = reshape(sn9(1,1,:),n,1);
coulomb = shear + friction .* normal;




