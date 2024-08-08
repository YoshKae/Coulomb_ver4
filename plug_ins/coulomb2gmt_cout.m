function coulomb2gmt_cout
% coulomb2gmt_cout
% 
%  convert coulomb output ascii column file to gmt formatted xyz file
%
% /output_files/dcff.cou

pathname   = 'output_files';
input_file = 'dcff.cou';
output_file = 'coulomb_out.dat';
fid = fopen(fullfile(pathname, input_file),'r');
a = textscan(fid,'%s %s %s %s %s %s %s','HeaderLines',3);
fclose(fid);

b = [a{:}];
c = xy2lonlat([str2double(b(:,1)) str2double(b(:,2))]);
d = [c(:,1) c(:,2) str2double(b(:,4))];

fid = fopen(output_file,'wt');
for n = 1:length(d)
fprintf(fid,'%15.3f %15.3f %15.7f\n',d(n,:));
end
fclose(fid);