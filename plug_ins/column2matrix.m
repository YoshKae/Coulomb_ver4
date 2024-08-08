function column2matrix
% This function changes coulomb-style text column output file to a matrix
% style .mat file

disp('This function converts the text column coulomb output file into a matrix file.');
disp('First, please select which column should be converted into the matrix.');
disp(' ');
reply = input('1. Coulomb stress, 2. Shear stress, 3. normal stress? Type the number ','s');
if isempty(reply)
    reply = '1';
end
i = int8(str2double(reply)) + 3;

% INPUT
try
    cd('output_files');
catch
    cd(pwd);
end
[filename,pathname] = uigetfile({'*.*'},' Open Coulomb stress text column file');
if isequal(filename,0)
        disp('  User selected Cancel');
        return;
else
        disp('  ----- Delata CFF file -----');
        disp(['  User selected', fullfile(pathname, filename)]);
        fid = fopen(fullfile(pathname, filename),'r');
        try
            try
            coul = textscan(fid,'%f %f %f %f %f %f','headerlines',3);
            catch
            coul = textscan(fid,'%f %f %f %f %f %f %f %f %f','headerlines',3);
            end
        catch
            disp('This is not properly formatted coulomb file.');
            return
        end
        fclose (fid);
        xx = [coul{1}]; yy = [coul{2}];
        yms = min(yy); ymf = max(yy); ymi = abs(yy(2)-yy(1)); ymn = int32((ymf-yms)/ymi)+1;
        xms = min(xx); xmf = max(xx); xmi = abs(xx(ymn+1)-xx(ymn)); xmn = int32((xmf-xms)/xmi)+1;
                cl= zeros(ymn,xmn,'double');
                cl = reshape(coul{i},ymn,xmn);
                cl = cl(ymn:-1:1,:);
end

% OUTPUT
cdir = pwd;
[filename,pathname] = uiputfile('*.mat',' Save the converted matrix file as');
    if isequal(filename,0) | isequal(pathname,0)
        disp('User selected Cancel')
    else
        disp(['User saved as ', fullfile(pathname,filename)])
    end
    save(fullfile(pathname,filename), 'cl',...
        '-mat');
cd(cdir);
