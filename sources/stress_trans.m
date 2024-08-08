function [st] = stress_trans(bb1,bb2,bb3,dd1,dd2,dd3,ss)
% For transforming stress tensor in a given oordinate
%
% INPUT: ss (stress tensor in a given coordinate, 6 x 1)
%        b1-b3, d1-d3 (orientation and dip of the principal axes)
% OUTPUT: st (stress tensor in another coordinate, 6 x 1)
%
%    sequence of stress tensor comp
%      [sxx; syy; szz; syz; sxz; sxy]
%
% SUBROUTINE CALL: adjust_principal
%

% for test %%%%%%%%%%%%%%%%%%%
% TEST 1
% bb1 = 24;
% bb2 = 114;
% bb3 = 0.0;
% dd1 = 0.00;
% dd2 = 0.00;
% dd3 = -90.00;
% ss = [-100.0; -30.0; 0.0; 0.0; 0.0; 0.0];

% TEST 2
% bb1 = 19;
% bb2 = 90;
% bb3 = 109;
% dd1 = 0.00;
% dd2 = 90.00;
% dd3 = 0.00;
% ss = [-100.0; 0.0; -30.0; 0.0; 0.0; 0.0];

% TEST 3
% bb1 = 114;
% bb2 = 24;
% bb3 = 0.0;
% dd1 = 0.00;
% dd2 = 0.00;
% dd3 = -90.00;
% ss = [-100.0; -30.0; 0.0; 0.0; 0.0; 0.0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[b1,d1] = adjust_principal(bb1,dd1);
[b2,d2] = adjust_principal(bb2,dd2);
[b3,d3] = adjust_principal(bb3,dd3);
% [b1 b2 b3]
% [d1 d2 d3]

tt = zeros(6,6,'double');
st = zeros(6,1,'double');

% adjustment for our coordinate system from Aki & Richards convension

xdel = deg2rad(double(d1));
ydel = deg2rad(double(d2));
zdel = deg2rad(double(d3));
xbeta = deg2rad(double(b1));
ybeta = deg2rad(double(b2));
zbeta = deg2rad(double(b3));

% seeking cosine

xl = cos(xdel) * cos(xbeta);
xm = cos(xdel) * sin(xbeta);
xn = sin(xdel);
yl = cos(ydel) * cos(ybeta);
ym = cos(ydel) * sin(ybeta);
yn = sin(ydel);
zl = cos(zdel) * cos(zbeta);
zm = cos(zdel) * sin(zbeta);
zn = sin(zdel);

% matrix inversion (should be converted to matrix form calc for MATLAB)

%         a1 = (-1.0)*yn*zm + ym*zn;
% 		a2 = (-1.0)*xn*ym*zl + xm*yn*zl;
% 		a3 = xn*yl*zm - xl*yn*zm;
% 		a4 = (-1.0)*xm*yl*zn + xl*ym*zn;
% 		b1 = xn*zm - xm*zn;
% 		c1 = (-1.0)*xn*ym + xm*yn;		
% 	xll = a1 / (a2 + a3 + a4);
% 	xmm = b1 / (a2 + a3 + a4);
% 	xnn = c1 / (a2 + a3 + a4);
% 
% 		d1 = yn*zl - yl*zn;
% 		d2 = (-1.0)*xn*ym*zl + xm*yn*zl;
% 		d3 = xn*yl*zm - xl*yn*zm;
% 		d4 = (-1.0)*xm*yl*zn + xl*ym*zn;
% 		e1 = (-1.0)*xn*zl + xl*zn;
% 		f1 = xn*yl - xl*yn;
% 	yll = d1 / (d2 + d3 + d4);
% 	ymm = e1 / (d2 + d3 + d4);
% 	ynn = f1 / (d2 + d3 + d4);
% 		
% 		g1 = (-1.0)*ym*zl + yl*zm;
% 		g2 = (-1.0)*xn*ym*zl + xm*yn*zl;
% 		g3 = xn*yl*zm - xl*yn*zm;
% 		g4 = (-1.0)*xm*yl*zn + xl*ym*zn;
% 		h1 = xm*zl - xl*zm;
% 		i1 = (-1.0)*xm*yl + xl*ym;
% 
% 	zll = g1 / (g2 + g3 + g4);
% 	zmm = h1 / (g2 + g3 + g4);
% 	znn = i1 / (g2 + g3 + g4);

xll = xl; xmm = xm; xnn = xn;
yll = yl; ymm = ym; ynn = yn;
zll = zl; zmm = zm; znn = zn;

t11 = xll * xll;
t12 = xmm * xmm;
t13 = xnn * xnn;
t14 = 2.0 * xmm * xnn;
t15 = 2.0 * xnn * xll;
t16 = 2.0 * xll * xmm;
t21 = yll * yll;
t22 = ymm * ymm;
t23 = ynn * ynn;
t24 = 2.0 * ymm * ynn;
t25 = 2.0 * ynn * yll;
t26 = 2.0 * yll * ymm;
t31 = zll * zll;
t32 = zmm * zmm;
t33 = znn * znn;
t34 = 2.0 * zmm * znn;
t35 = 2.0 * znn * zll;
t36 = 2.0 * zll * zmm;
t41 = yll * zll;
t42 = ymm * zmm;
t43 = ynn * znn;
t44 = ymm * znn + zmm * ynn;
t45 = ynn * zll + znn * yll;
t46 = yll * zmm + zll * ymm;
t51 = zll * xll;
t52 = zmm * xmm;
t53 = znn * xnn;
t54 = xmm * znn + zmm * xnn;
t55 = xnn * zll + znn * xll;
t56 = xll * zmm + zll * xmm;
t61 = xll * yll;
t62 = xmm * ymm;
t63 = xnn * ynn;
t64 = xmm * ynn + ymm * xnn;
t65 = xnn * yll + ynn * xll;
t66 = xll * ymm + yll * xmm;

tt = [t11 t12 t13 t14 t15 t16; t21 t22 t23 t24 t25 t26; t31 t32 t33 t34 t35 t36;...
    t41 t42 t43 t44 t45 t46; t51 t52 t53 t54 t55 t56; t61 t62 t63 t64 t65 t66];


% st = tt * ss;
% st = inv(tt) * ss;
st = tt \ ss;
