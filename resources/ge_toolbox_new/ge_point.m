function [output] = ge_point(X, Y, Z, varargin)
%% ge_point(X, Y, Z, varargin)
%   X, Y, Z should be the same constructs as used by the plot3 function
% X & Y are decimal degree coordinates (WGS84)
% AuthorizedOptions = {'id',...
%                      'idTag', ...
%                      'name',...
%                      'timeStamp', ...
%                      'timeSpanStart', ...
%                      'timeSpanStop', ...
%                      'description', ...
%                      'visibility', ...
%                      'Icon', ...
%                      'IconScale', ...
%                      'IconColor', ...
%                      'LineWidth', ...
%                      'LineColor'};

AuthorizedOptions = {'id',...
                     'idTag', ...
                     'name',...
                     'timeStamp', ...
                     'timeSpanStart', ...
                     'timeSpanStop', ...
                     'description', ...
                     'visibility', ...
                     'Icon', ...
                     'IconColor', ...
                     'viewBoundScale', ...
                     'LineWidth', ...
                     'LineColor'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end
                     
                            
if( isempty( X ) || isempty( Y ) || isempty(Z) )
    error('empty coordinates passed to ge_point(...).');
else
    if ~isequal(size(X(:)),size(Y(:))) 
        error(['Coordinate vectors of different length passed' 10 'to function: ' 39 mfilename 39 '.'])
    else
        coords(:,1) = X;
        coords(:,2) = Y;
        coords(:,3) = Z;
    end
end

         id = 'default_point';
      idTag = 'id';
       name = 'ge_point';
    timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
       Icon   = ' ';
   IconColor = 'ffffffff';
   IconScale = 1.0;
   viewBoundScale = 1.0;
description = '';
 visibility = 1;
  LineColor = 'ffffffff';
  LineWidth = 1.0;

v = ge_parse_pairs(varargin);

for j = 1:length(v)
    eval(v{j});
end

id_chars = [ idTag '="' id '"' ];
poly_id_chars = [ idTag '="point_' id '"' ];
name_chars = [ '<name>\n' name '\n</name>\n' ];
description_chars = [ '<description>\n<![CDATA[' description ']]>\n</description>\n' ];
visibility_chars = [ '<visibility>\n' int2str(visibility) '\n</visibility>\n' ];
LineColor_chars = [ '<color>\n' LineColor '\n</color>\n' ];
LineWidth_chars= [ '<width>\n' num2str(LineWidth, '%.2f') '\n</width>\n' ];

if Icon == ' '
    icon_chars = '';
else
    icon_chars = [ ...
    '<IconStyle>\n',...
    '<color>' IconColor '</color>\n',...
    '<scale>' num2str(IconScale) '</scale>\n',...
    '<Icon>\n',...
    '<href>' Icon '</href>\n',...
    '</Icon> \n', ...
    '</IconStyle>' ]; 

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

header=['<Placemark ',id_chars,'>\n',...
    name_chars,'\n',...
    timeStamp_chars,...
    timeSpan_chars,...
    visibility_chars,'\n',...
    '<Snippet>\n', description, '\n</Snippet>\n',...
    description_chars,'\n',...
    icon_chars, ...
    '<Style>\n',...
        icon_chars, ...
        '<LineStyle>\n',...
            LineColor_chars,'\n',...
            LineWidth_chars,'\n',...
        '</LineStyle>\n',...
    '\n</Style>\n',...
  '<Point ',poly_id_chars,'>\n',...
    '<altitudeMode>relativeToGround</altitudeMode>\n', ...
    '<tessellate>\n1\n</tessellate>\n',...
    '<coordinates>\n'];


footer = ['</coordinates>\n',...
    '\n</Point>\n',...
    '\n</Placemark>\n'];  

%path plot or not
len = length(coords(:,1,1));
output = '';
if length( coords(:,1) ) > 1

    for x = 1:len
        if ~isnan(coords(x,1))
            coordinates = conv_coord(coords(x,:));
            output = [ output, header, coordinates, footer ];
        end
    end
   
else
    if ~isnan(coords)
        coordinates = conv_coord(coords);
        output = [ header, coordinates, footer ]; 
    end
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOCAL FUNCTIONS START HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function s = conv_coord(M)
%% conv_coord(M)
% helper function to conver decimal degree coordinates into character array
s=[];

for r=1:size(M,1)
    for c=1:size(M,2)
        s = [s,sprintf('%.6f',M(r,c))];
        s = trim_trail_zero(s);
        if c==size(M,2)
            s=[s,'\n'];
        else
            s=[s,','];          
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s_out = trim_trail_zero(s_in)
%   helper function meant to trim trailing character zeros from a character
%   array.

dig = 1;
L = length(s_in);
last_char = s_in(L);

cont = true;

while (strcmp(last_char,'0') | strcmp(last_char,'.')) & cont==1
    if strcmp((last_char),'.')
        cont = 0;
    end
    s_in = s_in(1:L-dig);
    last_char = s_in(length(s_in));
    dig = dig+1;
end

s_out = s_in;




