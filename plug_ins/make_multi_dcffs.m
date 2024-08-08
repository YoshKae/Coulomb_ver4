%MAKE_MULTI_DCFFS
%
% Read dcff file and set time mark
counter = 0;
n = 500;    % default number of iteration
matrix = [1 1 1; 0 0 0];
% if ~isempty(dcff)
%     clear dcff;
% end
% dcff(:).cc = [];
% dcff(:).name = [];
% dcff(:).time = [];

for i = 1:n
    [filename,pathname] = uigetfile({'*.*'},' Open Coulomb stress change file');
    if isequal(filename,0)
        disp('  User selected Cancel');
        break;
%         return
    else
        disp('  ----- Delata CFF data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
        fid = fopen(fullfile(pathname, filename),'r');
        if STRESS_TYPE == 1         % for optimally oriented faults (special format used)
            coul = textscan(fid,'%f %f %f %f %f %f %f %f %f','headerlines',3);
        else
            coul = textscan(fid,'%f %f %f %f %f %f','headerlines',3);
        end
        fclose (fid);
        xx = [coul{1}]; yy = [coul{2}];
        yms = min(yy); ymf = max(yy); ymi = abs(yy(2)-yy(1)); ymn = int32((ymf-yms)/ymi)+1;
        xms = min(xx); xmf = max(xx); xmi = abs(xx(ymn+1)-xx(ymn)); xmn = int32((xmf-xms)/xmi)+1;
                cl= zeros(ymn,xmn,'double');
                cl = reshape(coul{4},ymn,xmn);
                cl = cl(ymn:-1:1,:);
                dcff(i).cc   = cl;
                dcff(i).name = input('  Type the name of earthquake.','s');
                yr = str2double(input('  Year of the earthquake occurrence (e.g., 1992)?','s'));
                mo = str2double(input('  Month of the earthquake occurrence (e.g., 6)?','s'));
                dy = str2double(input('  Day of the earthquake occurrence (e.g., 28)?','s'));
                hr = str2double(input('  Hour of the earthquake occurrence (e.g., 4)?','s'));
                mn = str2double(input('  Minute of the earthquake occurrence (e.g., 57)?','s'));
                dcff(i).time = yr + (datenum(yr,mo,dy,hr,mn,0) - datenum(yr,1,1,0,0,0)) / 365.25;

        reply = input('Another earthquake? y/n [y]:','s');
        if isempty(reply)
            reply = 'y';
        end
        switch reply
            case 'y'
                continue
            case 'n'
                break;
            otherwise
                return
        end
    end
end

save multi_dcff_set.mat dcff xms xmf xmi xmn yms ymf ymi ymn;
disp('File name ''multi_dcff_set.mat'' is saved in the current directory');
disp('This file is used for ''expected_seis_rate''');
clear dcff




