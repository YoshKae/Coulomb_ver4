function [out,new_xgrid,new_ygrid] = interporation(in, num, xgrid, ygrid)
% interporation function
% INPUT:
%   in: matrix
%   num: degrees of smoothing
%   xgrid: original xgrid vector (e.g., XGRID in coulomb)
%   ygrid: original ygrid vector (e.g., YGRID in coulomb)
%
% in = [4 5 12 13; 23 1 42 15; 4 92 36 75];
% num = 10;
% xgrid = [1 2 3 4];
% ygrid = [1 2 3];

% n_interp = 10.0;    % how much fine grid we need
    dummy = 0.0001; % dummy to escpe the dimension eror
    nxg = length(xgrid); xgmin = min(xgrid); xgmax = max(xgrid);
    nyg = length(ygrid); ygmin = min(ygrid); ygmax = max(ygrid);
    xnew_inc = (xgmax - xgmin + dummy) / (double(nxg) * num);
    ynew_inc = (ygmax - ygmin + dummy) / (double(nyg) * num);
    new_xgrid = [xgmin:xnew_inc:xgmax];
    new_ygrid = rot90([ygmin:ynew_inc:ygmax]);
        new_xgrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % initialization
        new_ygrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % initialization
        out = zeros(length(new_ygrid),length(new_xgrid));            % initialization
    new_xgrid_mtr = repmat(new_xgrid,length(new_ygrid),1);
    new_ygrid_mtr = repmat(new_ygrid,1,length(new_xgrid));
    old_xgrid_mtr = repmat(xgrid,length(ygrid),1);
    old_ygrid_mtr = repmat(flipud(rot90(ygrid)),1,length(xgrid));
    out = zeros(length(new_ygrid),length(new_xgrid));    % initialization
    % use interp2 function (interp2(x,y,z,xi,yi) using default 'linear'
    out = interp2(old_xgrid_mtr,old_ygrid_mtr,fliplr(in),new_xgrid_mtr,new_ygrid_mtr);
	out = fliplr(out);
