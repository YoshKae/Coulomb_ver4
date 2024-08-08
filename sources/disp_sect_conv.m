function [uu] = disp_sect_conv(x0,y0,x1,y1,uux,uuy)
% this function converts a given horizontal unit displacement (uux, uuy)
% to a given cross section plane as uu
%  **** caution **** all parameters should be scalar.

% x0 = 0;
% y0 = 0;
% x1 = 40;
% y1 = -40;
% uux = -0.7;
% uuy = 1.0;

% in case
if y1 == y0
    y1 = y1 + 0.0001;
end

strk   = rad2deg(atan((x1-x0)/(y1-y0)));
u_strk = rad2deg(atan(uux/uuy));
uxy = sqrt(uux*uux + uuy*uuy);

if x1 > x0
    if y1 > y0          % -------- X+ & Y+
        if uux > 0
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end        
    else                % -------- X+ & Y-
        
        if uux < 0
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end  
        
        
    end
else
    if y1 > y0          % -------- X- & Y+

       if uux > 0
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end  
        
        
    else                % -------- X- & Y-

        if uux > 0
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        end  
        
    end
end


%     if u_strk < 0.0
%         u_strk = 90.0 - u_strk;
%     end




% ang = u_strk - strk

uu = cos(deg2rad(ang)) * uxy;
if uux < 0.0
    uu = -uu;
end


