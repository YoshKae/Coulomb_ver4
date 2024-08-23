function [outkm,flag] = distance2(lat1,lon1,lat2,lon2)
%
% Inputs:
%    lat1: Latitude scalar.   Degrees.  +ddd.ddddd  WGS84
%    lon1: Longitude scalar.  Degrees.  +ddd.ddddd  WGS84
%    lat2: Latitude scalar.   Degrees.  +ddd.ddddd  WGS84
%    lon2: Longitude scalar.  Degrees.  +ddd.ddddd  WGS84
%
% Outputs:
%    outkm: distance between two point on a map 2点間の距離 [km]
%   flag: 1 OK, 0 different UTM zone
%

% use a function deg2utm written by Rafael Palacios
[x1,y1,utmzone1] = deg2utm(lat1,lon1);
[x2,y2,utmzone2] = deg2utm(lat2,lon2);

if ~strcmp(utmzone1,utmzone2)

    flag = 1;
else
    flag = 0;
end

% meter to kilometer
outkm = sqrt((x1-x2)^2.0 + (y1-y2)^2.0) / 1000.0;
