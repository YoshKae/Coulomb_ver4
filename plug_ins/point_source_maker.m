%POINT_SOURCE_MAKER
%
% To make point sources for input file from EQ_DATA
%
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------
if isempty(EQ_DATA)
    disp('No EQ data available');
    return
end

% each M should be coverted to Mw using some formula
mag_threshold = 3.0;

% check focal mechanism
check1 = sum(EQ_DATA(:,10)) + sum(EQ_DATA(:,11)) + sum(EQ_DATA(:,12));
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check1 == 0
	warndlg('No focal mechanism data available in this catalog','!! Warning !!');
	return
else
    if check2 == 0
	h = questdlg('Only one nodal plane data set. Do you want to make the other set?',' ','Yes','No','Cancel');
    switch h
        case 'Yes'
%            hc = wait_calc_window;   % custom waiting dialog
            out = nodal_plane_calc(EQ_DATA(:,10),EQ_DATA(:,11),EQ_DATA(:,12));
            EQ_DATA(:,13) = out(:,1);
            EQ_DATA(:,14) = out(:,2);
            EQ_DATA(:,15) = out(:,3);
            EQ_DATA(:,10) = out(:,4);
            EQ_DATA(:,11) = out(:,5);
            EQ_DATA(:,12) = out(:,6);
%            close(hc);
        case 'No'
            warndlg('Do not calc. for nodal plane 2.','!! Warning !!');
    end
    end
end

% ======== screening & re-arranging ================
% global ID KODE ELEMENT
% global FCOMMENT
% global NUM
% turnout of all fault related parameters temporally
[m,n] = size(ELEMENT); temp_element = zeros(m,n);
temp_element = ELEMENT;
[m,n] = size(KODE); temp_kode = zeros(m,n);
temp_kode = KODE;
[m,n] = size(ID); temp_id = zeros(m,n);
temp_id = ID;
temp_num = NUM;

[m,n] = size(EQ_DATA);
% shear modulus
g = YOUNG/(2.0*(1.0+POIS));
counter = 0;
for k = 1:m
    if EQ_DATA(k,6) >= mag_threshold
        counter = counter + 1;
        % (Nm) Mw = (2/3)*(logMo-9.1)
        % (dyncm) Mw = (2/3)*(logMo-16.1)
            mo = power(10,(EQ_DATA(k,6) * 1.5 + 9.1));
            po = mo/(g*100000.0);          % all potency
        % KODE
            KODE(counter,1) = 400;
            ID(counter,1)   = 1;
            if EQ_DATA(k,4) < 10
                d1 = ['/0' num2str(EQ_DATA(k,4))];
            else
                d1 = ['/' num2str(EQ_DATA(k,4))];           
            end
            if EQ_DATA(k,5) < 10
                d2 = ['/0' num2str(EQ_DATA(k,5))];
            else
                d2 = ['/' num2str(EQ_DATA(k,5))];                
            end
            FCOMMENT(counter).ref = [num2str(EQ_DATA(k,3)) d1 d2 ' M=' num2str(EQ_DATA(k,6))];
            if rand <= 0.5
                strike = EQ_DATA(k,10);
                dip    = EQ_DATA(k,11);
                rake   = EQ_DATA(k,12);
                   ttl = EQ_DATA(k,10) + EQ_DATA(k,11) + EQ_DATA(k,12); % insurance
                   if ttl == 0.0
                        strike = EQ_DATA(k,13);
                        dip    = EQ_DATA(k,14);
                        rake   = EQ_DATA(k,15);
                   end
            else
                strike = EQ_DATA(k,13);
                dip    = EQ_DATA(k,14);
                rake   = EQ_DATA(k,15);
                   ttl = EQ_DATA(k,13) + EQ_DATA(k,14) + EQ_DATA(k,15); % insurance
                   if ttl == 0.0
                        strike = EQ_DATA(k,10);
                        dip    = EQ_DATA(k,11);
                        rake   = EQ_DATA(k,12);
                   end
            end           
            p1 =  po * (-1.0) * cos(deg2rad(rake));       % pontency of strike-slip direction
            p2 =  po * sin(deg2rad(rake));                % pontency of dip-slip direction
            pp = abs(p1) + abs(p2);
            ratio = pp/po;
%                 escapediv = 0.00001;
%                 if pp < escapediv
%                     pp = escapediv;
%                 end
            p1r = p1/pp;
            p2r = p2/pp;
            po_strike =  po * p1r;                  % pontency of strike-slip direction
            po_dip    =  po * p2r;                  % pontency of dip-slip direction
            xinc = 1.0 * sin(deg2rad(strike));
            yinc = 1.0 * cos(deg2rad(strike));
            ELEMENT(counter,1) = EQ_DATA(k,16) - xinc;
            ELEMENT(counter,2) = EQ_DATA(k,17) - yinc; 
            ELEMENT(counter,3) = EQ_DATA(k,16) + xinc;
            ELEMENT(counter,4) = EQ_DATA(k,17) + yinc;
%             ELEMENT(counter,5) = po_strike;
%             ELEMENT(counter,6) = po_dip; 
            ELEMENT(counter,5) = p1/ratio;
            ELEMENT(counter,6) = p2/ratio; 
            ELEMENT(counter,7) = dip;
            ELEMENT(counter,8) = EQ_DATA(k,7) - 1.0;
            if ELEMENT(counter,8) < 0.0
                ELEMENT(counter,8) = 0.0;
            end
            ELEMENT(counter,9) = EQ_DATA(k,7) + 1.0;        
    end
end
NUM = counter;

% ***** save ascii input file ****************
    if isempty(PREF_DIR) ~= 1
        try
            cd(PREF_DIR);
        catch
            cd(HOME_DIR);
        end
    else
        try
            cd('input_files');
        catch
            cd(HOME_DIR);
        end    
    end
    [filename,pathname] = uiputfile('*.inp',...
        ' Save Input File As');
    if isequal(filename,0) | isequal(pathname,0)
        disp('User selected Cancel')
    else
        disp(['User saved as ', fullfile(pathname,filename)])
    end
    cd(pathname);
    input_save_ascii;
    cd(HOME_DIR);
% *********************************************

% return to normal
[m,n] = size(temp_element); ELEMENT = zeros(m,n);
ELEMENT = temp_element;
[m,n] = size(temp_kode); KODE = zeros(m,n);
KODE = temp_kode;
[m,n] = size(temp_id); ID = zeros(m,n);
ID = temp_id;
FCOMMENT = [];
NUM = temp_num;

