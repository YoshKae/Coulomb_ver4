%*****************************************************
%   function open_batch_file (subroutine)
%*****************************************************
function [pos,strike,dip,rake] = open_batch_file(fileName)
fid = fopen(fileName,'r');              % for ascii file
a = textscan(fid,'%s %s %s %s %s %s','HeaderLines',2);
b = str2double([a{:}]);
pos    = b(:,1:3);
strike = b(:,4);
dip    = b(:,5);
rake   = b(:,6);
fclose(fid);

