function [outData,pathname,flag] = nied_fnet_catalog
%
%   Read NIED f-net earthquake catalog which includes focal mechanism data
%
    flag = 1;
    [filename,pathname] = uigetfile({'*.*'},' Open input file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        disp('  ----- earthquake data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
        try
            fid = fopen(fullfile(pathname, filename),'r');              % for ascii file
        catch
            errordlg('The file might be corrupted or wrong one');
            return;
        end
    end
    n = 1000000; % temporal
    myData = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
    outData = zeros(length(myData{1}(:)),15);
    nerror = 0;
    for i = 1:length(myData{1}(:))
        try
        temp = char(myData{1}(i));
        outData(i,3) = str2num(temp(1:4));      % Year          
        outData(i,4) = str2num(temp(6:7));      % Month
        outData(i,5) = str2num(temp(9:10));     % Day
        outData(i,8) = str2num(temp(12:13));	% Hour
        outData(i,9) = str2num(temp(15:16));	% Min
        outData(i,2) = str2num(char(myData{2}(i)));      % Latitude
        outData(i,1) = str2num(char(myData{3}(i)));      % Longitude
        outData(i,7) = str2num(char(myData{4}(i)));      % Depth
        outData(i,6) = str2num(char(myData{5}(i)));      % Mw
%         outData(i,10) = str2num(char(myData{9}(i)));      % Strike-1
%         outData(i,11) = str2num(char(myData{10}(i)));       % Dip-1
%         outData(i,12) = str2num(char(myData{11}(i)));       % Rake-1
%         outData(i,13) = str2num(char(myData{12}(i)));      % Strike-2
%         outData(i,14) = str2num(char(myData{13}(i)));       % Dip-2
%         outData(i,15) = str2num(char(myData{14}(i)));       % Rake-2
        temps = char(myData{7}(i));	ns = findstr(temps,';'); 
        tempd = char(myData{8}(i));	nd = findstr(tempd,';');
        tempr = char(myData{9}(i));	nr = findstr(tempr,';');
        outData(i,10) = str2num(temps(1:ns-1));         % Strike-1
        outData(i,11) = str2num(tempd(1:nd-1));         % Dip-1
        outData(i,12) = str2num(tempr(1:nr-1));         % Rake-1
        outData(i,13) = str2num(temps(ns+1:end));       % Strike-2
        outData(i,14) = str2num(tempd(nd+1:end));       % Dip-2
        outData(i,15) = str2num(tempr(nr+1:end));       % Rake-2
        catch
        disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
        nerror = nerror + 1;
        end
        if nerror > 999
          disp('!! Warning !! This may not be a properly formatted NIED F-net catalog.');
          flag = 0;
          h = errordlg('This may not be a properly formatted NIED F-net catalog.');
          waitfor(h);
          return;
        end
    end
% %------ EQ_ZFORMAT_DATA format (17 columns) -----------------------
% % 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% % 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% %------------------------------------------------------------------
