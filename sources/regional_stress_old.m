function [a] = regional_stress(rs,dep)
% changes regional stress inputs into one stress tensor matrix
%    

% INPUT: rs (regional stress matrix, 3x4)
%        dep (calculation depth)
%
% OUTPUT: a (stress tensor, 6x1)
%
% SUBROUTINE: stress_trans
%
% s1,d1,i1,g1,s2,d2,i2,g2,s3,d3,i3,g3,dep

[m,n] = size(dep);
m3 = zeros(m,1,'double');
rxx = zeros(m,1,'double');

a = zeros(6,1);
m3 = rs(3,3) + rs(3,4) * dep;
rxx = (-1.0) * (rs(1,3) + rs(1,4) * dep - m3);

    ryy = (-1.0) * (rs(2,3) + rs(2,4) * dep - m3);
    rzz = zeros(m,1,'double');

rxy = zeros(m,1,'double');
rxz = zeros(m,1,'double');
ryz = zeros(m,1,'double');
ss = [rot90(rxx); rot90(ryy); rot90(rzz); rot90(ryz); rot90(rxz); rot90(rxy)];
% changeconvention

% call stress trans
[a] = stress_trans(rs(1,1),rs(2,1),rs(3,1),rs(1,2),rs(2,2),rs(3,2),ss);


