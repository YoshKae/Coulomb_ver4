function section_grid_drawing
% This is the basemap for cross section options

global H_MAIN H_SECTION
global sec_xs sec_ys sec_xf sec_yf sec_incre sec_depth sec_depthinc

disp('This is section_grid_drawing.m');

distance = sqrt((sec_xf-sec_xs)^2+(sec_yf-sec_ys)^2);
nsec = int16(distance/sec_incre)+1;
ndepth = int16(sec_depth/sec_depthinc)+1;

x = [1:1:nsec];
y = [1:1:ndepth];
x = double(x - 1) .* sec_incre;
y = (-1.0) .* double(y - 1) .* sec_depthinc;

sec_depth = (-1.0) * sec_depth;

H_SECTION = figure(section_view_window);

set(H_SECTION,'Menubar','figure');
set(H_SECTION,'Toolbar','figure');

ha = get(gcf,'Children');

A_GRID = plot([0.0 distance distance 0.0 0.0],...
    [0.0 0.0 sec_depth sec_depth 0.0]);
    set(gca,'DataAspectRatio',[1 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[0.0,distance],...
    'YLim',[sec_depth,0.0]);
xlabel('Distance(km)','FontSize',14);
ylabel('Depth(km)','FontSize',14);

for m = 1:nsec
    hold on;
    gridline = plot([x(m) x(m)],[y(1) y(ndepth)]);
    set(gridline,'LineWidth',0.2,'Color','k');
end
for n = 1:ndepth
    hold on;
    gridline = plot([x(1) x(nsec)],[y(n) y(n)]); 
    set(gridline,'LineWidth',0.2,'Color','k');
end
hold off;
