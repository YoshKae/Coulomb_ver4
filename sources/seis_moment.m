%----- calc Moment -------------------------
check = max(KODE);
if check == 100     % moment can be calcualted only if KODE = 100
    amo = 0.0;
    for k = 1:NUM
        shearmod = YOUNG / (2.0 * (1.0 + POIS));
        flength = sqrt((ELEMENT(k,1)-ELEMENT(k,3))^2+(ELEMENT(k,2)-ELEMENT(k,4))^2);
        hfault = ELEMENT(k,9) - ELEMENT(k,8);
        wfault = hfault / sin(deg2rad(ELEMENT(k,7)));
        slip = sqrt(ELEMENT(k,5)^2.0 + ELEMENT(k,6)^2.0);
        smo = shearmod * flength * wfault * slip * 1.0e+18;
        amo = amo + smo;
    end
    % mw = (2/3) * (log10(amo)-16.1);
    mw = (2/3) * log10(amo) - 10.7;
    disp(['   Total seismic moment = ' num2str(amo,'%6.2e') ' dyne cm (Mw = ', num2str(mw,'%4.2f') ')']);
%    disp(amo);
end
