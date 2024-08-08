function [flag] = coulomb_registration_check
user_act1  = sum(license);
serial_sum = 419;
user_act   = user_act1 + serial_sum;
abi = 0;
homedir = pwd;


flag = 'in'; % default


try
cd license    
if exist('my_personal_license.txt') 
   abi = textread('my_personal_license.txt');
else
   answer = inputdlg('Enter 8 digit serial number.','Serial Number');
   user_serial = [answer{:}];
   sum(user_serial);
   if sum(user_serial)==serial_sum
        abi = sum(user_serial) + user_act1;
        save my_personal_license.txt abi -ascii
   else
       flag = 'out';
       cd homedir
       return
   end
end
cd ..

if abi ~= user_act
    cd license
        answer = inputdlg('Enter 8 digit serial number.','Serial Number');
        user_serial = [answer{:}];
        sum(user_serial);
        abi = sum(user_serial) + user_act1;
        save my_personal_license.txt abi -ascii
    cd ..
    if abi ~= user_act
    disp(' ');
    disp('A proler license file is not found. To use Coulomb, you need a serial number first.');
    disp('Send email to Volkan Sevilgen <vsevilgen@usgs.gov> to get the number');
    flag = 'out';
    return
    end
else
    flag = 'in';
end

catch
    cd homedir
end
