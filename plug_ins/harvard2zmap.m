function harvard2zmap
%
%   Read Harvard CMT earthquake catalog
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
	myData = textread(fullfile(pathname, filename), '%s', 'delimiter', '\n', 'whitespace', '');
	outData = zeros(int32(length(myData)/5), 15,'double');
  nerror = 0;

  for i = 1:length(myData)
            n = mod(i,5);
        try
            if n == 1
             m = int16(i/5)+1;
             outData(m,3) = str2double(myData{i}(6:9));        % Year
             outData(m,4) = str2double(myData{i}(11:12));      % Month
             outData(m,5) = str2double(myData{i}(14:15));      % Day
             outData(m,2) = str2double(myData{i}(28:33));      % Latitude  
             outData(m,1) = str2double(myData{i}(35:41));      % Longitude 
             outData(m,7) = str2double(myData{i}(43:47));      % Depth
             outData(m,8) = str2double(myData{i}(17:18));      % hour
             outData(m,9) = str2double(myData{i}(20:21));      % minute
            elseif n == 4
             mo1 = str2double(myData{i}(1:2));                 % Mo (part1)
            elseif n == 0
             mo2 = str2double(myData{i}(50:56));               % Mo (part2)
             mo  = mo2*10.0^mo1;
             mw  = log10(mo)/1.5 - 10.73;
             outData(m,6) = mw;                             % Mw           
             outData(m,10) = str2double(myData{i}(58:60));     % Strike-1
             outData(m,11) = str2double(myData{i}(62:63));     % Dip-1
             outData(m,12) = str2double(myData{i}(65:68));     % Rake-1
             outData(m,13) = str2double(myData{i}(70:72));     % Strike-2
             outData(m,14) = str2double(myData{i}(74:75));     % Dip-2
             outData(m,15) = str2double(myData{i}(77:80));     % Rake-2
                if isnan(outData(m,1)) || isnan(outData(m,6))
                    nerror = nerror + 1;
                end
            end
        catch
        disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
        nerror = nerror + 1;
        end
        if nerror > 9
          disp('!! Warning !! This may not be a properly formatted global CMT catalog.');
          flag = 0;         % transmit the error info...
          h = errordlg('This may not be a properly formatted global CMT catalog.');
          waitfor(h);
          return;
        end

  %      dlmwrite('out.dat',outData(:,1:12),'precision','%15.6f','-append');
  end
fid = fopen('out.dat','wt');
for j = 1:m
fprintf(fid,'%10.4f %10.4f %4i %2i %2i %3.1f %6.2f %2i %2i %3i %2i %4i',...
    outData(j,1),outData(j,2),outData(j,3),outData(j,4),outData(j,5),...
    outData(j,6),outData(j,7),outData(j,8),outData(j,9),outData(j,10),...
    outData(j,11),outData(j,12));
fprintf(fid,' \n');
end
fclose(fid);


  
%------ EQ_ZFORMAT_DATA format (17 columns) -----------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
%------------------------------------------------------------------
