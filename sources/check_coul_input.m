% This a small script is commonly used for checking the input values for
% the coulomb window
% (linked with "xsec_window.m")
%

h = findobj('Tag','edit_spec_strike');
strike = str2double(get(h,'String'));
h = findobj('Tag','edit_spec_dip');
dip = str2double(get(h,'String'));
h = findobj('Tag','edit_spec_rake');
rake = str2double(get(h,'String'));
h = findobj('Tag','edit_coul_depth');
depth = str2double(get(h,'String'));
h = findobj('Tag','edit_coul_fric');
fric = str2double(get(h,'String'));

% warning for not acceptable case
if (strike > 360.0 | strike < 0.0)
   h = warndlg('strike should be 0-360 deg.','Warning!');
   set(findobj('Tag','edit_spec_strike'),'String',num2str(0.0,'%6.1f'));
end
if (dip <= 0.0 | dip > 90.0)
   h = warndlg('Dip should be 0-90 deg','Warning!');
    set(findobj('Tag','edit_spec_dip'),'String',num2str(90.0,'%6.1f'));
end
if depth < 0.0
   h = warndlg('Depth should be positive','Warning!');
   set(findobj('Tag','edit_coul_depth'),'String',num2str(0.0,'%6.1f'));
end
if (fric < 0.0 | fric > 1.0)
   h = warndlg('Friction should be 0-1','Warning!');
   set(findobj('Tag','edit_coul_fric'),'String',num2str(0.0,'%6.1f'));
end
