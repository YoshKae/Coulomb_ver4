function [bb,dd] = adjust_principal(b,d)
% adjustment for principal axes

b = 90.0 - b;
if b < 0.0
    b = 180.0 + b;
end

if d < 0.0
    d = -d;
    b = b - 180.0;    
end

bb = b;
dd = d;
