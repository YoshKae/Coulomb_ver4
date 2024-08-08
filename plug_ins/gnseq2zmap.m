function gns2zmap
%
%   Read GNS Science Focal Mech csv file, and then convert it into zmap
%   format file
%
%   before applying this function, please replace 'p' in the catalog to '0'
%

    flag = 1; % data is properly read (flag = 0, not properly read)
    [filename,pathname] = uigetfile({'*.*'},' Open input file');
    if isequal(filename,0)
%        disp('  User selected Cancel');
        return
    else
        disp('  ----- earthquake data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
    end
%	myData = csvread(fullfile(pathname, filename),1,0);

  % nerror = 0;
  
  
    T = readtable(fullfile(pathname, filename),'Delimiter',',');
    n = height(T);
    outData = zeros(int32(height(T)), 9,'double');
    % publicid,eventtype,origintime,modificationtime,longitude, latitude, magnitude, depth,...
    % magnitudetype,depthtype,evaluationmethod,evaluationstatus,evaluationmode,earthmodel,usedphasecount,usedstationcount,magnitudestationcount,minimumdistance,azimuthalgap,originerror,magnitudeuncertainty

T.Properties.VariableNames={'publicid' ...
    'eventtype' 'origintime' 'modificationtime' 'longitude' ...
    'latitude' 'magnitude' 'depth' 'magnitudetype' 'depthtype' ...
    'evaluationmethod' 'evaluationstatus' 'evaluationmode' ...
    'earthmodel' 'usedphasecount' 'usedstationcount' ...
    'magnitudestationcount' 'minimumdistance' 'azimuthalgap' ...
    'originerror' 'magnitudeuncertainty'};

times = char(T.origintime);
% 2018-07-10T01:07:18.259Z
        outData(:,3) = str2num(times(:,1:4));        % Year
        outData(:,4) = str2num(times(:,6:7));      % Month
        outData(:,5) = str2num(times(:,9:10));      % Day
        outData(:,8) = str2num(times(:,12:13));      % hour
        outData(:,9) = str2num(times(:,15:16));      % minute
        outData(:,1) = T.longitude;
        outData(:,2) = T.latitude;
        outData(:,6) = T.magnitude;
        outData(:,7) = T.depth;

%   for i = 1:n
%              times(i,:)   = num2str(myData(i,3));
%              outData(i,3) = str2num(times(i,1:4));        % Year
%              outData(i,4) = str2num(times(i,6:7));      % Month
%              outData(i,5) = str2num(times(i,9:10));      % Day
%              outData(i,8) = str2num(times(i,12:13));      % hour
%              outData(i,9) = str2num(times(i,15:16));      % minute
%              outData(i,2) = myData(i,6);      % Latitude  
%              outData(i,1) = myData(i,5);      % Longitude 
%              outData(i,6) = myData(i,7);      % Local magnitude (not Mw)
%              outData(i,7) = myData(i,8);      % Depth
% 
%   end
fid = fopen('out.dat','wt');
for j = 1:n
    if outData(j,1)<0.0
        outData(j,1) = outData(j,1)+360.0;
    end
fprintf(fid,'%10.4f %10.4f %4i %2i %2i %3.1f %6.2f %2i %2i %3i %2i %4i',...
    outData(j,1),outData(j,2),outData(j,3),outData(j,4),outData(j,5),...
    outData(j,6),outData(j,7),outData(j,8),outData(j,9));
fprintf(fid,' \n');
end
fclose(fid);


  
%------ EQ_ZFORMAT_DATA format (17 columns) -----------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
%------------------------------------------------------------------
