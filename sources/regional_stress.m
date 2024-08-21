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

a = zeros(6,1);
m3 = rs(3,3) + rs(3,4) * dep;
rxx = (-1.0) * (rs(1,3) + rs(1,4) * dep - m3);

% temporal solution ???
% (need to be clearified... I do not know the reason...)
% if abs(rs(3,2)) >= abs(rs(2,2))
    ryy = (-1.0) * (rs(2,3) + rs(2,4) * dep - m3);
    rzz = 0.0;

rxy = 0.0;
rxz = 0.0;
ryz = 0.0;
ss = [rxx; ryy; rzz; ryz; rxz; rxy];
% changeconvention

% call stress trans
[a] = stress_trans(rs(1,1),rs(2,1),rs(3,1),rs(1,2),rs(2,2),rs(3,2),ss);


