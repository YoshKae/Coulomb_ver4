function el = taper_calc(el0,d_strike,d_dip,edge,npatch,young,poisson)
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

% <test>
% el0 = [-5 -5 10 10 2.0 1.0 50.0 0.0 15.0];
% d_strike = 3.0;
% d_dip = 3.0;
% npatch = 5;
% young = 800000;
% poisson = 0.25;

xs = el0(1);
ys = el0(2);
xf = el0(3);
yf = el0(4);
rls = el0(5);
rvs = el0(6);
dip = el0(7);
top = el0(8);
bottom = el0(9);

el = zeros(npatch,9);
ax = 0.0;
ay = 0.0;
amo = 0.0;

xx = abs(xf - xs);
yy = abs(yf - ys);
dia = sqrt(xx^2 + yy^2);    % length of the fault
dipl = (bottom - top) / sin(deg2rad(dip)); % down-dip width of the fault
edge_rls = 0.0;
edge_rvs = 0.0;
if rls == 0.0
    edge_rls = 0.0;
elseif rls < 0.0
    edge_rls = -edge;
end

if rvs == 0.0
    edge_rvs = 0.0;
elseif rvs < 0.0
    edge_rvs = -edge;
end

fx = xx / dia;
fy = yy / dia;
grad_rls_st = (rls - edge_rls) / d_strike; % strike-slip grad along strike
grad_rls_di = (rls - edge_rls) / d_dip;    % strike-slip grad along dip
grad_rvs_st = (rvs - edge_rvs) / d_strike; % dip-slip grad along strike
grad_rvs_di = (rvs - edge_rvs) / d_dip;    % dip-slip grad along dip
ud = d_strike / double(npatch - 1);
zu = d_dip / double(npatch - 1);  % distance about the fault offset along dip dir
dz = zu * sin(deg2rad(dip)); % distance about the offset along depth
dd = zu * cos(deg2rad(dip)); % distance about the offset along horizontal

if xf >= xs
    if yf >= ys
        theta = atan((yf-ys)/(xf-xs));
    else
        theta = atan((ys-yf)/(xf-xs));
    end
else
    if yf >= ys
        theta = atan((yf-ys)/(xs-xf));
    else
%         theta = atan((yf-ys)/(xf-xs));
        theta = atan((ys-yf)/(xs-xf));
    end
end

zx = dd * sin(theta);   % unit distance along x-axis for dip-slip direction
zy = dd * cos(theta);   % unit distance along y-axis for dip-slip direction

ux = fx * ud;   % unit distance along x-axis for strike direction
uy = fy * ud;   % unit distance along y-axis for strike direction

% common number before entering loop
ax = 0.0;
ay = 0.0;
% Moment (uniform slip)
shearmod = young / (2.0 * (1.0 + poisson));
slip = sqrt(rls^2.0 + rvs^2.0);
smo = shearmod * dia * dipl * slip * 1.0e+18;
tmo = 0.0;
amo = amo + smo;
%-----------------------------
for m = 1:npatch
    if xf >= xs
        if yf >= ys
            xxs(m) = xs + zx * double(m);
            xxf(m) = xf + zx * double(m); 
            yys(m) = ys - zy * double(m);
            yyf(m) = yf - zy * double(m); 
        else
            xxs(m) = xs - zx * double(m);
            xxf(m) = xf - zx * double(m); 
            yys(m) = ys - zy * double(m);
            yyf(m) = yf - zy * double(m); 
        end
    else
        if yf >= ys
            xxs(m) = xs + zx * double(m);
            xxf(m) = xf + zx * double(m); 
            yys(m) = ys + zy * double(m);
            yyf(m) = yf + zy * double(m); 
        else
            xxs(m) = xs - zx * double(m);
            xxf(m) = xf - zx * double(m); 
            yys(m) = ys + zy * double(m);
            yyf(m) = yf + zy * double(m); 
        end
    end
    if xxf(m) >= xxs(m)
        if yyf(m) >= yys(m)
            xxs(m) = xxs(m) + ux * double(m);
            xxf(m) = xxf(m) - ux * double(m); 
            yys(m) = yys(m) + uy * double(m);
            yyf(m) = yyf(m) - uy * double(m); 
        else
            xxs(m) = xxs(m) + ux * double(m);
            xxf(m) = xxf(m) - ux * double(m); 
            yys(m) = yys(m) - uy * double(m);
            yyf(m) = yyf(m) + uy * double(m); 
        end
    else
        if yyf(m) >= yys(m)
            xxs(m) = xxs(m) - ux * double(m);
            xxf(m) = xxf(m) + ux * double(m); 
            yys(m) = yys(m) + uy * double(m);
            yyf(m) = yyf(m) - uy * double(m); 
        else
            xxs(m) = xxs(m) - ux * double(m);
            xxf(m) = xxf(m) + ux * double(m); 
            yys(m) = yys(m) - uy * double(m);
            yyf(m) = yyf(m) + uy * double(m);  
        end
    end
    dtt = ud * double((npatch - 1.0) - m);
    dt  = zu * double((npatch - 1.0) - m);

    rrls(m) = edge_rls + zu * grad_rls_di * m - ax;
    rrvs(m) = edge_rvs + zu * grad_rvs_di * m - ay;
    
    if rls == 0.0
           rrls(m) = 0.0;
    end
    if rvs == 0.0
           rrvs(m) = 0.0;           
    end
%     if (rls == 0.0) & (rvs == 0.0)
%            rrls(m) = 0.0;
%            rrvs(m) = 0.0;   
%     end
    top2(m)    = top + dz * m;
    bottom2(m) = bottom - dz * m;
    ax = ax + rrls(m);
    ay = ay + rrvs(m);
% Moment calculation
    tslip = sqrt(rrls(m)^2.0 + rrvs(m)^2.0);

    tlength = dia - 2.0 * (d_strike - dtt);
    twidth  = dipl - 2.0 * (d_dip - dt);

    mo = shearmod * tlength * twidth * tslip;
    tmo = tmo + mo * 1.0e+18;
end

adjmo = smo / tmo;
for m = 1:npatch
    if rrls(m) == 0.0
        rrls(m) = 0.0;
    else
        rrls(m) = adjmo * rrls(m);
    end
    if rrvs(m) == 0.0
        rrvs(m) = 0.0;
    else
        rrvs(m) = adjmo * rrvs(m);
    end
    el(m,1) = xxs(m);
    el(m,2) = yys(m);
    el(m,3) = xxf(m);
    el(m,4) = yyf(m);
    el(m,5) = rrls(m);
    el(m,6) = rrvs(m);
    el(m,7) = dip;
    el(m,8) = top2(m);
    el(m,9) = bottom2(m);
end
% mw = (2/3) * (log10(amo)-16.1);
    mw = (2/3) * log10(amo) - 10.7;
    disp(['Seismic moment = ' num2str(smo,'%6.2e') ' dyne cm (Mw = ', num2str(mw,'%4.2f') ')'])

% %       el(:,1) xstart (km)
% %       el(:,2) ystart (km)
% %       el(:,3) xfinish (km)
% %       el(:,4) yfinish (km)
% %       el(:,5) right-lat. slip (m)
% %       el(:,6) reverse slip (m)
% %       el(:,7) dip (degree)
% %       el(:,8) fault top depth (km)
% %       el(:,9) fault bottom depth (km)
% xs = el0(1);
% ys = el0(2);
% xf = el0(3);
% yf = el0(4);
% rls = el0(5);
% rvs = el0(6);
% dip = el0(7);
% top = el0(8);
% bottom = el0(9);




