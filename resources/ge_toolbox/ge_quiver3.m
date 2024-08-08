function tag_str = ge_quiver3(XM,YM,ZM,UM,VM,WM, varargin)
%% ge_quiver3(XM, YM, ZM, UM, VM, WM, varargin
% XM, YM, ZM, UM, VM, WM should be the same constructs as used by the quiver3
% function.
% AuthorizedOptions = {'altitudeMode',...
%                      'arrowScale',...
%                      'modelLinkStr',...
%                      'timeStamp', ...
%                      'timeSpanStart', ...
%                      'timeSpanStop', ...                     
%                      'placemarkName'};
%

AuthorizedOptions = {'altitudeMode',...
                     'arrowScale',...
                     'modelLinkStr',...
                     'timeStamp', ...
                     'timeSpanStart', ...
                     'timeSpanStop', ...                     
                     'placemarkName'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end



 altitudeMode = 'absolute';
   arrowScale = 1;
 modelLinkStr = '[No model link specified]';
placemarkName = 'quiver3_default';
    timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
 
v = ge_parse_pairs(varargin);

for j = 1:length(v)
    eval(v{j});
end

if timeStamp == ' '
    timeStamp_chars = '';
else
    timeStamp_chars = [ '<TimeStamp><when>' timeStamp '</when></TimeStamp>\n' ];
end

if timeSpanStart == ' '
    timeSpan_chars = '';
else
    if timeSpanStop == ' ' 
        timeSpan_chars = [ '<TimeSpan><begin>' timeSpanStart '</begin></TimeSpan>\n' ];
    else
        timeSpan_chars = [ '<TimeSpan><begin>' timeSpanStart '</begin><end>' timeSpanStop '</end></TimeSpan>\n' ];    
    end
        
end


tag_str = ['<Placemark>' 10,...
           timeStamp_chars,...
           timeSpan_chars,...
           '<name>',placemarkName,'</name>' 10,...
           '<MultiGeometry>' 10];

xv = XM(:);
yv = YM(:);
zv = ZM(:);

uv = UM(:);
vv = VM(:);
wv = WM(:);

av = sqrt(uv.^2+vv.^2+wv.^2);

clear XM YM ZM UM VM WM

heading = zeros(size(xv));
tilt = zeros(size(xv));
roll = zeros(size(xv));


for k=1:length(xv)

    heading(k) = rad2deg(calc_dir(uv(k),vv(k)));
    tilt(k) = rad2deg(calc_dir(wv(k),sqrt(uv(k).^2 + vv(k).^2)));
    
    tag_str = [tag_str,...
                '<Model>', 10,...
                '<altitudeMode>' altitudeMode '</altitudeMode>', 10,...
                '<Location>', 10,...
                '   <longitude>' num2str(xv(k))  '</longitude>', 10,...
                '   <latitude>' num2str(yv(k)) '</latitude>', 10,...
                '   <altitude>' num2str(zv(k)) '</altitude>', 10,...
                '</Location>', 10,...
                '<Orientation>', 10,...
                '   <heading>' num2str(heading(k))  '</heading>', 10,...
                '   <tilt>' num2str(tilt(k)) '</tilt>', 10,...
                '   <roll>' num2str(roll(k)) '</roll>', 10,...
                '</Orientation>', 10,...
                '<Scale>', 10,...
                '   <x>' num2str(arrowScale*av(k)) '</x>', 10,...
                '   <y>' num2str(arrowScale*av(k)) '</y>', 10,...
                '   <z>' num2str(arrowScale*av(k)) '</z>', 10,...
                '</Scale>', 10,...
                '<Link>', 10,...
                '   <href>' modelLinkStr '</href>', 10,...
                '</Link>', 10,...
                '</Model>', 10, 10, 10 ];
                
end
                
tag_str = [tag_str, 10,...
           '</MultiGeometry>' 10,...
           '</Placemark>' 10];

    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = calc_dir(dx,dy)

warning off MATLAB:DivideByZero
if dy==0 & dx == 0
    %error(['Unable to determine the direction of' 10 'a zero-length vector. Function: ' 39 mfilename 39 '.'])
    a=0;
elseif (dy>=0) & (dx >= 0)
    a = mod(atan(dx/dy),2*pi);%#
elseif (dy>=0) & (dx < 0)
    a = mod(atan(dx/dy),2*pi);%#
elseif (dy<0) & (dx >= 0)
    a = mod(pi+atan(dx/dy),2*pi);%#
elseif (dy<0) & (dx < 0)
    a = mod(pi+atan(dx/dy),2*pi);%#
else
    a=NaN;%#
end
warning on MATLAB:DivideByZero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = rad2deg(r)

d = (r/(2*pi))*360;


