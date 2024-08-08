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

%---
% if d < 0.0
%     d = -d;
%     b = b + 180.0;
%     if b >= 180.0
%         b = b - 360.0;
%     else
%         b = b;
%     end
% end
% 
% if b <= 90.0
%     bb = 90.0 - b;
% else
%     bb = 270.0 - b;
% end
%     dd = d;


% if d >= 0.0
%         bb = 90.0 - b;
%         dd = 0.0;
% else
%     if b >= 90.0
%         bb = (90.0 - b) + 180.0;
%         dd = -d;
%     else
%         bb = (90.0 - b) - 180.0;
%         dd = -d;
%     end
% end
