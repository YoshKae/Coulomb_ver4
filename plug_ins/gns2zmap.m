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
	myData = csvread(fullfile(pathname, filename),1,0);
	outData = zeros(int32(size(myData,1)), 15,'double');
%     times = zeros(int32(size(myData,1)), 1,'int32');
%     	outData = zeros(int32(length(myData)/5), 15,'double');
  nerror = 0;

  for i = 1:length(myData)
             times(i,:)   = num2str(myData(i,2));
             outData(i,3) = str2num(times(i,1:4));        % Year
             outData(i,4) = str2num(times(i,5:6));      % Month
             outData(i,5) = str2num(times(i,7:8));      % Day
             outData(i,8) = str2num(times(i,9:10));      % hour
             outData(i,9) = str2num(times(i,11:12));      % minute
             outData(i,2) = myData(i,3);      % Latitude 
             outData(i,1) = myData(i,4);      % Longitude 
             if outData(i,1) < 0.0
                 outData(i,1) = outData(i,1) + 360.0;
             end
             outData(i,6) = myData(i,11);      % Local magnitude (not Mw)
             outData(i,7) = myData(i,14);      % Depth
             outData(i,10) = myData(i,5);     % Strike-1
             outData(i,11) = myData(i,6);     % Dip-1
             outData(i,12) = myData(i,7);     % Rake-1
             outData(i,13) = myData(i,8);     % Strike-2
             outData(i,14) = myData(i,9);     % Dip-2
             outData(i,15) = myData(i,10);     % Rake-2 
  end
fid = fopen('out.dat','wt');
for j = 1:length(myData)
fprintf(fid,'%10.4f %10.4f %4i %2i %2i %3.1f %6.2f %2i %2i %3i %2i %4i %3i %2i %4i',...
    outData(j,1),outData(j,2),outData(j,3),outData(j,4),outData(j,5),...
    outData(j,6),outData(j,7),outData(j,8),outData(j,9),outData(j,10),...
    outData(j,11),outData(j,12),outData(j,13),outData(j,14),outData(j,15));
fprintf(fid,' \n');
end
fclose(fid);


  
%------ EQ_ZFORMAT_DATA format (17 columns) -----------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
%------------------------------------------------------------------
