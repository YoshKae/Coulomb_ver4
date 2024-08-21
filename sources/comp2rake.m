function [rake netslip] = comp2rake(latslip,dipslip)
% to convert lateral slip and dip slip column to rake and net slip columns
% each parameter is one column

n = length(latslip);
rake = zeros(n,1);
netslip = zeros(n,1);

netslip = sqrt(latslip.^2.0 + dipslip.^2.0);
c1 = latslip >= 0.0;
c2 = latslip < 0.0;
rake = c1.*(180.0 - rad2deg(atan(dipslip./latslip)))+...
c2.*(-1.0).*rad2deg(atan(dipslip./latslip));

if rake > 180
    rake = rake - 360.0;
end
