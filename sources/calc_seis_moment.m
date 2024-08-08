%-------------------------------------------------------------------------
%     Moment calculation function
%-------------------------------------------------------------------------
function [mo,mw] = calc_seis_moment(x1,y1,x2,y2,right,reverse,dip,top,bot,poisson,young)
flength = sqrt((x1-x2)^2.+(y1-y2)^2.);
fwidth  = (bot - top) / sin(deg2rad(dip));
slip    = sqrt(right*right + reverse*reverse);
shearmod = young / (2.0 * (1.0 + poisson));
mo = shearmod * flength * fwidth * slip * 1.0e+18;
if mo == 0
    mw = 0.0;
else
    % mw = (2/3) * (log10(amo)-16.1);
    mw = (2/3) * log10(mo) - 10.7;
end