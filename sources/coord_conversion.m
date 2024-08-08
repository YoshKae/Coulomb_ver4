function [xn,yn,al,aw] = coord_conversion(xgg,ygg,xs,ys,xf,yf,top,bottom,dip)
% coordinate conversion
%
% global coordinate
%
% INPUT: xgg, ygg (global coordinate)
%        xs,ys,xf,yf,top,bottom,dip (fault parameters)
%           xgg, ygg are matrix files. The others are scalar.
%
% OUTPUT: xn, yn (position for the fault, 0,0 should be at the center
%                 of the fault)
%           all are matrix files.
%

% disp('This is coord_conversion.m');
% 
% xgg = 0.0;
% ygg = 40.0;
% 
% xs = 0.0;
% ys = -10.0;
% xf = 0.1;
% yf =  10.1;
% top = 5.0;
% bottom = 30.0;
% dip = 30.0;

cx = (xf+xs)/2.0;
cy = (yf+ys)/2.0;
% h = (top+bottom)/2.0;
h = (bottom-top)/2.0;

k = tan(deg2rad(dip));
if k==0
    k = 0.000001;
end
d = h/k;
b = atan((yf-ys)./(xf-xs));

% xdipshift = abs(d * cos(b))
% ydipshift = abs(d * sin(b))
ydipshift = abs(d * cos(b));
xdipshift = abs(d * sin(b));

% here cx, cy is the center position of the fault projection
% on the global coordinate
if (xf > xs)
    if (yf > ys)
        cx = cx + xdipshift;
        cy = cy - ydipshift;        
    else
        cx = cx - xdipshift;
        cy = cy - ydipshift;        
    end
else
    if (yf > ys)
        cx = cx + xdipshift;
        cy = cy + ydipshift;        
    else
        cx = cx - xdipshift;
        cy = cy + ydipshift;        
    end
end

% xg(:,1) = xgg(:,1) - cx;
% yg(:,1) = ygg(:,1) - cy;

% % in case denominator is zero
% if xg(:,1)==0.0
%     xg(:,1) = 0.000001
% end
% a(:,1) = atan(yg(:,1)./xg(:,1));
% % aaa = rad2deg(atan(yg/xg));
% diag = sqrt(xg(:,1).*xg(:,1)+yg(:,1).*yg(:,1));

% converting global coordinate to Okada-fault coordinate
% xn and yn are the x, y position on the Okada coordinate
xn = (xgg-cx).*cos(b)+(ygg-cy).*sin(b);
yn =-(xgg-cx).*sin(b)+(ygg-cy).*cos(b);
if (xf-xs) < 0.0
xn = -xn;
yn = -yn;
end

% al is fault length, aw is fault width
al = sqrt((xf-xs).*(xf-xs)+(yf-ys).*(yf-ys))/2.0;
aw = ((bottom-top)/2.0)/(sin(deg2rad(dip)));