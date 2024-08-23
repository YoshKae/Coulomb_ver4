function date_and_file_stamp(hw,fname,xp,yp,lspace,ftype,depth,stype,fric,dtype,...
    depthrange,strike,dip,rake,isec_flag,xs,ys,xf,yf,sdip);
% This function put a stamp describing date, file name, and eventually
% other info.
%
% INPUT
%   hw: current window handle to show the stamp
%   fname: input file name (string)
%   xp, yp: stamping position
%   lspace: line spacing width
%   ftype: FUNC_TYPE
%   stype: STRESS_TYPE
%   dtype: DEPTH_RANGE_TYPE
%   fric: coefficient of friction
%   depth: calculation depth(CALC_DEPTH)
%   depthrange: CALC_DEPTH_RANGE when DEPTH_RANGE_TYPE==1
%
% OUTPUT
%   on the graphic (on the hw window)

if isempty(fname)==1
    return
end

if (nargin <= 14)
    isec_flag = 0;
end

% lspace   = 3.0;     %line spacing
psize = 10;
pname = 'Arial';

app_name = 'Coulomb 3.0.1   ';
date_stamp = datestr(now,0);
if ftype >= 1 && ftype <= 6
    if ftype == 1
        calc_stamp = 'Map view grid';
    elseif ftype == 2
        calc_stamp = 'Horizontal vectors';
    elseif ftype == 3
        calc_stamp = 'Deformed wireframe';
    elseif ftype == 4
        calc_stamp = 'Vertical displecement';
    elseif ftype == 6
        calc_stamp = 'Strain calc.';
    else
        calc_stamp = '---';
    end
    depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
    h3_stamp = [calc_stamp,depth_stamp];
elseif ftype >= 7 && ftype <=9
    switch stype
        case 1
            calc_stamp = 'Opt. oriented faults';
        case 2
            calc_stamp = 'Opt. strike-slip faults';
        case 3
            calc_stamp = 'Opt. thrust faults';
        case 4
            calc_stamp = 'Opt. normal faults';
        case 5
            calc_stamp = ['Specified faults: ',num2str(strike),'/',...
                num2str(dip),'/',num2str(rake)];            
        otherwise
            calc_stamp = '---';    
    end
    fric_stamp  = ['  Friction: ',num2str(fric,'%4.2f')];
    if isec_flag == 0
        depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
        if dtype == 1
            depth_stamp = ['  Depth: ',num2str(depthrange(1)),'-',...
                            num2str(depthrange(end)),' km'];  
        end
    else
        depth_stamp = [' A(',num2str(xs),',',num2str(ys),') --- B(',...
            num2str(xf),',',num2str(yf),') dip ',num2str(sdip),' deg.'];
    end
    h3_stamp = [calc_stamp,depth_stamp,fric_stamp];
else
    calc_stamp = 'Stress on nodal planes';  
%    depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
    depth_stamp = ['  Depth: --- km'];
%    fric_stamp  = ['  Friction: ',num2str(fric,'%4.2f')];
    h3_stamp = [calc_stamp];    
end

figure(hw);
hold on;
h1 = text(xp,yp,[app_name,date_stamp, '  ' ,fname]);
h2 = text(xp,yp-1.0*lspace,h3_stamp);
set(h1,'HorizontalAlignment','right','FontSize',psize,'FontName',pname);
set(h2,'HorizontalAlignment','right','FontSize',psize,'FontName',pname);
