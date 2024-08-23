function [fc] = fault_corners_vec(xs,ys,xf,yf,dip,top,bottom)
% For seeking the four corners from the input data


% % flag = 1: just four corners of a source fault projected on the map view
% % flag = 2: for an ideal line which cuts the surface (fc(4,:))
% % flag = 3: for a line which calc depth plane intersects the source fault
% % (fc(4,:)

n = size(xs,1);
fc = zeros(n,8); % initialize to be all zeros to fasten the process


angle = atan((yf-ys)./(xf-xs));

shift = (bottom-top)./tan(deg2rad(dip));


x_shift = shift .* sin(angle);
y_shift = shift .* cos(angle);

ind1 = xf >= xs;
ind2 = xf < xs;
ind3 = yf >= ys;
ind4 = yf < ys;
xs_bottom = (xs + x_shift).*ind1 + (xs - x_shift).*ind2;
ys_bottom = (ys - y_shift).*ind3 + (ys + y_shift).*ind4;
xf_bottom = (xf + x_shift).*ind1 + (xf - x_shift).*ind2;
yf_bottom = (yf - y_shift).*ind3 + (yf + y_shift).*ind4;

% clockwise from the starting corner
fc = [xs ys xf yf xf_bottom yf_bottom xs_bottom ys_bottom];
