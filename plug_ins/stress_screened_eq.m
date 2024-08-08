function [junk] = stress_screened_eq(eq_data,cc,backgrd,longrid,latgrid,XGRID,YGRID,lower,upper)

i = size(eq_data,1);
min_mag = 0.0;

junk1 = backgrd > 0;
junk2 = backgrd <= 0;

% limit = -100000;
% junk3 = junk1 + junk2.*limit;

tempxy = zeros(100,2);
xs = -0.71;  ys = 6.1;
xf = 0.85; yf = -11.83;

dist = 5; % km

for i = 1:100
    tempxy(i,1) = xs - ((xs-xf)/100)*i;
    tempxy(i,2) = ys - ((ys-yf)/100)*i;
end

inddist = zeros(length(YGRID),length(XGRID));
for k = 1:length(XGRID)
    for m = 1:length(YGRID)
        for i = 1:100
        dd = sqrt((XGRID(k)-tempxy(i,1))^2+(YGRID(m)-tempxy(i,2))^2);
        if dd < dist
            inddist(m,k) = 1;
            break
        end
        end
    end
end

junk4 = inddist > 0;
junk5 = inddist <= 0;
% junk  = junk4.*limit + junk5.*junk3;
junk  = junk5.*junk1;
%

cc = flipud(cc).*junk;

loninc = abs(longrid(2) - longrid(1));
latinc = abs(latgrid(2) - latgrid(1));
fid = fopen('screened_eq.dat','wt');

for k = 1:length(eq_data)
%     n = int32(abs(eq_data(k,1) - longrid(1)) / loninc)+1;
%     m = int32(abs(eq_data(k,2) - latgrid(1)) / latinc)+1;
    n = int32(abs(eq_data(k,1) - longrid(1)) / loninc)+1;
    m = int32(abs(eq_data(k,2) - latgrid(1)) / latinc)+1;
    if cc(m,n) ~= 0.0 % in case
    if cc(m,n) > lower
        if cc(m,n) < upper
        if size(eq_data(k,:),2)==17
            if eq_data(k,6) >= min_mag
        fprintf(fid,...
         '%10.5f %9.5f %4i %2i %2i %3.1f %6.2f %2i %2i %3i %2i %4i %3i %2i %4i',...
          eq_data(k,1),eq_data(k,2),floor(eq_data(k,3)),eq_data(k,4),eq_data(k,5),...
          eq_data(k,6),eq_data(k,7),eq_data(k,8),eq_data(k,9),...
          eq_data(k,10),eq_data(k,11),eq_data(k,12),...
          eq_data(k,13),eq_data(k,14),eq_data(k,15));
        fprintf(fid,' \n');
            end
        else
            if eq_data(k,6) >= min_mag
        fprintf(fid,...
         '%10.5f %9.5f %4i %2i %2i %3.1f %6.2f %2i %2i',...
          eq_data(k,1),eq_data(k,2),floor(eq_data(k,3)),eq_data(k,4),eq_data(k,5),...
          eq_data(k,6),eq_data(k,7),eq_data(k,8),eq_data(k,9));
        fprintf(fid,' \n');
            end
        end
        end
    end
    end
end

fclose(fid);

% z map format
%
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2