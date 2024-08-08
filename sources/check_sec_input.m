% This a small script is commonly used for checking the input values for the cross-section
% window
% (linked with "xsec_window.m")
%
% CAUTION: to check the study area, we need to declare global variable GRID
% in advance
%               xstart = GRID(1,1);
%               ystart = GRID(2,1);
%               xfinish = GRID(3,1);
%               yfinish = GRID(4,1);
global GRID ICOORD
% global IACTS

% IACTS = 0;
if ICOORD ~= 2
    
h = findobj('Tag','edit_sec_xs');
sec_xs = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_ys');
sec_ys = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_xf');
sec_xf = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_yf');
sec_yf = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_incre');
sec_incre = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_depth');
sec_depth = str2double(get(h,'String'));
h = findobj('Tag','edit_sec_depthinc');
sec_depthinc = str2double(get(h,'String'));
distance = sqrt((sec_xf-sec_xs)^2+(sec_yf-sec_ys)^2);
depth_allowance = sec_depth/sec_depthinc;
distance_allowance = distance/sec_incre;
%
% default number
allowance = 3;

% warning for not acceptable case
% if sec_xs >= sec_xf
%    h = warndlg('X finish should be larger than X start','Warning!');
% end
if sec_depth <= 0.0
   h = warndlg('Depth should be positive','Warning!');
end
if sec_incre <=0.0
   h = warndlg('Increment should be positive','Warning!');
end
if sec_depthinc <=0.0
   h = warndlg('Increment should be positive','Warning!');
end

if depth_allowance < allowance
   h = warndlg('Depth increment should be small enough to the depth','Warning!');
end
if distance_allowance < allowance
   h = warndlg('Distance increment should be small enough to the section','Warning!');
end

if sec_xs < GRID(1,1) | sec_xf > GRID(3,1)
    h = warndlg('Selected point should be within the area','Warning!');
end
if sec_ys < GRID(2,1) | sec_yf > GRID(4,1)
    h = warndlg('Selected point should be within the area','Warning!');
end

end
