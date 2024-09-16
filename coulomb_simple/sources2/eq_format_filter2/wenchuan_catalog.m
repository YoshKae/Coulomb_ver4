% function [uOutput,pathname] = wenchuan_catalog
%
%   Read Japan Meteorological Agency (JMA) data earthquake catalog
%

    [filename,pathname] = uigetfile({'*.*'},' Open earthquake file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        disp('  ----- earthquake data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
    end
	myData = textread(fullfile(pathname, filename), '%s', 'delimiter', '\n', 'whitespace', '');
	uOutput = zeros(length(myData), 15,'double');
nerror = 0;
for i = 1:length(myData)
	try 
            uOutput(i,1)  = str2double(myData{i}(31:36));              % longitude
            uOutput(i,2)  = str2double(myData{i}(24:28));             % latitude
            uOutput(i,3)  = str2double(myData{i}(1:4));        % Year
            uOutput(i,4)  = str2double(myData{i}(6:7));        % Month
            uOutput(i,5)  = str2double(myData{i}(9:10));       % Day
            uOutput(i,6)  = str2double(myData{i}(50:52));      % Magnitude  
            uOutput(i,7)  = str2double(myData{i}(38:40));      % Depth             
            uOutput(i,8)  = str2double(myData{i}(12:13));      % Hour
            uOutput(i,9)  = str2double(myData{i}(15:16));      % Minute
            uOutput(i,10) = str2double(myData{i}(18:21));      % second
            uOutput(i,11) = 0.0;                           % Nodal 1: dip
            uOutput(i,12) = 0.0;                           % Nodal 1: rake
            uOutput(i,13) = 0.0;                           % Nodal 2: strike
            uOutput(i,14) = 0.0;                           % Nodal 2: dip
            uOutput(i,15) = 0.0;                           % Nodal 2: rake
      % Create decimal year
      uOutput(i,3) = decyear([uOutput(i,3) uOutput(i,4) uOutput(i,5) uOutput(i,8) uOutput(i,9)  uOutput0(i,10)]);
            if isnan(uOutput(i,1)) || isnan(uOutput(i,6))
                nerror = nerror + 1;
            end
    catch
%       disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
%       nerror = nerror + 1;
    end
%       if nerror > 9
%           disp('!! Warning !! This may not be a properly formatted ncsc readable catalog.');
%           h = errordlg('This may not be a properly formatted ncsc readable catalog.');
%           waitfor(h);
%           return;
%       end
end





% z map format
%
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
%