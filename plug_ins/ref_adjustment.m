% script to adjust the input ref position to the standard position
%

% standard ref position
lon = 135.0;
lat =  34.0;

diff_lon = deg2km(distance((ZERO_LAT+lat)/2.,ZERO_LON,(ZERO_LAT+lat)/2.,lon));
diff_lat = deg2km(distance(ZERO_LAT,(lon+ZERO_LON)/2.,lat,(lon+ZERO_LON)/2.));
ELEMENT(:,1) = ELEMENT(:,1) + diff_lon;
ELEMENT(:,3) = ELEMENT(:,3) + diff_lon;
ELEMENT(:,2) = ELEMENT(:,2) + diff_lat;
ELEMENT(:,4) = ELEMENT(:,4) + diff_lat;
