%	myData = textread('zmap_formatted_catalog.dat','%s','delimiter', '\n', 'whitespace', '');
	outData = zeros(length(EQ_DATA), 9);
    nerror = 0;
    
    
%     for i = 1:length(myData)
%         s1 = strfind(myData{i},str1);
%             outData(i,3) = str2double(myData{i}(s1+20:s1+23)); % Year
%             outData(i,4) = str2double(myData{i}(s1+25:s1+26)); % Month
%             outData(i,5) = str2double(myData{i}(s1+28:s1+29)); % Day
%         s2 = strfind(myData{i},str2);
%             outData(i,8) = str2double(myData{i}(s2+19:s2+20)); % hr
%             outData(i,9) = str2double(myData{i}(s2+22:s2+23)); % mn
%         s3 = strfind(myData{i},str3);
%             outData(i,2) = str2double(myData{i}(s3+22:s3+26)); % lat.
%             if isnan(outData(i,2))
%                 outData(i,2) = str2double(myData{i}(s3+22:s3+25)); % lat.
%             end
%         s4 = strfind(myData{i},str4);
%             outData(i,1) = str2double(myData{i}(s4+23:s4+28)); % lon.
%             if isnan(outData(i,1))
%                 outData(i,1) = str2double(myData{i}(s4+23:s4+27)); % lon.
%             end
%             if outData(i,1) <= -100.0
%                 outData(i,1) = str2double(myData{i}(s4+23:s4+29)); % lon.
%                 if isnan(outData(i,1))
%                 outData(i,1) = str2double(myData{i}(s4+23:s4+28)); % lon.
%                 end
%             end
%         s5 = strfind(myData{i},str5);
%             outData(i,7) = str2double(myData{i}(s5+26:s5+28)); % depth (try?)
%             if isnan(outData(i,7))
%                 outData(i,7) = str2double(myData{i}(s5+26:s5+27));
%                 if isnan(outData(i,7))
%                     outData(i,7) = str2double(myData{i}(s5+26:s5+26));
%                 end
%             end
%         s6 = strfind(myData{i},str6);
%             outData(i,6) = str2double(myData{i}(s6+23:s6+25)); % depth (try?)
%     end
    
    outData(:,1) = EQ_DATA(:,1);
    outData(:,2) = EQ_DATA(:,2);
    outData(:,3) = EQ_DATA(:,3);
    outData(:,4) = EQ_DATA(:,4);
    outData(:,5) = EQ_DATA(:,5);
    outData(:,6) = EQ_DATA(:,6);
    outData(:,7) = EQ_DATA(:,7);
    outData(:,8) = EQ_DATA(:,8);
    outData(:,9) = EQ_DATA(:,9);
    
    fid = fopen('out.dat','wt');
    for j = 1:length(EQ_DATA)
    fprintf(fid,'%10.6f %10.6f %4i %2i %2i %3.1f %6.2f %2i %2i',...
    outData(j,1),outData(j,2),outData(j,3),outData(j,4),outData(j,5),...
    outData(j,6),outData(j,7),outData(j,8),outData(j,9));
    fprintf(fid,' \n');
    end
    fclose(fid);

% s = [outData(:,1) outData(:,2) outData(:,3) outData(:,4) outData(:,5) outData(:,6) outData(:,7) outData(:,8) outData(:,9)];
%  fid = fopen('test.dat','w') ;
%        fprintf(fid,'%6.2f  %6.2f %6.2f %6.2f  %6.2f %6.2f %6.2f\n',s);
% fclose(fid)

% for i = 1:length(myData)
% 	try 
%             lon_deg = str2double(myData{i}(33:36));
%             lon_min = str2double(myData{i}(37:41))/100;
%             outData(i,1) = lon_deg + lon_min/60.0;              % longitude
%             lat_deg = str2double(myData{i}(22:24));
%             lat_min = str2double(myData{i}(25:28))/100;
%             outData(i,2) = lat_deg + lat_min/60.0;              % latitude
%             outData(i,3) = str2double(myData{i}(2:5));          % Year
%             outData(i,4) = str2double(myData{i}(6:7));          % Month
%             outData(i,5) = str2double(myData{i}(8:9));          % Day
%             outData(i,6) = str2double(myData{i}(53:54))/10.;	% Magnitude
%             if isnan(outData(i,6))
%             outData(i,6) = -9.9;      % Magnitude (No M info, temp assigned -9.9)
%             end
%             outData(i,7) = str2double(myData{i}(45:49))/100.;	% Depth             
%             outData(i,8) = str2double(myData{i}(10:11));        % Hour
%             outData(i,9) = str2double(myData{i}(12:13));        % Minute
%             outData(i,10) = 0.0;                                % Nodal 1: strike
%             outData(i,11) = 0.0;                                % Nodal 1: dip
%             outData(i,12) = 0.0;                                % Nodal 1: rake
%             outData(i,13) = 0.0;                                % Nodal 2: strike
%             outData(i,14) = 0.0;                                % Nodal 2: dip
%             outData(i,15) = 0.0;                                % Nodal 2: rake
% %             if isnan(outData(i,1)) || isnan(outData(i,3)) || isnan(outData(i,6))
% %                 nerror = nerror + 1;
% %             end
%     catch
%         disp(['Import: Problem in line ' num2str(i) ' of ' filename '. Line ignored.']);
%         nerror = nerror + 1;
%     end
%         if nerror > 9
%           disp('!! Warning !! This may not be a properly formatted JMA catalog.');
%           h = errordlg('This may not be a properly formatted JMA catalog.');
%           flag = 0;         % transmit the error info...
%           waitfor(h);
%           return;
%         end
% end

% z map format
%
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
%