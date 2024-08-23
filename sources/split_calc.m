function el = split_calc(el0,ns,nd)
% ns = 5;
% nd = 5;
% el0 = [-10 25 25 -5 2.0 0.0 90.0 0.0 15.0];

nn = ns * nd;
el = zeros(nn,9,'double');

% el0 = [xs ys xf yf rls revs dip top bottom]
% Each fault element
%       el(:,1) xstart (km)
%       el(:,2) ystart (km)
%       el(:,3) xfinish (km)
%       el(:,4) yfinish (km)
%       el(:,5) right-lat. slip (m)
%       el(:,6) reverse slip (m)
%       el(:,7) dip (degree)
%       el(:,8) fault top depth (km)
%       el(:,9) fault bottom depth (km)
xs = el0(1);
ys = el0(2);
xf = el0(3);
yf = el0(4);
top = el0(8);
bottom = el0(9);

xd = double(xf - xs) / double(ns);
yd = double(yf - ys) / double(ns);
zd = double(bottom - top) / double(nd);
ncount = 0;
for k = 1:ns
    xst(k) = xs + double(k-1) * xd;
    yst(k) = ys + double(k-1) * yd;
    xfn(k) = xs + double(k) * xd;
    yfn(k) = ys + double(k) * yd;
    for m = 1:nd
        ncount = ncount + 1;
        tp(m) = double(m-1) * zd;
        xy = dip_shift([xst(k) yst(k) xfn(k) yfn(k)],el0(7),tp(m));
        el(ncount,1) = xy(1);
        el(ncount,2) = xy(2);
        el(ncount,3) = xy(3);
        el(ncount,4) = xy(4);
        bt(m) = double(m) * zd;
        el(ncount,8) = tp(m) + top;
        el(ncount,9) = bt(m) + top;
    end
end
el(:,5) = el0(5);
el(:,6) = el0(6);
el(:,7) = el0(7);

%--------------------------------------------------
% FUNCTION DIP_SHIFT
%--------------------------------------------------
function xy_shift = dip_shift(xy_org,dip,z)
xy_shift = zeros(1,4,'double');
d = double(z / tan(deg2rad(dip)));
xs = double(xy_org(1));
ys = double(xy_org(2));
xf = double(xy_org(3));
yf = double(xy_org(4));
if abs(xf-xs) ~= 0.0
    ang = atan(abs(yf-ys)/abs(xf-xs));
else
    ang = atan(abs(yf-ys)/0.00001);
end
if xf >= xs
    if yf >= ys
        phi = 90.0 - rad2deg(ang);
    else
        phi = 90.0 + rad2deg(ang);
    end
else
    if yf >= ys
        phi = 270.0 + rad2deg(ang);        
    else
        phi = 270.0 - rad2deg(ang); 
    end
end
xx = cos(deg2rad(phi)) * d;
yy = sin(deg2rad(phi)) * d;
xy_shift(1) = xs + xx;
xy_shift(3) = xf + xx;
xy_shift(2) = ys - yy;
xy_shift(4) = yf - yy;
