function [outData,pathname,flag] = usgs_csv
%
%   Read southern california earthquake center catalog
%

    flag = 1; % data is properly read (flag = 0, not properly read)
    [filename,pathname] = uigetfile({'*.*'},'Open earthquake file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        disp('  ----- earthquake data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
    end
    fileID = fopen(fullfile(pathname, filename));
	myData = textscan(fileID, '%s %f %f %f %f %s %s %s %s %s %s %s %*[^\n]','Delimiter',',',...
	'HeaderLines',1)
    fclose(fileID);
    
    
%     fileID = fopen(fullfile(pathname, filename));
% myData = textscan(fileID,'%s %f %f %f %f %s %s %s %s %s %s %s %*[^\n]','Delimiter',',',...
%     'HeaderLines',1);
% fclose(fileID);
    
n = length(myData{1})
outData = zeros(n,15);

for i = 1:n
	outData(i,1) = myData{3}(i);	% longitude
	outData(i,2) = myData{2}(i);	% latitude
    date         = char(string(myData{1}(i)));
	outData(i,3) = str2double(date(1:4));     % Year
	outData(i,4) = str2double(date(6:7));    % Month
	outData(i,5) = str2double(date(9:10)); 	% Day
	outData(i,6) = myData{5}(i);	% Magnitude  
	outData(i,7) = myData{4}(i);	% Depth             
	outData(i,8) = str2double(date(12:13));	% Hour
	outData(i,9) = str2double(date(15:16));	% Minute
%     cmp = [outData(i,3:5) outData(i,8:9)] == [zmapin(1,3:5) zmapin(1,8:9)];
%     if sum(cmp')==5
%         nid = i;
%     end
end
    return
  