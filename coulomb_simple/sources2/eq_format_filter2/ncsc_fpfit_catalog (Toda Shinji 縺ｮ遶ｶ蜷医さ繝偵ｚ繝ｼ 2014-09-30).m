function [outData,pathname,flag] = ncsc_fpfit_catalog
%
%   Read NCSC Fpfit formatted earthquake catalog
%

    flag = 1;
    [filename,pathname] = uigetfile({'*.*'},' Open earthquake file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        disp('  ----- earthquake data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
    end
	myData = textread(fullfile(pathname, filename), '%s', 'delimiter', '\n', 'whitespace', '');
	outData = zeros(length(myData), 15);
nerror = 0;
for i = 1:length(myData)
	try 
            lon_deg = str2double(myData{i}(30:32));
            lon_min = str2double(myData{i}(34:38));
            outData(i,1) = -lon_deg - lon_min/60.0;             % longitude (Western, negative)
            lat_deg = str2double(myData{i}(21:22));
            lat_min = str2double(myData{i}(24:28));
%             myData{i}(23)
            if strcmp(myData{i}(23),'S')
            outData(i,2) = -lat_deg - lat_min/60.0;              % latitude (southern hemisphere)
            else
            outData(i,2) = lat_deg + lat_min/60.0;              % latitude
            end
            outData(i,3) = str2double(myData{i}(1:4));          % Year
            outData(i,4) = str2double(myData{i}(5:6));          % Month
            outData(i,5) = str2double(myData{i}(7:8));          % Day
            outData(i,6) = str2double(myData{i}(49:52));        % Magnitude  
            outData(i,7) = str2double(myData{i}(40:45));        % Depth             
            outData(i,8) = str2double(myData{i}(10:11));        % Hour
            outData(i,9) = str2double(myData{i}(12:13));        % Minute
            outData(i,10) = str2double(myData{i}(84:86));       % Nodal 1: strike                               % Nodal 1: strike
            outData(i,11) = str2double(myData{i}(88:89));       % Nodal 1: dip                                % Nodal 1: dip
            outData(i,12) = str2double(myData{i}(90:93));       % Nodal 1: rake                                % Nodal 1: rake
            outData(i,13) = 0.0;                                % Nodal 2: strike
            outData(i,14) = 0.0;                                % Nodal 2: dip
            outData(i,15) = 0.0;                                % Nodal 2: rake
            if isnan(outData(i,1)) || isnan(outData(i,6))
                nerror = nerror + 1;
            end
    catch
      disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
      nerror = nerror + 1;
    end
      if nerror > 9
          disp('!! Warning !! This may not be a properly formatted ncsc fpfit catalog.');
          flag = 0;
          h = errordlg('This may not be a properly formatted ncsc fpfit catalog.');
          waitfor(h);
          return;
      end
end
  
% fclose(fid);

% z map format
%
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
%