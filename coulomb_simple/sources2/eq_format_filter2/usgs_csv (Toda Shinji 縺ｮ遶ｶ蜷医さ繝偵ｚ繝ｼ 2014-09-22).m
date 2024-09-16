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
	myData = textread(fullfile(pathname, filename), '%s', 'delimiter', ',');
    dn = 16;
	outData = zeros(floor(length(myData)/dn), 15);
    nerror = 0;
    for i = 1:length(myData)
        nn = floor(i/dn)+1;
        m  = mod(i,dn);
        if m == 0
            nn = nn - 1;
        end
        try 
            switch m
            case 1
                outData(nn,3) = str2double(myData{i}(1:4)); % year
                outData(nn,4) = str2double(myData{i}(6:7)); % month
                outData(nn,5) = str2double(myData{i}(9:10)); % day
                outData(nn,8) = str2double(myData{i}(12:13)); % hour
                outData(nn,9) = str2double(myData{i}(15:16)); % minute
            case 2
                outData(nn,2) = str2double(myData{i}); % lat.               
            case 3
                outData(nn,1) = str2double(myData{i}); % lon. 
            case 4
                outData(nn,7) = str2double(myData{i}); % depth.
            case 5
                outData(nn,6) = str2double(myData{i}); % mag.
            otherwise
                continue
            end
        catch
      disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
      nerror = nerror + 1;
        end
      if nerror > 9
          disp('!! Warning !! This may not be a properly formatted SCEC catalog.');
          flag = 0;         % transmit the error info...
          h = errordlg('This may not be a properly formatted SCEC catalog.');
          waitfor(h);
          return;
      end
    end
    return
  