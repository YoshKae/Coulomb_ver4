function coulomb_cui(varargin)
% This is CUI based simple Coulomb program
% Input file is shared with the GUI based program (Coulomb 3.3)
%
% Syntax:
%   coulomb_cui('sourceFileName','your input file name',...
%               'calcFunction','deformation' or 'coulomb' or 'batch',...
% Output: 'calcFunction','deformation' ---> halfspace_def_out.dat
%         'calcFunction','coulomb' ---> coulomb_out.dat
%         'calcFunction','batch' ---> coulomb_out.dat
% Example:
%
%   coulomb_cui('sourceFileName','Example-1.inp','calcFunction','deformatio
%   n)
%
%   coulomb_cui('sourceFileName','Example-1.inp','calcFunction','coulomb','
%   receiver','100/90/180'); % 100 is strike, 90 is dip, and 180 is rake in
%   degrees
%
%   coulomb_cui('sourceFileName','Example-1.inp','calcFunction','batch','ba
%   tchFileName','Test_batch.dat')
%   see the format of the batch file in 'batch_test.dat'.


AuthorizedOptions = {'sourceFileName',...
                     'calcFunction',...
                     'receiver',...
                     'batchFileName'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end

% default option
sourceFileName = 'test.dat';
calcFunction   = 'deformation';
receiver       = '30/90/180';
batchFileName  = 'test.dat';

v = ge_parse_pairs(varargin);
for j = 1:length(v)
    eval(v{j});
end


% input file open
[xvec,yvec,z,el,kode,pois,young,cdepth,fric,rstress] = open_input_file_cui(sourceFileName);

if strcmp(calcFunction,'deformation')
%--------------------------------------------
%       function 'deformation'
%--------------------------------------------
% calc in elastic half space of Okada (1992)
[dc3d] = okada_elastic_halfspace(xvec,yvec,el,young,pois,cdepth,kode);
fout = 'halfspace_def_out.dat';
fid = fopen(fout,'wt');
fprintf(fid,'x y z ux uy uz sxx syy szz syz sxz sxy\n');
fprintf(fid,'(km) (km) (km) (m) (m) (m) (bar) (bar) (bar) (bar) (bar) (bar)\n');
for i = 1:size(dc3d,1)
fprintf(fid,'%10.4f',dc3d(i,1:2)); fprintf(fid,'%10.4f',dc3d(i,5:14));
fprintf(fid,' \n');
end
fclose(fid);

elseif strcmp(calcFunction,'coulomb')
%--------------------------------------------
%       function 'coulomb'
%--------------------------------------------
% calc in elastic half space of Okada (1992)
[dc3d] = okada_elastic_halfspace(xvec,yvec,el,young,pois,cdepth,kode);
a = findstr(receiver,'/');
strike_m   =  str2double(receiver(1:a(1)-1)) * ones(size(dc3d,1),1);
dip_m      =  str2double(receiver(a(1)+1:a(2)-1)) * ones(size(dc3d,1),1);
rake_m     = str2double(receiver(a(2)+1:end))  * ones(size(dc3d,1),1);
friction_m =  fric * ones(size(dc3d,1),1);
[shear,normal,coulomb] = calc_coulomb(strike_m,dip_m,rake_m,friction_m,...
                       dc3d(:,9:14)');
fout = 'coulomb_out.dat';
fid = fopen(fout,'wt');
fprintf(fid,'x y z strike dip rake shear normal coulomb\n');
fprintf(fid,'(km) (km) (km) (deg) (deg) (deg) (bar) (bar) (bar)\n');
for i = 1:size(dc3d,1)
fprintf(fid,'%10.4f',dc3d(i,1:2)); fprintf(fid,'%10.4f',dc3d(i,5));...
fprintf(fid,'%7.1f',strike_m(i,1));
fprintf(fid,'%6.1f',dip_m(i,1));
fprintf(fid,'%8.1f',rake_m(i,1));
fprintf(fid,'%10.4f',shear(i,:));
fprintf(fid,'%10.4f',normal(i,:));...
fprintf(fid,'%10.4f',coulomb(i,:));...
fprintf(fid,' \n');
end
fclose(fid);

else
%--------------------------------------------
%       function 'batch'
%--------------------------------------------
[pos,strike_m,dip_m,rake_m] = open_batch_file(batchFileName);
dc3d    = zeros(size(pos,1),14);
shear   = zeros(size(pos,1),1);
normal  = zeros(size(pos,1),1);
coulomb = zeros(size(pos,1),1);
for i = 1:size(pos,1)
% calc in elastic half space of Okada (1992)
[dc3d(i,:)] = okada_elastic_halfspace(pos(i,1),pos(i,2),el,young,pois,-pos(i,3),kode);
[shear(i,:),normal(i,:),coulomb(i,:)] = calc_coulomb(strike_m(i,1),dip_m(i,1),rake_m(i,1),fric,...
                       dc3d(i,9:14)');
end
fout = 'coulomb_out.dat';
fid = fopen(fout,'wt');
fprintf(fid,'x y z strike dip rake shear normal coulomb\n');
fprintf(fid,'(km) (km) (km) (deg) (deg) (deg) (bar) (bar) (bar)\n');
for i = 1:size(dc3d,1)
fprintf(fid,'%10.4f',dc3d(i,1:2)); fprintf(fid,'%10.4f',dc3d(i,5));...
fprintf(fid,'%7.1f',strike_m(i,1));
fprintf(fid,'%6.1f',dip_m(i,1));
fprintf(fid,'%8.1f',rake_m(i,1));
fprintf(fid,'%10.4f',shear(i,1));
fprintf(fid,'%10.4f',normal(i,1));...
fprintf(fid,'%10.4f',coulomb(i,1));...
fprintf(fid,' \n');
end
fclose(fid);

end

