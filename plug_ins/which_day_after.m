function[yr,mo,dy,hr,mn,sc] = which_day_after(yr1,mo1,dy1,hr1,mn1,sc1,elpdy)
% function to find
evttime = datenum(yr1,mo1,dy1,hr1,mn1,sc1)+elpdy;
[yr,mo,dy,hr,mn,sc] = datevec(evttime);