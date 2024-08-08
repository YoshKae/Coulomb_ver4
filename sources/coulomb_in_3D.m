function [ output_args ] = coulomb_in_3D(input_args)
%% Alternative method of plotting the coulomb stress transfer
% working within the Coulomb framework
% beginning as a script but will eventually adapt into a function

global ELEMENT
global GRID
global ANATOLIA
global COULOMB_RAKE

    % Reading input data from ELEMENT variable
    xstart=ELEMENT(:,1);
    ystart=ELEMENT(:,2);
    xend=ELEMENT(:,3);
    yend=ELEMENT(:,4);
    dip=ELEMENT(:,7);
    top=ELEMENT(:,8);
    bottom=ELEMENT(:,9);

% For each element within the ELEMENT array
% for j=1:length(ELEMENT)
for j=1:size(ELEMENT,1)
    % Calculate the strike of the segment
    if xstart(j)<=xend(j)
        el_strike(j)=90+atand((ystart(j)-yend(j))/(xend(j)-xstart(j)));
    elseif xstart(j)>xend(j)
        el_strike(j)=270+atand((ystart(j)-yend(j))/(xend(j)-xstart(j)));
    else
        disp('Error in strike calculations')
    end

    % Calculate the bottom points of the box
    projdir=el_strike(j)+90;
    if projdir>360
        projdir=projdir-360;
    else
    end

    del_surf=(bottom(j)-top(j))/(tand(dip(j)));
    x(1,j)=xstart(j);
    x(2,j)=xend(j);
    y(1,j)=ystart(j);
    y(2,j)=yend(j);
    if projdir<90
        dx=del_surf*sind(projdir);
        dy=del_surf*cosd(projdir);
        x(4,j)=xstart(j)+dx;
        x(3,j)=xend(j)+dx;
        y(4,j)=ystart(j)+dy;
        y(3,j)=yend(j)+dy;
    elseif projdir<180 & projdir>=90
        dx=del_surf*sind(180-projdir);
        dy=del_surf*cosd(180-projdir);
        x(4,j)=xstart(j)+dx;
        x(3,j)=xend(j)+dx;
        y(4,j)=ystart(j)-dy;
        y(3,j)=yend(j)-dy;
    elseif projdir<270 & projdir>=180 
        dx=del_surf*sind(projdir-180);
        dy=del_surf*cosd(projdir-180);
        x(4,j)=xstart(j)-dx;
        x(3,j)=xend(j)-dx;
        y(4,j)=ystart(j)-dy;
        y(3,j)=yend(j)-dy;
    elseif projdir<360 & projdir>=270 
        dy=del_surf*sind(projdir-270);
        dx=del_surf*cosd(projdir-270);
        x(4,j)=xstart(j)-dx;
        x(3,j)=xend(j)-dx;
        y(4,j)=ystart(j)+dy;
        y(3,j)=yend(j)+dy;
    else
        disp('Error: box coordinates cannot be calculated')
    end
    z(1,j)=-top(j);
    z(2,j)=-top(j);
    z(3,j)=-bottom(j);
    z(4,j)=-bottom(j);
end
figure
p=patch(x,y,z,COULOMB_RAKE);
set(gca,'Color',[0.9 0.9 0.9],...
        'PlotBoxAspectRatio',[1 1 1]);
%whitebg('w');
%set(p,'EdgeColor','None');
view(3)
colormap(ANATOLIA)
cb=colorbar('southoutside');
title(cb,'Transferred stress (bars)');
caxis([-0.1 0.1])
xlabel('UTM x')
ylabel('UTM y')
zlabel('Depth (km)')
axis equal
hold on

% Drawing in grid lines
for i=GRID(1,1):GRID(5,1):GRID(3,1)
    line([i i],[GRID(2,1) GRID(4,1)],'Color',[0.5 0.5 0.5])
end
for i=GRID(2,1):GRID(6,1):GRID(4,1)
    line([GRID(1,1) GRID(3,1)],[i i],'Color',[0.5 0.5 0.5])
end
end
