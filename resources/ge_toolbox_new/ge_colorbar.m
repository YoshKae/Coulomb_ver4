function [output] = ge_colorbar( x, y, data, varargin )
%% ge_colorbar(x, y, data, varargin)
%
% x & y are decimal degree coordinates (WGS84)
% AuthorizedOptions = {'id',...
%                      'idTag', ...
%                      'name',...
%                      'timeStamp', ...
%                      'timeSpanStart', ...
%                      'timeSpanStop', ...
%                      'description', ...
%                      'visibility', ...
%                      'LineWidth', ...
%                      'LineColor', ...
%                      'PolyColor', ...
%                      'altitude', ...
%                      'extrude', ...
%                      'altitudeMode', ...
%                      'transparency', ...
%                      'latRes', ...
%                      'lonRes', ...
%                      'Snippet'};

AuthorizedOptions = {'id',...
                     'idTag', ...
                     'name',...
                     'timeStamp', ...
                     'timeSpanStart', ...
                     'timeSpanStop', ...
                     'description', ...
                     'visibility', ...
                     'LineWidth', ...
                     'LineColor', ...
                     'PolyColor', ...
                     'altitude', ...
                     'extrude', ...
                     'altitudeMode', ...
                     'transparency', ...
                     'latRes', ...
                     'lonRes', ...
                     'orientation', ...
                     'filename', ...
                     'Snippet'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end
                     
                            
if( isempty( x ) || isempty( y ) || isempty(data) )
    error('empty coordinates passed to ge_colorbar(...).');
else
    coords(:,1) = x;
    coords(:,2) = y;
end
         id = 'default_colorbar';        
      idTag = 'id';
      name  = 'ge_colorbar';
      description = '';
      Snippet = '';
 visibility = 1;
  LineColor = '00000000';
    PolyColor = 'ffffffff';
   timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
  LineWidth = 0.0;
   altitude = 1.0;
   extrude = 0;
 altitudeMode = 'relativeToGround';
 orientation = 'horizontal';
  transparency = 'ff';
  filename = 'colorbar.png';
 
if length(y) > 1 
    latRes = abs( y(1) - y(2) );
else
    latRes = 10;
end

if length(x) > 1 
    lonRes = abs( x(1) - x(2) );
else
    lonRes = 10;
end

v = ge_parse_pairs(varargin);

for j = 1:length(v)
    eval(v{j});
end

if ~strcmp(orientation,'vertical') && ~strcmp(orientation,'horizontal')
    orientation = 'horizontal';
end
html = generate_colorbar(data, orientation);
coords(:,3) = altitude;
id_chars = [ idTag '="' id '"' ];
poly_id_chars = [ idTag '="poly_' id '"' ];
name_chars = [ '<name>\n' name '\n</name>\n' ];
description_chars = [ '<description>\n<![CDATA[' html '>]]>\n</description>\n' ];
visibility_chars = [ '<visibility>\n' int2str(visibility) '\n</visibility>\n' ];
lineColor_chars = [ '<color>\n' LineColor '\n</color>\n' ];
polyColor_chars = [ '<color>\n' PolyColor '\n</color>\n' ];
lineWidth_chars= [ '<width>\n' num2str(LineWidth, '%.2f') '\n</width>\n' ];
altitudeMode_chars = [ '<altitudeMode>\n' altitudeMode '\n</altitudeMode>\n' ];
snippet_chars = [ '<Snippet>' Snippet '</Snippet>\n' ];
extrude_chars = [ '<extrude>' int2str(extrude) '</extrude>\n' ];

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
    description_chars,...
  '<Point ',poly_id_chars,'>\n',...
    '<altitudeMode>relativeToGround</altitudeMode>\n', ...
    '<tessellate>\n1\n</tessellate>\n',...
    '<coordinates>\n'];


footer = ['</coordinates>\n',...
    '\n</Point>\n',...
    '\n</Placemark>\n'];  

output = '';

if ~isnan(coords)
    coordinates = conv_coord(coords);
    output = [ header, coordinates, footer ]; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOCAL FUNCTIONS START HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function html = generate_colorbar(data, orientation)

    if strcmp(orientation, 'horizontal')

        colorbar_orig_minval = min(min(data));
        colorbar_orig_maxval = max(max(data));

        if colorbar_orig_minval <= 0
            data = data - colorbar_orig_minval + 1;
        end
        colorbar_minval =  min(min(data));
        colorbar_maxval = max(max(data));

        h = findobj;
        maxRGB = 255;
        set( h, 'HandleVisibility','off');
        gridColorMap = colormap( jet(maxRGB) );
        close all;

        test = colorbar_minval:colorbar_maxval;
        test2 = colorbar_orig_minval:colorbar_orig_maxval;
        %test = repmat(test,10,1);
        test = ceil((test/colorbar_maxval) * maxRGB);
        %imwrite(test,gridColorMap,filename,'png');

        html_header =  ['<TABLE border=1 bgcolor=#FFFFFF>',...
                        '<TR>'];
        html_footer = ['</TR>',...
                        '</TABLE>'];
        html = '';
        for i = 1:length(test);

            val = test(i);
            valColor = ceil(gridColorMap(val,:) .* maxRGB);
            valColorChars=dec2hex(mod(round(valColor)+2.^8,2.^8));
            subPolyColor = [valColorChars(1,:),valColorChars(2,:),valColorChars(3,:)];        
            html = [html '<TD bgcolor=#' subPolyColor '>' num2str(test2(i)) '</TD>'];

        end

        html = [html_header html html_footer];
    else
        
        colorbar_orig_minval = min(min(data));
        colorbar_orig_maxval = max(max(data));

        if colorbar_orig_minval <= 0
            data = data - colorbar_orig_minval + 1;
        end
        colorbar_minval =  min(min(data));
        colorbar_maxval = max(max(data));

        h = findobj;
        maxRGB = 255;
        set( h, 'HandleVisibility','off');
        gridColorMap = colormap( jet(maxRGB) );
        close all;

        test = colorbar_minval:colorbar_maxval;
        test2 = colorbar_orig_minval:colorbar_orig_maxval;
        %test = repmat(test,10,1);
        test = ceil((test/colorbar_maxval) * maxRGB);
        %imwrite(test,gridColorMap,filename,'png');

        html_header =  ['<TABLE border=1 bgcolor=#FFFFFF>'];
        html_footer = ['</TABLE>'];
        html = '';
        test = fliplr(test);
        test2 = fliplr(test2);
        for i = 1:length(test);

            val = test(i);
            valColor = ceil(gridColorMap(val,:) .* maxRGB);
            valColorChars=dec2hex(mod(round(valColor)+2.^8,2.^8));
            subPolyColor = [valColorChars(1,:),valColorChars(2,:),valColorChars(3,:)];        
            html = [html '<TR><TD bgcolor=#' subPolyColor '>' num2str(test2(i)) '</TD></TR>'];

        end

        html = [html_header html html_footer];
        
    end
    


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

