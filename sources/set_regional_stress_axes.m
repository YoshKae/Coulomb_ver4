function [rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsinp,iflag)
%function set_regional_stress_axes
% This function calculate orientations and plunges of three principal
% stress axes.
%
% input:  rsin (3 x 2 matrix)
%         iflag 1: only seeking sigma 2 dip
%         iflag 2: all calc.
%
% output: rsout (3 x 2 matrix)
%         minmax: (1 x 2 matrix) min & max for sig2 dip range

% rsinp = [30.0 20.0; -100.0 70.0; -100.0 -100.0];
% iflag = 2;

% rsout = zeros(3,2,4,'double');
rsout1 = zeros(3,2,'double');
rsout2 = zeros(3,2,'double');
rsout3 = zeros(3,2,'double');
rsout4 = zeros(3,2,'double');
minmax = zeros(1,2);

%------------------------------------------------------------------------
% for convienience, initial ranges for strike and dip should be
%   strike: -180 to 180
%      dip: 0 to 90
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% To find two solutions of sigma 2
%------------------------------------------------------------------------
dip_max = 90.0 - rsinp(1,2);
dip_min = -dip_max;
minmax(1,1) = dip_min; minmax(1,2) = dip_max;
if iflag == 1; return; end
strike_21 = rsinp(1,1) - 90.0;
strike_22 = rsinp(1,1) + 90.0;


a = sin(deg2rad(rsinp(2,2)))/sin(deg2rad(abs(dip_max)));
b = cos(deg2rad(abs(dip_max)))/cos(deg2rad(rsinp(2,2)));
theta = rad2deg(asin(a*b));

strike_21 = strike_21 - theta;
strike_22 = strike_22 + theta;

%------------------------------------------------------------------------
% To find two solutions of sigma 3 from sigma 2-1
%------------------------------------------------------------------------
strike_31 = rsinp(1,1) - 90.0;
strike_32 = rsinp(1,1) + 90.0;

s2 = cos(deg2rad(rsinp(2,2))) * sin(deg2rad(theta));
h2 = sin(deg2rad(rsinp(2,2)));
l2 = sqrt(s2*s2 + h2*h2);
beta2 = rad2deg(asin(l2));
beta3 = 90.0 - beta2;

s3    = cos(deg2rad(dip_max)) * sin(deg2rad(beta3));
h3    = sqrt(sin(deg2rad(beta3))^2.0 + s3*s3);
dip_3  = rad2deg(asin(h3));
theta3 = rad2deg(asin(s3/cos(deg2rad(dip_3))));
strike_31 = strike_31 - theta3;
strike_32 = strike_32 + theta3;

%------------------------------------------------------------------------
% Make all solutions into matrix
%------------------------------------------------------------------------
rsout1 = [rsinp(1,1) rsinp(1,2); strike_21 rsinp(2,2); strike_31 dip_3];
rsout2 = [rsinp(1,1) rsinp(1,2); strike_21 rsinp(2,2); strike_32 dip_3];
rsout3 = [rsinp(1,1) rsinp(1,2); strike_22 rsinp(2,2); strike_31 dip_3];
rsout4 = [rsinp(1,1) rsinp(1,2); strike_22 rsinp(2,2); strike_32 dip_3];

	rsout1 = change_rs_convention(rsout1);
	rsout2 = change_rs_convention(rsout2);
	rsout3 = change_rs_convention(rsout3);
	rsout4 = change_rs_convention(rsout4); 

function rout = change_rs_convention(rin)
% To change regional stress convention
%      INPUT: rin (3 x 2 matrix)
%      OUTPUT: rout (3 x 2 matrix)
rout = zeros(3,2,'double');
for n = 1:3
    if rin(n,1)>=180.0
        rin(n,1) = rin(n,1) - 180.0; rin(n,2) = -rin(n,2);
    elseif rin(n,1)<0.0
        rin(n,1) = rin(n,1) + 180.0; rin(n,2) = -rin(n,2);
    end
end
rout = rin;


