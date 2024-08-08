% This is a script for drawing a cross section line on a mapview
%
global H_MAIN H_COULOMB H_SEC_WINDOW HO HT1 HT2
global SEC_FLAG

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

% precalculations for  'A' & 'B' labeling
distance = sqrt((sec_xf-sec_xs)^2+(sec_yf-sec_ys)^2);
nsec = int16(distance/sec_incre);
xlb = (sec_xf-sec_xs)/double(nsec);
ylb = abs(sec_yf-sec_ys)/double(nsec);
x1 = sec_xs-xlb;
x2 = sec_xs+xlb;
y1 = sec_yf-ylb;
y2 = sec_yf+ylb;

figure(H_MAIN);
% hold on;
% to delete already existing line and labels
%if SEC_FLAG == 1
h = findobj('Tag','xsec_window');
h0 = findobj(gca,'Tag','cross_section_line');
ha = findobj(gca,'Tag','cross_section_A');
hb = findobj(gca,'Tag','cross_section_B');
hold on;
if (isempty(h)~=1 & isempty(H_SEC_WINDOW)~=1 & isempty(h0)~=1)
    delete(HO);
end
if (isempty(h)~=1 & isempty(H_SEC_WINDOW)~=1 & isempty(ha)~=1)
    delete(HT1);
end
if (isempty(h)~=1 & isempty(H_SEC_WINDOW)~=1 & isempty(hb)~=1)
    delete(HT2);
end

hold on;
% to plot the cross section line
HO = plot([sec_xs sec_xf],[sec_ys sec_yf]);
set(HO,'Tag','cross_section_line');         %TAG cross_section_line
% to make labels 'A' and 'B'
hold on;
HT1 = text(sec_xs,sec_ys,'A','FontSize',18);
HT2 = text(sec_xf,sec_yf,'B','FontSize',18);
set(HT1,'HorizontalAlignment','center');
set(HT2,'HorizontalAlignment','center');
set(HT1,'Tag','cross_section_A');         %TAG cross_section_A
set(HT2,'Tag','cross_section_B');         %TAG cross_section_B