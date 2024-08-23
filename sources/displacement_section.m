function displacement_section
% This function is for rendering coulomb calc result in a cross section
%
global H_MAIN H_SECTION H_SEC_WINDOW
global STRESS_TYPE SHADE_TYPE
global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global DC3DS
global FRIC
global IACT IACTS
global STRIKE DIP RAKE
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global NSEC NDEPTH AX AY AZ
global SEC_FLAG H_SECTION COORD
global COLORSN
global SIZE
global DISP_SCALE
global NUM ELEMENT
global PREF
global FUNC_SWITCH CURRENT_VERSION INPUT_FILE
global EQ_DATA
global EQPICK_WIDTH
global OUTFLAG PREF_DIR HOME_DIR

distance = sqrt((SEC_XF-SEC_XS)^2+(SEC_YF-SEC_YS)^2);
NSEC = int32(distance/SEC_INCRE)+1;
NDEPTH = abs(int32(SEC_DEPTH/SEC_DEPTHINC))+1;

x = [1:1:NSEC];
y = [1:1:abs(NDEPTH)];
xt = x;
yt = y;
x = (double(x) - 1.0) * SEC_INCRE;
y = (-1.0) * (double(y) - 1.0) * SEC_DEPTHINC;
xmin = min(x);      % min km (normally zero) along the cross section x axis
xmax = max(x);      % maximum distance along the cross section x axis
ymin = min(y);      % deepest position along the depth axis (negative)
ymax = max(y);      % shallowest position along the depth axis (normally zero)
SEC_DEPTH = (-1.0) * SEC_DEPTH;

% x y position in a mapped coordinate along the cross section
xx = SEC_XS + (SEC_XF-SEC_XS)/double(NSEC-1) * double(xt-1);
yy = SEC_YS + (SEC_YF-SEC_YS)/double(NSEC-1) * double(xt-1);
AX = repmat(xx,abs(NDEPTH),1);   % repmat(M, v, h) copy function of Matrix
AY = repmat(yy,abs(NDEPTH),1);
AZ = repmat(reshape(y,abs(NDEPTH),1),1,NSEC);

SEC_FLAG = 1;
if IACTS ~= 1        
Okada_halfspace;
end
IACTS = 1;           % to keep okada output

a = length(DC3DS);
if a <= 14
    h = warndlg('Increase total grid number more than 14.','Warning!');
end
%        DC3DS0 = horzcat(XYCOORD,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
ss = zeros(3,a);
uhorizon = zeros(1,a);
s6 = reshape(DC3DS(:,6),1,a);           % UXG
s7 = reshape(DC3DS(:,7),1,a);           % UYG
s8 = reshape(DC3DS(:,8),1,a);           % UZG
ss = [s6; s7; s8];

h = findobj('Tag','section_view_window');
if isempty(h)==1
H_SECTION = figure(section_view_window);
set(H_SECTION,'Menubar','figure');
set(H_SECTION,'Toolbar','figure');
else
    ax = get(H_SECTION,'Children');
    cla(ax,'reset');
end

	figure(H_SECTION);
    hold on;

	if isempty(DISP_SCALE) ~= 1
        resz = (SIZE(3,1)/10000)*double(DISP_SCALE);
    else
        resz = SIZE(3,1)/10000;    
    end
    resz = double(resz);
    above_surface = 2.0 * round(resz/1.0) * SEC_INCRE;

%=== draw cross section grid ===================
plot([xmin xmax xmax xmin xmin],...
    [ymin ymin ymax ymax ymin]);
    set(gca,'DataAspectRatio',[1 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xmin,xmax],...
    'YLim',[ymin,ymax + above_surface],...
    'TickDir','out')
for m = 1:NSEC
    hold on;
    x0 = xmin + double(m) * SEC_INCRE;
    gridln1 = plot([x0 x0],[ymin ymax]);
        set(gridln1,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
end

for n = 1:NDEPTH-1
    hold on;
    y0 = ymin + double(n) * SEC_DEPTHINC;
    gridln2 = plot([xmin xmax],[y0 y0]);
        set(gridln2,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    x = repmat(x,abs(NDEPTH),1);
    x = reshape(x,1,NSEC*NDEPTH);
    y = repmat(y,1,abs(NSEC));
    for k = 1:NSEC*NDEPTH
        uhorizon(1,k) = disp_sect_conv(SEC_XS,SEC_YS,SEC_XF,SEC_YF,ss(1,k),ss(2,k));
    end
    if FUNC_SWITCH == 2
        hold on;
        a1 = quiver(x,y,uhorizon(1,:)*resz,ss(3,:)*resz,0);
        set(a1,'Color',PREF(2,1:3),'LineWidth',PREF(2,4));
        title('Displacement projected onto cross section','FontSize',14); 
    elseif FUNC_SWITCH == 3 | FUNC_SWITCH == 4
        xds = reshape(x,NDEPTH,NSEC);
        yds = reshape(y,NDEPTH,NSEC);
        uho = reshape(uhorizon,NDEPTH,NSEC);
        sz  = reshape(ss(3,:),NDEPTH,NSEC);
        xds = xds + uho * resz;
        yds = yds + sz  * resz;
        for k = 1:NSEC-1
            hold on;
            a1 = plot([xds(:,k) xds(:,k+1)],[yds(:,k) yds(:,k+1)]);
            set(a1,'Color','b','LineWidth',1);

        end
        for k = 1:NDEPTH-1
            hold on;
            a1 = plot([xds(k,:) xds(k+1,:)],[yds(k,:) yds(k+1,:)]);
            set(a1,'Color','b','LineWidth',1);

        end
        title('Deformed wireframe projected onto cross section','FontSize',14); 
        hold on;       
    end
    hold on;

% ***** save numerical output file (start) *************************
    surface = zeros(NSEC,1);
             format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
    bx    = reshape(DC3DS(:,1)',NDEPTH,NSEC);
    by    = reshape(DC3DS(:,2)',NDEPTH,NSEC);
    bdist = reshape(x,NDEPTH,NSEC);
    bux   = reshape(ss(1,:),NDEPTH,NSEC);
    buy   = reshape(ss(2,:),NDEPTH,NSEC);
	buz   = reshape(ss(3,:),NDEPTH,NSEC);
    b = [bx(1,1:NSEC)' by(1,1:NSEC)' bdist(1,1:NSEC)' surface bux(1,1:NSEC)' buy(1,1:NSEC)' buz(1,1:NSEC)'];
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y distance z UX UY UZ';
    header3 = '(km) (km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement_section.cou',header1,'delimiter',''); 
    dlmwrite('Displacement_section.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement_section.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement_section.cou',b,'-append','delimiter','\t','precision','%.6f');
    disp(['Displacement_section.cou is saved in ' pwd]);
    cd (HOME_DIR);
% ***** save numerical output file (end) *************************

%----------------------------------- draw fault line
for n = 1:NUM
    hold on;
	[lp_top,dp_top,lp_bottom,dp_bottom] = fault_int_sec(SEC_XS,SEC_YS,...
        SEC_XF,SEC_YF,ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    fpt0 = plot([lp_top lp_bottom],[dp_top dp_bottom]);
    set(fpt0,'LineWidth',2,'Color','w');
    fpt1 = plot([lp_top lp_bottom],[dp_top dp_bottom]);
    set(fpt1,'LineWidth',PREF(1,4),'Color',PREF(1,1:3));    
end
%----------------------------------- mapview line on cross section
    hold on;
    fpt = plot([xmin xmax],[-CALC_DEPTH -CALC_DEPTH]);
    set(fpt,'LineWidth',0.2,'LineStyle','--','Color','b');
%----------------------------------- unit displacement (1m)
    hold on;
    [unit,unitText] = check_unit_vector(xmin,xmax,1.0*resz,0.15,0.4);
	a0 = quiver((xmin+SEC_INCRE),(ymin+SEC_DEPTHINC*1.5),unit*resz,0.,0); %scale vector
    h = text((xmin+unit*resz*0.5),(ymin+SEC_DEPTHINC*2.2),unitText);
    set(a0,'Color','r','LineWidth',1.2);
    set(h,'FontName','Helvetica','Fontsize',14,'Color','r','FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
%----------------------------------- draw labels
hold on;
text(xmin+SEC_INCRE,ymax+SEC_DEPTHINC,'A','Color','b','FontSize',14,'FontWeight','bold');
text(xmax-SEC_INCRE*2.0,ymax+SEC_DEPTHINC,'B','Color','b','FontSize',14,'FontWeight','bold');
xlabel('Distance(km)','FontSize',14);
ylabel('Depth(km)','FontSize',14);
%----------------------------------- record stamp
hold on;
x = xmax + (xmax-xmin)/10.0;
y = ymin - (ymax-ymin)/2.0;
lsp = (ymax-ymin)*10.0/100.0;
record_stamp(H_SECTION,x,y,'SoftwareVersion',CURRENT_VERSION,...
        'FunctionType',FUNC_SWITCH,...
        'FileName',INPUT_FILE,'LineSpace',lsp,...
        'SectionStartX',SEC_XS,'SectionStartY',SEC_YS,...
        'SectionFinishX',SEC_XF,'SectionFinishY',SEC_YF,...
        'SectionFlag',SEC_FLAG);
%----------------------------------- ending treatment   
SEC_FLAG = 0;

% % === To plot earthquakes on the section =======
if strcmp(get(findobj('Tag','menu_earthquakes'), 'Checked'),'on')
    % plotting width to collect earthquakes
    if isempty(EQPICK_WIDTH)
        EQPICK_WIDTH = 20.0;    % (+- km)
    end    
    %------ EQ_DATA format (17 columns) -------------------------------
    % 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
    % 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
    % 16) x position, 17) y position
    %------------------------------------------------------------------
        [neq,nn] = size(EQ_DATA);
        secpos = ones(neq,7,'double');
        secpos(:,1) = SEC_XS;
        secpos(:,2) = SEC_YS;
        secpos(:,3) = SEC_XF;
        secpos(:,4) = SEC_YF;
        secpos(:,5) = 90.0;
        secpos(:,6) = 0.0;
        secpos(:,7) = 100.0;        
        [c1,c2,c3,c4] = coord_conversion(EQ_DATA(:,16),EQ_DATA(:,17),secpos(:,1),secpos(:,2),...
            secpos(:,3),secpos(:,4),secpos(:,5),secpos(:,6),secpos(:,7));
         wcut = abs(c2) <= ones(neq,1,'double') .* EQPICK_WIDTH;

        n = sum(rot90(sum(wcut)));
        c1a    = [(c1 + c3) .* wcut EQ_DATA(:,7)];
        c1flip = flipud(sortrows(c1a));
        c1sort = c1flip(1:n,:);
        hold on;
        h = scatter(c1sort(:,1),-c1sort(:,2),5*PREF(5,4),'MarkerEdgeColor',PREF(5,1:3));
        disp(' ');
        disp(['  Width to collect earthquakes is now ' num2str(EQPICK_WIDTH,'%5.1f') ' km.']); 
        disp('  To change the width, change the parameter ''EQPICK_WIDTH''(e.g., EQPICK_WIDTH=15.0)');
end

