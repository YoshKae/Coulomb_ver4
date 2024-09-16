function [outData,pathname,flag] = neic_catalog_screenformat
%
%   Read NEIC earthquake catalog (screenformat)
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
%             outData(i,1) = str2double(myData{i}(38:44));	% longitude
%             outData(i,2) = str2double(myData{i}(31:36));	% latitude
%             outData(i,3) = str2double(myData{i}(8:11));     % Year
%             outData(i,4) = str2double(myData{i}(15:16));    % Month
%             outData(i,5) = str2double(myData{i}(18:19));	% Day
%             outData(i,6) = str2double(myData{i}(50:53));	% Magnitude  
%             outData(i,7) = str2double(myData{i}(46:48));	% Depth             
%             outData(i,8) = str2double(myData{i}(21:22));	% Hour
%             outData(i,9) = str2double(myData{i}(23:24));	% Minute
            outData(i,1) = str2double(myData{i}(39:45));	% longitude
            outData(i,2) = str2double(myData{i}(32:37));	% latitude
            outData(i,3) = str2double(myData{i}(9:12));     % Year
            outData(i,4) = str2double(myData{i}(16:17));    % Month
            outData(i,5) = str2double(myData{i}(19:20));	% Day
            outData(i,6) = str2double(myData{i}(51:54));	% Magnitude  
            outData(i,7) = str2double(myData{i}(47:49));	% Depth             
            outData(i,8) = str2double(myData{i}(22:23));	% Hour
            outData(i,9) = str2double(myData{i}(24:25));	% Minute
            outData(i,10) = 0.0;                           % Nodal 1: strike
            outData(i,11) = 0.0;                           % Nodal 1: dip
            outData(i,12) = 0.0;                           % Nodal 1: rake
            outData(i,13) = 0.0;                           % Nodal 2: strike
            outData(i,14) = 0.0;                           % Nodal 2: dip
            outData(i,15) = 0.0;                           % Nodal 2: rake
            if isnan(outData(i,1)) || isnan(outData(i,6))
                nerror = nerror + 1;
            end
    catch
      disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
      nerror = nerror + 1;
    end
      if nerror > 9
          disp('!! Warning !! This may not be a properly formatted neic screenformat catalog.');
          flag = 0;
          h = errordlg('This may not be a properly formatted neic screenformat catalog.');
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