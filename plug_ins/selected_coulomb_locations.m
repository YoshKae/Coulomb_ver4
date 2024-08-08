% script to paint gray out of the target area

% CC: coulomb stress matrix
% BACKGROUND_B: background seis rate

junk1 = BACKGROUND_B > 0;
junk2 = BACKGROUND_B <= 0;

limit = -10000;
junk3 = junk1 + junk2.*limit;

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
junk  = junk4.*limit + junk5.*junk3;

% CC_CHOSEN = flipud(CC).*junk;
% csep_graphic('test',LON_GRID,LAT_GRID,target,5);

clear junk1 junk2 junk3 junk4 junk5 limit xs ys xf yf tempxy dist i k m dd
