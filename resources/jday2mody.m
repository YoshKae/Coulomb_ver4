function [ mo, dy ] = jday2mody(yr, jday)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From a year and a Julian day, compute the month and day.
% Based in part on Bruce Julian's routines.
% Assumes Gregorian calendar.
%
% JREvans, USGS, Menlo Park, Sept 2005.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ending day of each month
eom = [ 0 31 59 90 120 151 181 212 243 273 304 334 365
	0 31 60 91 121 152 182 213 244 274 305 335 366 ];

% Gregorian rule for leap years
isleap = (mod(yr,4) == 0 && mod(yr,100) ~= 0) || mod(yr,400) == 0;

if (isleap)
	eom = eom(2,:);
else
	eom = eom(1,:);
end

% Find which month we're in ...
ii = 1;
while (jday > eom(ii+1))
	ii = ii + 1;
end

% record month, compute day
mo = ii;
dy = jday - eom(ii);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
