function [] = coulomb_registration
disp('Registration is free but requires an internet connection.');
disp('We will only use this information to argue for additional ');
disp('support from funding agencies; we will NOT give your email');
disp('address to anyone.')
user_firstname = input('Firstname = ', 's');    user_firstname = strrep(user_firstname,' ','_');
user_lastname = input('Lastname = ', 's');      user_lastname  = strrep(user_lastname,' ','_');
user_email = input('Email = ', 's');
user_ins = input('Institution = ', 's');        user_ins       = strrep(user_ins,' ','_');
user_cnt = input('Country = ', 's');            user_cnt       = strrep(user_cnt,' ','_');
reply = input('Agree to send the above information to us (type y) or change them (type n)?:','s');
if isempty(reply)
    reply = 'n';
end
switch reply
    case 'n'
        coulomb_registration;
    otherwise
        user_act1 = double(license);
        user_act = int2str(sum(user_act1));
        user_url = ['http://www.dijitalpazar.com.tr/usgsreg.php?ad=' user_firstname '&soyad='...
            user_lastname '&email=' user_email '&act=' user_act '&ins=' user_ins '&cnt=' user_cnt];

[f,status] = urlread(user_url);
if status == 0
    error('Registration process needs an internet connection. Please check your internet connection');
else
    disp(f);
    cd license;
    dlmwrite('my_personal_license.txt', user_act, 'delimiter','');
    cd ..
end
end
