% cumN vs dCFF

THS = 0.108;
ind = find(CC ~= 0);
N   = numel(CC(ind));
% CCV  = sort(real(log10(reshape(CC(ind),N,1))));
CCV  = sort(reshape(CC(ind),N,1));
tind = CCV <= THS; Nths = sum(tind);
nx = 1:1:N;
figure; hold on;
plot(nx,CCV)
xlim([1 N]); xlabel('Cumulative number of map cells');
% ylim([-5 3]); ylabel('Log10 Coulomb stress change (bar)');
ylim([-20 20]); ylabel('Coulomb stress change (bar)');
% line([Nths Nths],[-5 3])
line([Nths Nths],[-20 20])
Nths/N

