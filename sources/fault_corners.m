function [fc] = fault_corners(xs,ys,xf,yf,dip,top,bottom)
% For seeking the four corners from the input data
%
% fc is a 4x2 matrix consisting of four map projection corners of a fault


% % flag = 1: just four corners of a source fault projected on the map view
% % flag = 2: for an ideal line which cuts the surface (fc(4,:))
% % flag = 3: for a line which calc depth plane intersects the source fault
% % (fc(4,:)

fc = zeros(4,2); % initialize to be all zeros to fasten the process

angle = atan((yf-ys)/(xf-xs));

dipr = deg2rad(dip);
shift = (bottom-top)/tan(dipr);


x_shift = shift * sin(angle);
y_shift = shift * cos(angle);

if (xf-xs) >= 0.0
xs_bottom = xs + x_shift;
ys_bottom = ys - y_shift;
xf_bottom = xf + x_shift;
yf_bottom = yf - y_shift;
else
xs_bottom = xs - x_shift;
ys_bottom = ys + y_shift;
xf_bottom = xf - x_shift;
yf_bottom = yf + y_shift;
end

% clockwise from the starting corner
fc = [xs,ys; xf,yf; xf_bottom,yf_bottom; xs_bottom,ys_bottom];
