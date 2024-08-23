function coulomb_open(N,nc)
% For rendering the coulomb out image, this function convert the text
% column file to matrix file which can be handled by image rendering
% fuction
% 
% N is so far a dummy
%

global XGRID YGRID
global CC
global FUNC_SWITCH
global DEPTH_RANGE_TYPE CALC_DEPTH_RANGE CALC_DEPTH
global STRESS_TYPE
global OUTFLAG PREF_DIR HOME_DIR
global PK_DEPTH

if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
else
	cd (PREF_DIR);
end
fid = fopen('dcff.cou','r');
if STRESS_TYPE == 1         % for optimally oriented faults (special format used)
    coul = textscan(fid,'%f %f %f %f %f %f %f %f %f','headerlines',3);
else
    coul = textscan(fid,'%f %f %f %f %f %f','headerlines',3);
end
fclose (fid);
% for multiple depth calcs (each depth slice is saved with 'km' label
% already. To avoid any confusion, remove 'dcff.cou')
    if DEPTH_RANGE_TYPE == 1
            delete('dcff.cou');
    else
            disp(['dcff.cou is saved in ' pwd]);
    end
cd (HOME_DIR);

if FUNC_SWITCH == 7         % shear stress change
	cl = coul{5};
elseif FUNC_SWITCH == 8     % normal stress change
	cl = coul{6};
elseif FUNC_SWITCH == 9     % coulomb stress change
    cl = coul{4};
end
% sigs = coul{5};
% sign = coul{6};
% 

if DEPTH_RANGE_TYPE == 0
% Coulomb stress matrix
CC = zeros(length(YGRID),length(XGRID),'double');
CC = reshape(cl,length(YGRID),length(XGRID));
CC = CC(length(YGRID):-1:1,:);
else        % for multiple calc depths
% Coulomb stress matrix
n = length(YGRID) * length(XGRID);
c1 = reshape(CC,1,n);
c2 = reshape(cl,1,n);
pc = reshape(PK_DEPTH,1,n);

    if DEPTH_RANGE_TYPE == 1
        c3 = max([c1; c2]);
        cpk1 = c1 > c2;
        cpk2 = c2 >= c1;
        pc = pc .* cpk1 + CALC_DEPTH * cpk2;
    else
        c3 = mean([c1; c2]);        
    end
CC = reshape(c3,length(YGRID),length(XGRID));
PK_DEPTH = reshape(pc,length(YGRID),length(XGRID));
end

if DEPTH_RANGE_TYPE == 0
% To make an image using "cc"
        coulomb_view(N);
else
    ar = '  ---> ';
    a = num2str(CALC_DEPTH_RANGE(int8(nc)),'%5.1f'); b = 'km depth plane is now calculated.';
    c = num2str(int8(double(nc/length(CALC_DEPTH_RANGE))*100),'%3i'); d = '% calculation is done.';
    ab = strcat(a,b); arcd = strcat(ar,c,d);
    disp(ab); disp(arcd);
    if nc == length(CALC_DEPTH_RANGE)
        CC = CC(length(YGRID):-1:1,:);
        PK_DEPTH = PK_DEPTH(length(YGRID):-1:1,:);
        if OUTFLAG == 1 | isempty(OUTFLAG) == 1
            cd output_files;
        else
            cd (PREF_DIR);
        end
% save CC as a text file for maximum stress change
    ccOne = reshape(flipud(CC),n,1);
    depthpick = reshape(flipud(PK_DEPTH),n,1);
    dum1 = zeros(n,1);
    xx = reshape(repmat(XGRID,length(YGRID),1),n,1);
    yy = reshape(repmat(flipud(rot90(YGRID)),1,length(XGRID)),n,1);
    if DEPTH_RANGE_TYPE == 1
        b = [xx yy depthpick ccOne dum1 dum1]; % 3rd & 5th & 6th columns are dummy
    elseif DEPTH_RANGE_TYPE == 2
        b = [xx yy dum1 ccOne dum1 dum1]; % 3rd & 5th & 6th columns are dummy        
    end
    format long;
	if DEPTH_RANGE_TYPE == 1            % maximum coulomb stress change
        header1 = ['Maximum coulomb stress change at depths between ' num2str(...
            CALC_DEPTH_RANGE(1),'%5.1f') ' km and ' num2str(...
            CALC_DEPTH_RANGE(end),'%5.1f') ' km'];
        header2 = 'x y Z-max_pick coulomb dummy dummy';
        header3 = '(km) (km) (km) (bar) (-) (-)';
        dlmwrite('dcff_max.cou',header1,'delimiter',''); 
        dlmwrite('dcff_max.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff_max.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff_max.cou',b,'-append','delimiter','\t','precision','%.6f');
	elseif DEPTH_RANGE_TYPE == 2        % mean coulomb stress change
        header1 = ['Mean coulomb stress change at depths between ' num2str(...
            CALC_DEPTH_RANGE(1),'%5.1f') ' km and ' num2str(...
            CALC_DEPTH_RANGE(end),'%5.1f') ' km'];
        header2 = 'x y dummy coulomb dummy dummy';
        header3 = '(km) (km) (-) (bar) (-) (-)';
        dlmwrite('dcff_mean.cou',header1,'delimiter',''); 
        dlmwrite('dcff_mean.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff_mean.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff_mean.cou',b,'-append','delimiter','\t','precision','%.6f');
	end

            cd (HOME_DIR);
        coulomb_view(N);
    end
end
