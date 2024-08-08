function coulomb2gmt_meca
% coulomb2gmt_meca
% 
%  convert coulomb output ascii column file to gmt formatted xyz file
%
% /output_files/dcff.cou

% gmtset MEASURE_UNIT inch
% pscoast -JM6 -R134/145/32/43 -B5 -Df -G150 -Na -W -L136/32.7/32.7/100 -P -K -G220/220/220 -X0.9 > out.ps
% psxy -R -JM -: -W2/255/0/1 -M -P -O -K fault_data/afault.dat >> out.ps
% psmeca << END -JM -R -Sc0.17 -G2/5/225 -CP0.03 -P -O >> out.ps


pathname   = 'output_files';
input_file = 'dcff.cou';
output_file = 'opt.gmt';

t1 = 'gmtset MEASURE_UNIT inch';
t2 = 'pscoast -JM6 -R';
t3 = ' -B5 -Df -G150 -Na -W -L136/32.7/32.7/100 -P -K -G220/220/220 -X0.9 > out.ps';
t4 = 'psmeca << END -JM -R -Sc0.17 -G2/5/225 -CP0.03 -P -O >> out.ps';

fid = fopen(fullfile(pathname, input_file),'r');
a = textscan(fid,'%s %s %s %s %s %s %s %s %s','HeaderLines',3);
fclose(fid);

b = [a{:}];

% x y z coulomb shear normal opt-oriented-strike dip rake
% (km) (km) (km) (bar) (bar) (bar) (degree) (degree) (degree)
% -621.583801	-555.974609	10.000000	0.003201	0.004230	-0.002574	190.000000	30.000000	90.000000

c = xy2lonlat([str2double(b(:,1)) str2double(b(:,2))]);

% #longitude latitude depth strike1 dip1 rake1(slip1) strike2 dip2 rake2(slip2) "mo(Nm) * 10^7" X Y text(origin_time(JST))
% 139.0252 35.1802 35 31 70 102 179 23 60 1.40 27 0 0 2011/03/11,15:08
d = nodal_plane_calc(str2double(b(:,7)),str2double(b(:,8)),str2double(b(:,9)));
% function [outsdr] = nodal_plane_calc(st1,dp1,rk1)
%          dimension sdr(3), p(2),t(2),b(2),ptb(6),dum1(3),dum2(3),dum3(3)
%          write(6,'(a,$)') 'INPUT (strike,dip,rake)-->   '
%          read(5,*) sdr(1),sdr(2),sdr(3)
% Original code was written by Hiroshi Tsuruoka, ERI, Univ. Tokyo in
% FORTRAN

e = [c(:,1) c(:,2) str2double(b(:,3)) d(:,1) d(:,2) d(:,3) d(:,4) d(:,...
    5) d(:,6) 1.5.*ones(size(c,1),1) 22.*ones(size(c,1),1) zeros(size(c,1),...
    1) zeros(size(c,1),1)];

fid = fopen(output_file,'wt');
for n = 1:size(e,1)
fprintf(fid,'%15.3f %15.3f  %15.3f %4i %4i %4i %4i %4i %4i %5.2f %4i %4i %4i\n',e(n,:));
end
fclose(fid);