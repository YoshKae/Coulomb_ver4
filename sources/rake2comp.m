 function [latslip dipslip] = rake2comp(rake,netslip)
% to convert lateral slip and dip slip column to rake and net slip columns
% each parameter is one column   
%     c1 = netslip == 0; c2 = netslip ~= 0;
%     adjslip = c1 .* 0.1 + c2 .* netslip; % add 0.1m slip for non-slip patch temporally
% % right-lat. slip
%     latslip = adjslip .* (-1.0) .* cos(deg2rad(rake));
% % dip slip
% 	dipslip = adjslip .* sin(deg2rad(rake));
    
% right-lat. slip
    latslip = netslip .* (-1.0) .* cos(deg2rad(rake));
% dip slip
	dipslip = netslip .* sin(deg2rad(rake));