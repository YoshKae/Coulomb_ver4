function [sn] = tensor_trans(sinb,cosb,so,nn)
% Tensor transformation
%
%  INPUT:  sinb,so,sn,flag
%            so(1x6) matix: original stress tensor
%               --> sxx,syy,szz,syz,sxz,sxy
%  OUTPUT:   sn(1x6) matix: newly calculated stress tensor with
%                         horizontal rotation (not plunge change)
% 

t = zeros(6,6);
sn = zeros(6,nn);

ver = pi/2.0;

bt = asin(sinb); % contains ys & yf information (applicable for strike = 0-180 deg)
%     sina = (ELEMENT(ii,4)-ELEMENT(ii,2))/sw;
%     cosa = (ELEMENT(ii,3)-ELEMENT(ii,1))/sw;
if cosb > 0.0
% rotation of axes (positive:clock wise, negative, anti-cw)
    xbeta = -bt;
    xdel = 0.0;
    ybeta = -bt + ver;
    ydel = 0.0;
    zbeta = -bt - ver;
    zdel = ver;
else
    xbeta = bt - pi;
    xdel = 0.0;
    ybeta = bt - ver;
    ydel = 0.0;
    zbeta = bt - ver;
    zdel = ver;    
end

xl = cos(xdel) * cos(xbeta);
xm = cos(xdel) * sin(xbeta);
xn = sin(xdel);

yl = cos(ydel) * cos(ybeta);
ym = cos(ydel) * sin(ybeta);
yn = sin(ydel);

zl = cos(zdel) * cos(zbeta);
zm = cos(zdel) * sin(zbeta);
zn = sin(zdel);

t(1,1) = xl * xl;
t(1,2) = xm * xm;
t(1,3) = xn * xn;
t(1,4) = 2.0 * xm * xn;
t(1,5) = 2.0 * xn * xl;
t(1,6) = 2.0 * xl * xm;
t(2,1) = yl * yl;
t(2,2) = ym * ym;
t(2,3) = yn * yn;
t(2,4) = 2.0 * ym * yn;
t(2,5) = 2.0 * yn * yl;
t(2,6) = 2.0 * yl * ym;
t(3,1) = zl * zl;
t(3,2) = zm * zm;
t(3,3) = zn * zn;
t(3,4) = 2.0 * zm * zn;
t(3,5) = 2.0 * zn * zl;
t(3,6) = 2.0 * zl * zm;
t(4,1) = yl * zl;
t(4,2) = ym * zm;
t(4,3) = yn * zn;
t(4,4) = ym * zn + zm * yn;
t(4,5) = yn * zl + zn * yl;
t(4,6) = yl * zm + zl * ym;
t(5,1) = zl * xl;
t(5,2) = zm * xm;
t(5,3) = zn * xn;
t(5,4) = xm * zn + zm * xn;
t(5,5) = xn * zl + zn * xl;
t(5,6) = xl * zm + zl * xm;
t(6,1) = xl * yl;
t(6,2) = xm * ym;
t(6,3) = xn * yn;
t(6,4) = xm * yn + ym * xn;
t(6,5) = xn * yl + yn * xl;
t(6,6) = xl * ym + yl * xm;

for k = 1:nn
sn(:,k) = t(:,:) * so(:,k);
end


