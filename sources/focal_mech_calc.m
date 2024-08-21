function focal_mech_calc
% This function calculates resolved stress on two nodal planes 
% and plots earthquakes on Coulomb map.
% This function can be accessible when EQ_DATA is stored in the software
% memory.
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------
global H_MAIN
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID KODE
global PREF
global ICOORD
global EQ_DATA
global NUM ELEMENT YOUNG POIS FRIC
global ANATOLIA
global N_CELL
global OUTFLAG PREF_DIR HOME_DIR
global INODAL H_NODAL NODAL_ACT NODAL_STRESS
global COAST_DATA AFAULT_DATA GPS_DATA VOLCANO
global C_SAT
global CC LON_GRID LAT_GRID
% persistent f_stress
global f_stress
global IVECTOR

% set(H_MAIN,'Menubar','figure','Toolbar','figure');
% set(gcf,'Renderer','painters')

% ==================== Special option to make the dots vectorized object
% IVECTOR = 1; % (0: raster image, 1: vector object, 2: beachball)
IVECTOR = 2;
% ====================

xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);
lon = EQ_DATA(:,1);
lat = EQ_DATA(:,2);
xx = xs + (lon - MIN_LON) .* xinc;
yy = ys + (lat - MIN_LAT) .* yinc;
zz = EQ_DATA(:,7);
m = size(EQ_DATA,1);

if NODAL_ACT == 0
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------
check1 = sum(EQ_DATA(:,10)) + sum(EQ_DATA(:,11)) + sum(EQ_DATA(:,12));
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check1 == 0
	warndlg('No focal mechanism data available in this catalog','!! Warning !!');
	return
else
    INODAL = 1;
    if check2 == 0
	h = questdlg('Only one nodal plane data set. Do you want to make the other set? Original set will be ''Nodal 1''. The other will be ''Nodal 2''.',...
        ' ','Yes','No','Cancel');
    switch h
        case 'Yes'
            hc = wait_calc_window;   % custom waiting dialog
            out = nodal_plane_calc(EQ_DATA(:,10),EQ_DATA(:,11),EQ_DATA(:,12));
            EQ_DATA(:,10) = out(:,1);
            EQ_DATA(:,11) = out(:,2);
            EQ_DATA(:,12) = out(:,3);
            EQ_DATA(:,13) = out(:,4);
            EQ_DATA(:,14) = out(:,5);
            EQ_DATA(:,15) = out(:,6);
            INODAL = 1;
            close(hc);
        case 'No'
 %           warndlg('Do not calc. for nodal plane 2.','!! Warning !!');
    end
    end
end
N_CELL = m;
SEC_FLAG = 0;
% loop process may slow the calc down (change matrix calc in the near
% future using 'Okada_halfspace' instead of 'Okada_halfspace_one.'
f_stress = zeros(m,21);
% initialization
dc3de = zeros(m,14,'double');
dc3de0 = zeros(m,14,'double');
UX = zeros(m,1,'double');
UY = zeros(m,1,'double');
UZ = zeros(m,1,'double');
UXX = zeros(m,1,'double');
UYX = zeros(m,1,'double');
UZX = zeros(m,1,'double');
UXY = zeros(m,1,'double');
UYY = zeros(m,1,'double');
UZY = zeros(m,1,'double');
UXZ = zeros(m,1,'double');
UZZ = zeros(m,1,'double');
IRET = zeros(m,1);
for k = 1:NUM
depth = (ELEMENT(k,8)+ELEMENT(k,9))/2.0;  % depth should be positive
[c1,c2,c3,c4] = coord_conversion(xx,yy,ELEMENT(k,1),ELEMENT(k,2),...
                ELEMENT(k,3),ELEMENT(k,4),ELEMENT(k,8),ELEMENT(k,9),ELEMENT(k,7));
alpha  =  1.0/(2.0*(1.0-POIS));
z  = double(zz) * (-1.0);
aa = zeros(m,1,'double') + double(alpha);
zc = zeros(m,1,'double') + double(z);
dp = zeros(m,1,'double') + double(depth);
e7 = zeros(m,1,'double') + double(ELEMENT(k,7));
e5 = zeros(m,1,'double') - double(ELEMENT(k,5));    % left-lat positive in Okada's code
e6 = zeros(m,1,'double') + double(ELEMENT(k,6));
zr = zeros(m,1,'double');
x  = zeros(m,1,'double') + double(c1);
y  = zeros(m,1,'double') + double(c2);
al = zeros(m,1,'double') + double(c3);
aw = zeros(m,1,'double') + double(c4);
a = [aa x y zc dp e7 al al aw aw e5 e6 zr];

[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
     UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
     a(:,4),a(:,5),a(:,6),...
     a(:,7),a(:,8),a(:,9),...
     a(:,10),a(:,11),a(:,12),a(:,13));

% ********* added 2013/3/24
if KODE(k) == 400 | KODE(k) == 500
[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D0(a(:,1),a(:,2),a(:,3),...
    a(:,4),a(:,5),a(:,6),a(:,10),a(:,11),a(:,12),a(:,13));    
end
% ********* 

% cell to matrices
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
%-- Displacement Conversion from Okada's field to Given field -------------
%    ELEMENT = double(ELEMENT);
    sw = sqrt((ELEMENT(k,4)-ELEMENT(k,2))^2+(ELEMENT(k,3)-ELEMENT(k,1))^2);
    sina = (ELEMENT(k,4)-ELEMENT(k,2))/double(sw);
    cosa = (ELEMENT(k,3)-ELEMENT(k,1))/double(sw);
    UXG = UX*cosa-UY*sina;
    UYG = UX*sina+UY*cosa;
    UZG = UZ;
% C-- Strain to Stress for the normal component -----------------------------
% strain to stress
    sk = YOUNG/(1.0+POIS);
    gk = POIS/(1.0-2.0*POIS);
    vol = UXX + UYY + UZZ;
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (YOUNG/(2.0*(1.0+POIS))) * (UXY + UYX) * 0.001;
    sxz = (YOUNG/(2.0*(1.0+POIS))) * (UXZ + UZX) * 0.001;
    syz = (YOUNG/(2.0*(1.0+POIS))) * (UYZ + UZY) * 0.001;
    ssxx = reshape(sxx,1,m);
    ssyy = reshape(syy,1,m);
    sszz = reshape(szz,1,m);
    ssxy = reshape(sxy,1,m);
    ssxz = reshape(sxz,1,m);
    ssyz = reshape(syz,1,m);    
    s0 = [ssxx; ssyy; sszz; ssyz; ssxz; ssxy];
%-- Strain Conversion from Okada's field to Given field -------------
    s1 = tensor_trans(sina,cosa,s0,m);
    SXX = reshape(s1(1,:),m,1);
    SYY = reshape(s1(2,:),m,1);
    SZZ = reshape(s1(3,:),m,1);
    SYZ = reshape(s1(4,:),m,1);
    SXZ = reshape(s1(5,:),m,1);
    SXY = reshape(s1(6,:),m,1); 
    if k == 1
        dc3de = horzcat(xx,yy,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    else
        dc3de0 = horzcat(zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),...
                UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    end
        dc3de = dc3de + dc3de0;
%          UZG
end
% ss = zeros(6,m);
s9 = reshape(dc3de(:,9),1,m);
s10 = reshape(dc3de(:,10),1,m);
s11 = reshape(dc3de(:,11),1,m);
s12 = reshape(dc3de(:,12),1,m);
s13 = reshape(dc3de(:,13),1,m);
s14 = reshape(dc3de(:,14),1,m);
ss = [s9; s10; s11; s12; s13; s14];
% nodal plane 1
    c1 = zeros(m,1,'double') + EQ_DATA(:,10);
    c2 = zeros(m,1,'double') + EQ_DATA(:,11);
    c3 = zeros(m,1,'double') + EQ_DATA(:,12);
% nodal plane 2
    c11 = zeros(m,1,'double') + EQ_DATA(:,13);
    c22 = zeros(m,1,'double') + EQ_DATA(:,14);
    c33 = zeros(m,1,'double') + EQ_DATA(:,15);
c4 = zeros(m,1,'double') + FRIC;
f_stress(:,1) = EQ_DATA(:,3); f_stress(:,2) = EQ_DATA(:,4);
f_stress(:,3) = EQ_DATA(:,5); f_stress(:,4) = EQ_DATA(:,8);
f_stress(:,5) = EQ_DATA(:,9); f_stress(:,6) = EQ_DATA(:,1);
f_stress(:,7) = EQ_DATA(:,2); f_stress(:,8) = EQ_DATA(:,7);
f_stress(:,9) = EQ_DATA(:,6);

% Coulomb calc for nodal plane 1
f_stress(:,10) = c1;
f_stress(:,11) = c2;
f_stress(:,12) = c3;
[f_stress(:,13),f_stress(:,14),f_stress(:,15)] = calc_coulomb(c1,c2,c3,c4,ss);
% Coulomb calc for nodal plane 2
f_stress(:,16) = c11;
f_stress(:,17) = c22;
f_stress(:,18) = c33;
[f_stress(:,19),f_stress(:,20),f_stress(:,21)] = calc_coulomb(c11,c22,c33,c4,ss);

end % while...


%====================
format long;
if OUTFLAG == 1 || isempty(OUTFLAG) == 1
	cd output_files;
else
	cd (PREF_DIR);
end
% % cd output_files
% header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike1,dip1,rake1,shear1,normal1,coulomb1,strike2,dip2,rake2,shear2,normal2,coulomb2';
% header2 = '-,-,-,-,-,(deg),(deg),(km),-,(deg),(deg),(deg),(bar),(bar),(bar),(deg),(deg),(deg),(bar),(bar),(bar)';
% % footer1 = ' ';
%          dlmwrite('Focal_mech_stress_output.csv',header1,'delimiter','');  
%          dlmwrite('Focal_mech_stress_output.csv',header2,'delimiter','','-append');  
%          dlmwrite('Focal_mech_stress_output.csv',f_stress,'delimiter',',','precision','%15.6f','-append');
%          disp(['Focal_mech_stress_output.csv is saved in ' pwd]);
% INODAL
% check1 = sum(EQ_DATA(:,10)) + sum(EQ_DATA(:,11)) + sum(EQ_DATA(:,12));
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if INODAL == 1 || INODAL == 2
    if check2 == 0
    header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike,dip,rake,shear,normal,coulomb';
    header2 = '-,-,-,-,-,(deg),(deg),(km),-,(deg),(deg),(deg),(bar),(bar),(bar)';
	dlmwrite('Focal_mech_stress_output.csv',header1,'delimiter','');  
	dlmwrite('Focal_mech_stress_output.csv',header2,'delimiter','','-append');  
	dlmwrite('Focal_mech_stress_output.csv',f_stress(:,1:15),'delimiter',',','precision','%15.6f','-append');
    NODAL_STRESS = f_stress(:,15);
    else
    header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike1,dip1,rake1,shear1,normal1,coulomb1,strike2,dip2,rake2,shear2,normal2,coulomb2';
    header2 = '-,-,-,-,-,(deg),(deg),(km),-,(deg),(deg),(deg),(bar),(bar),(bar),(deg),(deg),(deg),(bar),(bar),(bar)';
	dlmwrite('Focal_mech_stress_output.csv',header1,'delimiter','');  
	dlmwrite('Focal_mech_stress_output.csv',header2,'delimiter','','-append');  
	dlmwrite('Focal_mech_stress_output.csv',f_stress,'delimiter',',','precision','%15.6f','-append');
%     NODAL_STRESS = f_stress(:,21);
        if INODAL == 1
            NODAL_STRESS = f_stress(:,15);
        elseif INODAL == 2
            NODAL_STRESS = f_stress(:,21);
        end
    end
else
    if INODAL == 3          % random
    r1 = int32(rand(m,1));
    r2 = (-1) * (r1 - 1);
	randstrike = zeros(m,1,'double')...
        + f_stress(:,10).*double(r1) + f_stress(:,16).*double(r2);
	randdip = zeros(m,1,'double')...
        + f_stress(:,11).*double(r1) + f_stress(:,17).*double(r2);
	randrake = zeros(m,1,'double')...
        + f_stress(:,12).*double(r1) + f_stress(:,18).*double(r2);
    randshear  = zeros(m,1,'double')...
        + f_stress(:,13).*double(r1) + f_stress(:,19).*double(r2);
    randnormal = zeros(m,1,'double')...
        + f_stress(:,14).*double(r1) + f_stress(:,20).*double(r2);
    NODAL_STRESS = zeros(m,1,'double')...
        + f_stress(:,15).*double(r1) + f_stress(:,21).*double(r2);
    header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike-rand,dip-rand,rake-rand,shear,normal,coulomb';
    elseif INODAL == 4      % max delta CFF
        ind1 = f_stress(:,15) >= f_stress(:,21);
        ind2 = f_stress(:,21) >  f_stress(:,15);
        randstrike   = f_stress(:,10).*ind1 + f_stress(:,16).*ind2;
        randdip      = f_stress(:,11).*ind1 + f_stress(:,17).*ind2;
        randrake     = f_stress(:,12).*ind1 + f_stress(:,18).*ind2;
        randshear    = f_stress(:,13).*ind1 + f_stress(:,19).*ind2;
        randnormal   = f_stress(:,14).*ind1 + f_stress(:,20).*ind2;
        NODAL_STRESS = f_stress(:,15).*ind1 + f_stress(:,21).*ind2;

            
    header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike-max,dip-max,rake-max,shear,normal,coulomb';
    else                    % min delta CFF
        ind1 = f_stress(:,15) <= f_stress(:,21);
        ind2 = f_stress(:,21) <  f_stress(:,15);
        randstrike   = f_stress(:,10).*ind1 + f_stress(:,16).*ind2;
        randdip      = f_stress(:,11).*ind1 + f_stress(:,17).*ind2;
        randrake     = f_stress(:,12).*ind1 + f_stress(:,18).*ind2;
        randshear    = f_stress(:,13).*ind1 + f_stress(:,19).*ind2;
        randnormal   = f_stress(:,14).*ind1 + f_stress(:,20).*ind2;
        NODAL_STRESS = f_stress(:,15).*ind1 + f_stress(:,21).*ind2;


    header1 = 'year,month,day,hour,minute,lon.,lat.,depth,magnitude,strike-min,dip-min,rake-min,shear,normal,coulomb';
    end
    temp = [f_stress(:,1:9) randstrike randdip randrake randshear randnormal NODAL_STRESS];
    header2 = '-,-,-,-,-,(deg),(deg),(km),-,(deg),(deg),(deg),(bar),(bar),(bar)';
	dlmwrite('Focal_mech_stress_output.csv',header1,'delimiter','');  
	dlmwrite('Focal_mech_stress_output.csv',header2,'delimiter','','-append');  
	dlmwrite('Focal_mech_stress_output.csv',temp,'delimiter',',','precision','%15.6f','-append');
end
disp(['Focal_mech_stress_output.csv is saved in ' pwd]);
disp('To change color saturation limits, change variable C_SAT in the workspace.');
disp('And then redo the same action.')
%**********************
%       message
%**********************
if isempty(IVECTOR)
    disp('--------------------------------------------------------- ');
    disp(' This image is saved as a raster image when saved.');
    disp(' If you want to save a vectorized & editable image, type');   
    disp('       IVECTOR = 1;');
    disp(' in the command window here and execute it again.'); 
    disp('--------------------------------------------------------- ');
end
cd (HOME_DIR);
%=====================



% clear_obj_and_subfig;
figure(H_MAIN);
set(gca,'Visible','Off');
% subfig_clear;
grid_drawing;
% fault_overlay;
hold on;
        c_index = zeros(64,3);
        switch PREF(7,1)
            case 1
            	c_index = colormap(jet);
            case 2
            	c_index = colormap(ANATOLIA);                
            case 3
            	c_index = colormap(gray);                
        end
        if isempty(C_SAT)
            c_mean = mean(abs(NODAL_STRESS));
        else
            c_mean = C_SAT;
        end
        c_unit = c_mean * 2.0 / 64;
        ni = zeros(m,1,'int8');
        
%            ni(:,1) = round((NODAL_STRESS(:,1) - (-c_mean)) / c_unit);
            if INODAL == 4
            temp3 = sortrows([NODAL_STRESS f_stress(:,6) f_stress(:,7)],1);
            ni(:,1) = round((temp3(:,1) - (-c_mean)) / c_unit);
            elseif INODAL == 5
            temp3 = flipud(sortrows([NODAL_STRESS f_stress(:,6) f_stress(:,7)],1));
            ni(:,1) = round((temp3(:,1) - (-c_mean)) / c_unit);            
            else
            temp3 = [NODAL_STRESS f_stress(:,6) f_stress(:,7)];   
            ni(:,1) = round((NODAL_STRESS(:,1) - (-c_mean)) / c_unit);
            end
                c1 = ni(:,1) > 64;
                c2 = ni(:,1) <  1;
                c3 = c1 + c2 <= 0.0;
                ni(:,1) = int16(64.*double(c1) + 1.*double(c2) + double(ni(:,1)).*double(c3));

% added on March 25, 2021
% EQ_RGB = [EQ_DATA(:,:) NODAL_STRESS c_index(ni(:,:),1:3)*255];
% save EQ_RGB.dat EQ_RGB -ascii
% disp('EQ_RGB.dat is saved for GMT based color-coded xsection beachballs');
%
                adj = 0.5; % adjusment of stress dots
                
 %               IVECTOR = 1;
                
            if ICOORD == 2 % lon & lat coordinates
               if IVECTOR == 1 % vector image for dot
                for jj = 1:length(temp3)
                    h  = scatter(temp3(jj,2),temp3(jj,3),6*PREF(5,4)*adj*1.3,...
                                    c_index(ni(jj,1),1:3));
                end
               elseif IVECTOR == 2 % beachball plot
                   if INODAL == 1
                       %function bb(fm, centerX, centerY, diam, ta, color)
                    h0 = bb2([EQ_DATA(:,10) EQ_DATA(:,11) EQ_DATA(:,12)],...
                        temp3(:,2),temp3(:,3),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));
                   elseif INODAL == 2
                    h0 = bb2([EQ_DATA(:,13) EQ_DATA(:,14) EQ_DATA(:,15)],...
                        temp3(:,2),temp3(:,3),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));
                   else
                    h0 = bb2([randstrike(:,1) randdip(:,1) randrake(:,1)],...
                        temp3(:,2),temp3(:,3),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));
                   end
                else
                h0 = scatter(temp3(:,2),temp3(:,3),10*PREF(5,4)*adj,'MarkerEdgeColor','k');
                h  = scatter(temp3(:,2),temp3(:,3),6*PREF(5,4)*adj,c_index(ni(:,1),1:3));
                set(h0,'LineWidth',9.0);
                set(h,'LineWidth',8.0);
                set(h0,'Tag','EqObj');
                set(h, 'Tag','EqObj2');
               end 
            else            % x & y (cartesian) coordinates
                a  = lonlat2xy([temp3(:,2) temp3(:,3)]);
                if IVECTOR == 1
                    for jj = 1:length(temp3)
                        h  = scatter(a(jj,1),a(jj,2),6*PREF(5,4)*adj*1.3,...
                            c_index(ni(jj,1),1:3));
                    end
                elseif IVECTOR == 2 % beachball plot
                   if INODAL == 1
        
                    h0 = bb2([EQ_DATA(:,10) EQ_DATA(:,11) EQ_DATA(:,12)],...
                        a(:,1),a(:,2),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));  
                   elseif INODAL == 2
                    h0 = bb2([EQ_DATA(:,13) EQ_DATA(:,14) EQ_DATA(:,15)],...
                        a(:,1),a(:,2),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));
                   else
                    h0 = bb2([randstrike(:,1) randdip(:,1) randrake(:,1)],...
                        a(:,1),a(:,2),EQ_DATA(:,6)*PREF(5,4)*adj,...
                        0,1,c_index(ni(:,1),1:3));
                   end
                
                else
                h0 = scatter(a(:,1),a(:,2),10*PREF(5,4)*adj,'MarkerEdgeColor','k');
                h  = scatter(a(:,1),a(:,2),6*PREF(5,4)*adj,c_index(ni(:,1),1:3));
                set(h0,'LineWidth',9.0);
                set(h,'LineWidth',8.0);
                set(h0,'Tag','EqObj');
                set(h, 'Tag','EqObj2');
                end
            end
%             set(h0,'LineWidth',9.0);
%             set(h,'LineWidth',8.0);
%             set(h0,'Tag','EqObj');
%             set(h, 'Tag','EqObj2');
            set(findobj('Tag','menu_focal_mech'),'Enable','On');
%         if isempty(C_SAT)
            caxis([(-1.0)*c_mean c_mean]);
%         else
%             caxis([(-1.0)*C_SAT C_SAT]);
%         end
        colorbar('location','EastOutside');

        set(gca,'Visible','On');
       title('Coulomb stress changes on nodal planes (bar)','FontSize',14);

%*************************
    nodal_stress_change = [f_stress(:,15); f_stress(:,21)];
    save nodal_stress.mat nodal_stress_change; 
%*************************

% ***** all overlay ****** 
fault_overlay;
if isempty(COAST_DATA)~=1 | isempty(VOLCANO)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing2; % not overlay_drawing (this is internal function no to plot EQ)
end
% ************************ 

% % warning dialog
%     wd = warndlg('Color-coded dots are from randomly selected one of two nodal planes. See numerical output file for details.','!! Warning !!');
%     waitfor(wd);

if INODAL == 1 || INODAL == 2
    if check2 ~= 0
        h = findobj('Tag','nodal_plane_window');
        if (isempty(h)==1)
%             INODAL = 1;
            H_NODAL = nodal_plane_window;
        end
    end
end


%************************************************
function overlay_drawing2
%************************************************

global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA GTEXT_DATA
global VOLCANO
global ICOORD LON_GRID PREF
global NH_COMMENT
global H_MAIN

% ----- coast line plot -----
h = findobj('Tag','menu_coastlines');
h1 = get(h,'Checked');
if isempty(COAST_DATA)~=1 && strcmp(h1,'on')
        coastline_drawing;
end

% ----- active fault plot -----
h = findobj('Tag','menu_activefaults');
h1 = get(h,'Checked');
if isempty(AFAULT_DATA)~=1 && strcmp(h1,'on')    
        afault_drawing;    
end

% --- gps plot ---------------
h = findobj('Tag','menu_gps');
h1 = get(h,'Checked');
if isempty(GPS_DATA)~=1 && strcmp(h1,'on')
        gps_plot;
end

% --- Label or comment plot ---------------
h = findobj('Tag','menu_put_comment');
h1 = get(h,'Checked');
if isempty(GTEXT_DATA)~=1 && strcmp(h1,'on')
    ch = get(H_MAIN,'Children');
    NH_COMMENT(1) = length(get(ch(1),'Children'))+1;
    [m,n] = size(GTEXT_DATA);
    for k = 1:n-1
    GTEXT_DATA(k).handle = text(GTEXT_DATA(k).x,GTEXT_DATA(k).y,GTEXT_DATA(k).text);
    set(GTEXT_DATA(k).handle,'FontSize',str2num(GTEXT_DATA(k).font));
    end
    NH_COMMENT(2) = length(get(ch(1),'Children'))-NH_COMMENT(1);
    NH_COMMENT(1) = 1; order_overlay_handle(4);
end

% --- Volcano PLUG-IN (not default) --------
try
    if ~isempty(VOLCANO)
        volcano_overlay;
    end
catch
    return
end