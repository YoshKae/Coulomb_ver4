function[outData,pathname,flag] = nied_hinet_auto_catalog
%
%   Read NIED hi-net earthquake catalog which includes focal mechanism data
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
    myData = textscan(fid,'%s %s %s %s %s %s %s %s %s %s',n);
    outData = zeros(length(myData{1}(:)),15);
    nerror = 0;
    for i = 1:length(myData{1}(:))
        try
        temp = char(myData{1}(i));
        outData(i,3) = str2num(temp(1:4));      % Year          
        outData(i,4) = str2num(temp(6:7));      % Month
        outData(i,5) = str2num(temp(9:10));     % Day
        temp = char(myData{2}(i));
        outData(i,8) = str2num(temp(1:2));	% Hour
        outData(i,9) = str2num(temp(4:5));	% Min
        outData(i,2) = str2num(char(myData{4}(i)));      % Latitude
        outData(i,1) = str2num(char(myData{6}(i)));      % Longitude
        outData(i,7) = str2num(char(myData{8}(i)));      % Depth
        outData(i,6) = str2num(char(myData{10}(i)));      % Mw
        outData(i,10) = 0.0;         % Strike-1
        outData(i,11) = 0.0;         % Dip-1
        outData(i,12) = 0.0;         % Rake-1
        outData(i,13) = 0.0;       % Strike-2
        outData(i,14) = 0.0;       % Dip-2
        outData(i,15) = 0.0;       % Rake-2
        catch
        disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
        nerror = nerror + 1;
        end
        if nerror > 9
          disp('!! Warning !! This may not be a properly formatted Hi-net auto catalog.');
          flag = 0;
          h = errordlg('This may not be a properly formatted Hi-net auto catalog.');
          waitfor(h);
          return;
        end
    end
% %------ EQ_ZFORMAT_DATA format (17 columns) -----------------------
% % 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% % 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% %------------------------------------------------------------------
