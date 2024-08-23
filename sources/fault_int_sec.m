function [lp_top,dp_top,lp_bottom,dp_bottom] = fault_int_sec(x0,y0,x1,y1,...
    fx0,fy0,fx1,fy1,dip,top,bottom)
% This function seeks cross sectio position of the fault intersection to
% a give cross section
% 
% OUTPUT: lp (distance along the horizontal cross section axis)
%         dp (distance along the vertical cross section axis)
%         lp_top,dp_top (for top position)
%         lp_bottom,dp_bottom (for bottom position)
% INPUT:  x0,y0 (cross section starting point)
%         x1,y1 (cross section ending point)
%         fx0,fy0 (fault starting point)
%         fx1,fy1 (fault ending point)
%         dip, udepth, ldepth (fault dip, upper depth, and lower depth)
%
% global x0 y0 x1 y1 fx0 fy0 fx1 fy1

sm = 0.00001; % to prevent dividing by zero

if fx0 == fx1
    fx1 = fx1 + sm;
end

angle = atan((fy1-fy0)/(fx1-fx0));
dipr = deg2rad(dip);
shift = (bottom-top)/tan(dipr);
x_shift = shift * sin(angle);
y_shift = shift * cos(angle);

if (fx1-fx0) >= 0.0
xs_bottom = fx0 + x_shift;
ys_bottom = fy0 - y_shift;
xf_bottom = fx1 + x_shift;
yf_bottom = fy1 - y_shift;
else
xs_bottom = fx0 - x_shift;
ys_bottom = fy0 + y_shift;
xf_bottom = fx1 - x_shift;
yf_bottom = fy1 + y_shift;
end

%---------------------------------TOP DEPTH X Y
a0 = (fy1-fy0)/(fx1-fx0);
if (fx1-fx0)==0.0
    a0 = (fy1-fy0)/sm;
end
b0 = fy0 - a0 * fx0;

        a_ftop = a0;
        b_ftop = b0;
        
a1 = (y1-y0)/(x1-x0);
if (x1-x0)==0.0
    a1 = (y1-y0)/sm;
end
b1 = y0 - a1 * x0;
aa = a1/a0;

ytop = (b1-aa*b0)/(1-aa);       % crossing point y
xtop = (ytop-b0)/a0;            % crossing point x
%---------------------------------

%---------------------------------BOTTOM DEPTH X Y
a0 = (yf_bottom-ys_bottom)/(xf_bottom-xs_bottom);
if (xf_bottom-xs_bottom)==0.0
    a0 = (yf_bottom-ys_bottom)/sm;
end
b0 = ys_bottom - a0 * xs_bottom;

        a_fbottom = a0;
        b_fbottom = b0;
        
a1 = (y1-y0)/(x1-x0);
if (y1-y0)==0.0
    a1 = (x1-x0)/sm;
end
b1 = y0 - a1 * x0;
aa = a1/a0;

ybottom = (b1-aa*b0)/(1-aa);	% crossing point y
xbottom = (ybottom-b0)/a0;      % crossing point x
%---------------------------------

%---------------------------------Downdip crossing
a0 = (fy1-yf_bottom)/(fx1-xf_bottom);
if (fx1-xf_bottom)==0.0
    a0 = (fy1-yf_bottom)/sm;
end
b0 = yf_bottom - a0 * xf_bottom;

        a_side1 = a0;
        b_side1 = b0;
        
a1 = (y1-y0)/(x1-x0);
if (x1-x0)==0.0
    a1 = (y1-y0)/sm;
end
b1 = y0 - a1 * x0;
aa = a1/a0;

yd1 = (b1-aa*b0)/(1-aa);        % crossing point y
xd1 = (yd1-b0)/a0;              % crossing point x
%---------------------------------

%---------------------------------Downdip crossing (the other side)
a0 = (fy0-ys_bottom)/(fx0-xs_bottom);
if (fx0-xs_bottom)==0.0
    a0 = (fy0-ys_bottom)/sm;
end
b0 = ys_bottom - a0 * xs_bottom;

        a_side2 = a0;
        b_side2 = b0;
        
a1 = (y1-y0)/(x1-x0);
if (x1-x0)==0.0
    a1 = (y1-y0)/sm;
end
b1 = y0 - a1 * x0;
aa = a1/a0;

yd2 = (b1-aa*b0)/(1-aa);        % crossing point y
xd2 = (yd2-b0)/a0;              % crossing point x
%---------------------------------

%--------------------------------SCREENING to fit the section
% appearent slope
% x0
lp_top    = sqrt((xtop-x0)^2+(ytop-y0)^2);
lp_bottom = sqrt((xbottom-x0)^2+(ybottom-y0)^2);

if x0 > xbottom && x0 < xtop
    slope = atan((bottom-top)/(lp_bottom+lp_top)); % apparent dip along the section
elseif x0 > xtop && x0 < xbottom
    slope = atan((bottom-top)/(lp_bottom+lp_top)); % apparent dip along the section  
else
    slope = atan((bottom-top)/(lp_bottom-lp_top)); % apparent dip along the section
end
% rad2deg(slope)
slope     = abs(slope);
dp_top    = -top;
dp_bottom = -bottom;

%---------- check (if four crossing points are in section line)
[itop,dtop]       = check_in_sec(x0,y0,x1,y1,xtop,ytop);
[ibottom,dbottom] = check_in_sec(x0,y0,x1,y1,xbottom,ybottom);
[i1,d1]           = check_in_sec(x0,y0,x1,y1,xd1,yd1);
[i2,d2]           = check_in_sec(x0,y0,x1,y1,xd2,yd2);
[itop ibottom i1 i2];
%---------- check (if four crossing points are in fault lines)
[it,dt]           = check_in_sec(fx0,fy0,fx1,fy1,xtop,ytop);
[ib,db]           = check_in_sec(xs_bottom,ys_bottom,xf_bottom,yf_bottom,...
                                 xbottom,ybottom);
[i1f,d1f]         = check_in_sec(fx1,fy1,xf_bottom,yf_bottom,xd1,yd1);
[i2f,d2f]         = check_in_sec(fx0,fy0,xs_bottom,ys_bottom,xd2,yd2);
[it ib i1f i2f];
%---------- select two proper points
itop    = itop    *  it;
ibottom = ibottom *  ib;
i1      = i1      * i1f;
i2      = i2      * i2f;

%---------- check any cross section end point is within a area of map
%           projection of the fault
y0_ftop    = a_ftop    * x0 + b_ftop;
y0_fbottom = a_fbottom * x0 + b_fbottom;
y0_side1   = a_side1   * x0 + b_side1;
y0_side2   = a_side2   * x0 + b_side2;

y1_ftop    = a_ftop    * x1 + b_ftop;
y1_fbottom = a_fbottom * x1 + b_fbottom;
y1_side1   = a_side1   * x1 + b_side1;
y1_side2   = a_side2   * x1 + b_side2;

sec_start_on_flt  = 0;
sec_finish_on_flt = 0;

if fx1 >= fx0
    if fy1 >= fy0
        if y0 < y0_ftop && y0 > y0_fbottom && y0 < y0_side1 && y0 > y0_side2

            sec_start_on_flt   = 1;
        end
        if y1 < y1_ftop && y1 > y1_fbottom && y1 < y1_side1 && y1 > y1_side2

            sec_finish_on_flt  = 1;
        end
    else
        if y0 < y0_ftop && y0 > y0_fbottom && y0 < y0_side2 && y0 > y0_side1

            sec_start_on_flt   = 1;
        end
        if y1 < y1_ftop && y1 > y1_fbottom && y1 < y1_side2 && y1 > y1_side1

            sec_finish_on_flt  = 1;
        end
    end
else
	if fy1 >= fy0
        if y0 > y0_ftop && y0 < y0_fbottom && y0 < y0_side1 && y0 > y0_side2

            sec_start_on_flt   = 1;
        end
        if y1 > y1_ftop && y1 < y1_fbottom && y1 < y1_side1 && y1 > y1_side2

            sec_finish_on_flt  = 1;
        end
    else
        if y0 > y0_ftop && y0 < y0_fbottom && y0 < y0_side2 && y0 > y0_side1

            sec_start_on_flt   = 1;
        end
        if y1 > y1_ftop && y1 < y1_fbottom && y1 < y1_side2 && y1 > y1_side1

            sec_finish_on_flt  = 1;
        end
    end  
end

iflag = [itop ibottom i1 i2];
if sum(iflag) <= 1
    if sec_start_on_flt == 1 && sec_finish_on_flt == 1
        dist_top0 = sqrt((xtop-x0)^2.+(ytop-y0)^2.);
        dist_top1 = sqrt((xtop-x1)^2.+(ytop-y1)^2.);
        if dist_top0 <= dist_top1
            lp_top    = 0;
            lp_bottom = sqrt((x1-x0)^2.+(y1-y0)^2.);
            dp_top    = dp_top - sqrt((xtop-x0)^2.+(ytop-y0)^2.) * tan(slope);
            dp_bottom = dp_top - lp_bottom * tan(slope);
        else
            lp_top    = 0;
            lp_bottom = sqrt((x1-x0)^2.+(y1-y0)^2.);
            dp_top    = dp_top - sqrt((xtop-x0)^2.+(ytop-y0)^2.) * tan(slope);
            dp_bottom = dp_top + lp_bottom * tan(slope);
        end
    elseif sec_start_on_flt == 1 && sec_finish_on_flt == 0
        if     itop == 1
            lp_bottom = 0.0;
            lp_top    = sqrt((xtop-x0)^2.+(ytop-y0)^2.);

            dp_bottom = dp_top - lp_top * tan(slope);
        elseif ibottom == 1
            lp_top    = 0.0;
            lp_bottom = sqrt((xbottom-x0)^2.+(ybottom-y0)^2.);

            dp_top    = dp_bottom + lp_bottom * tan(slope); 
        elseif i1 == 1                                      % CHECK
            lp_temp1  = sqrt((xtop-xd1)^2.+(ytop-yd1)^2.);
            lp_temp2  = sqrt((xtop-x0)^2.+(ytop-y0)^2.);
            dp_temp1  = dp_top - lp_temp1 * tan(slope);
            dp_temp2  = dp_top - lp_temp2 * tan(slope); 
            if lp_temp1 <= lp_temp2
                lp_top    = 0.0;
                lp_bottom = sqrt((xd1-x0)^2.+(yd1-y0)^2.);
                dp_top    = dp_temp2;
                dp_bottom = dp_temp1;
            else
                lp_top    = sqrt((xd1-x0)^2.+(yd1-y0)^2.);
                lp_bottom = 0.0;
                dp_top    = dp_temp1;
                dp_bottom = dp_temp2;
            end
        elseif i2 == 1
            lp_temp1  = sqrt((xtop-xd2)^2.+(ytop-yd2)^2.);
            lp_temp2  = sqrt((xtop-x0)^2.+(ytop-y0)^2.);
            dp_temp1  = dp_top - lp_temp1 * tan(slope);
            dp_temp2  = dp_top - lp_temp2 * tan(slope); 
            if lp_temp1 <= lp_temp2
                lp_top    = sqrt((xd2-x0)^2.+(yd2-y0)^2.);
                lp_bottom = 0.0;
                dp_top    = dp_temp1;
                dp_bottom = dp_temp2;
            else
                lp_top    = 0.0;
                lp_bottom = sqrt((xd2-x0)^2.+(yd2-y0)^2.);
                dp_top    = dp_temp2;
                dp_bottom = dp_temp1;
            end
        end
    elseif sec_start_on_flt == 0 && sec_finish_on_flt == 1
        if     itop == 1
            lp_bottom = sqrt((x0-x1)^2.+(y0-y1)^2.);
            lp_top    = sqrt((x0-xtop)^2.+(y0-ytop)^2.);

            dp_bottom = dp_top - sqrt((x1-xtop)^2.+(y1-ytop)^2.) * tan(slope);
        elseif ibottom == 1
            lp_bottom = sqrt((xbottom-x0)^2.+(ybottom-y0)^2.);
            lp_top    = sqrt((x0-x1)^2.+(y0-y1)^2.);

            dp_top    = dp_bottom + sqrt((x1-xbottom)^2.+(y1-ybottom)^2.) * tan(slope); 
        elseif i1 == 1
            lp_temp1  = sqrt((xtop-xd1)^2.+(ytop-yd1)^2.);
            lp_temp2  = sqrt((xtop-x1)^2.+(ytop-y1)^2.);
            dp_temp1  = dp_top - lp_temp1 * tan(slope);
            dp_temp2  = dp_top - lp_temp2 * tan(slope); 
            if lp_temp1 <= lp_temp2
                lp_top    = sqrt((xd1-x0)^2.+(yd1-y0)^2.);
                lp_bottom = sqrt((x1-x0)^2.+(y1-y0)^2.);
                dp_top    = dp_temp1;
                dp_bottom = dp_temp2;
            else
                lp_top    = sqrt((x1-x0)^2.+(y1-y0)^2.);
                lp_bottom = sqrt((xd1-x0)^2.+(yd1-y0)^2.);
                dp_top    = dp_temp2;
                dp_bottom = dp_temp1;
            end
        elseif i2 == 1
            lp_temp1  = sqrt((xtop-xd2)^2.+(ytop-yd2)^2.);
            lp_temp2  = sqrt((xtop-x1)^2.+(ytop-y1)^2.);
            dp_temp1  = dp_top - lp_temp1 * tan(slope);
            dp_temp2  = dp_top - lp_temp2 * tan(slope); 
            if lp_temp1 <= lp_temp2
                lp_top    = sqrt((xd2-x0)^2.+(yd2-y0)^2.);
                lp_bottom = sqrt((x1-x0)^2.+(y1-y0)^2.);
                dp_top    = dp_temp1;
                dp_bottom = dp_temp2;
            else
                lp_top    = sqrt((x1-x0)^2.+(y1-y0)^2.);
                lp_bottom = sqrt((xd2-x0)^2.+(yd2-y0)^2.);
                dp_top    = dp_temp2;
                dp_bottom = dp_temp1;
            end 
        end       
    else
        dp_top    = [];
        lp_top    = [];
        dp_bottom = [];
        lp_bottom = [];
    end

elseif sum(iflag) >= 3
    disp('something wrong. see fault_init_sec.m');
else                    % sum(iflag) = 2
    if itop == 1 && ibottom == 1 % sec line crosses the fault top & bottom

    elseif itop == 1 && i1 == 1

        dp_bottom = dp_top - abs(d1-dtop) * tan(slope);
        lp_bottom = d1;        
    elseif itop == 1 && i2 == 1

        dp_bottom = dp_top - abs(d2-dtop) * tan(slope);
        lp_bottom = d2;  
    elseif ibottom == 1 && i1 == 1

        dp_top = dp_bottom + abs(d1-dbottom) * tan(slope);        
        lp_top = d1;
    elseif ibottom == 1 && i2 == 1

        dp_top = dp_bottom + abs(d2-dbottom) * tan(slope);
        lp_top = d2;
    elseif i1 == 1 && i2 == 1   % problem

        temp_dp_top    = dp_top;
        temp_dp_bottom = dp_bottom;
        if x0 > xtop && x0 <= xd1

            dp_top    = temp_dp_top - abs(d1+dtop) * tan(slope);
            dp_bottom = temp_dp_top - abs(dtop+d2) * tan(slope);
            lp_top    = d1;
            lp_bottom = d2;
        elseif x0 < xbottom && x0 >= xd2

            dp_bottom = temp_dp_bottom + abs(d2+dbottom) * tan(slope);
            dp_top    = temp_dp_bottom + abs(dbottom+d1) * tan(slope);
            lp_top    = d1;
            lp_bottom = d2;
        elseif x0 > xbottom && x0 <= xd1

            dp_bottom = temp_dp_bottom + abs(d1+dbottom) * tan(slope);
            dp_top    = temp_dp_bottom + abs(dbottom+d2) * tan(slope);
            lp_top    = d2;
            lp_bottom = d1;
        elseif x0 > xd2 && x0 <= xtop

            dp_top    = temp_dp_top - abs(d2+dtop) * tan(slope);
            dp_bottom = temp_dp_top - abs(dtop+d1) * tan(slope);
            lp_top    = d2;
            lp_bottom = d1;
        else
        disp('Unknown error to draw the fault line.');
        end
    end
end


        
%====================================================================
function [i,dist] = check_in_sec(xs,ys,xf,yf,xp,yp)
i    = 0;
dist = 0;
xmax = max([xs;xf]); xmin = min([xs;xf]);
ymax = max([ys;yf]); ymin = min([ys;yf]);
if xp >= xmin && xp <= xmax
    if yp >= ymin && yp <= ymax
        i = 1;
    end
end
        dist = sqrt((xp-xs)^2+(yp-ys)^2);
