function [output] = ge_contour( x, y, data, varargin )
%% ge_contour(x, y, data, varargin)
% x, y, & data are used the same as the contour function
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
%                      'altitude', ...
%                      'extrude', ...
%                      'tessellate', ...
%                      'altitudeMode', ...
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
                     'altitude', ...
                     'extrude', ...
                     'tessellate', ...
                     'altitudeMode', ...
                     'Snippet'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end
                     
                            
if( isempty( x ) || isempty( y ) || isempty(data) )
    error('empty coordinates passed to ge_contour(...).');
end

         id = 'default_contour';
      idTag = 'id';
       name = 'ge_contour';
  timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
description = '';
 visibility = 1;
  LineColor = '00000000';
  LineWidth = 0.0;
    Snippet = '';
   altitude = 1.0;
   extrude = 0;
   tessellate = 1;
 altitudeMode = 'relativeToGround';
 

v = ge_parse_pairs(varargin);

for j = 1:length(v)
    eval(v{j});
end

id_chars = [ idTag '="' id '"' ];
poly_id_chars = [ idTag '="poly_' id '"' ];
name_chars = [ '<name>\n' name '\n</name>\n' ];
description_chars = [ '<description>\n<![CDATA[' description ']]>\n</description>\n' ];
visibility_chars = [ '<visibility>\n' int2str(visibility) '\n</visibility>\n' ];
lineColor_chars = [ '<color>\n' LineColor '\n</color>\n' ];
lineWidth_chars= [ '<width>\n' num2str(LineWidth, '%.2f') '\n</width>\n' ];
altitudeMode_chars = [ '<altitudeMode>\n' altitudeMode '\n</altitudeMode>\n' ];
snippet_chars = [ '<Snippet>' Snippet '</Snippet>\n' ];
extrude_chars = [ '<extrude>' int2str(extrude) '</extrude>' ];
tessellate_chars = [ '<tessellate>' int2str(tessellate) '</tessellate>' ];
output= '';


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

%[lonMesh, latMesh] = meshgrid( x, y );
%[col_count, row_count] = size(lonMesh);

%minval = min(min(data));
%maxval = max(max(data));
maxRGB = 255;

h = findobj;
set( h, 'HandleVisibility','off');
C = contourc(x,y,data);
gridColorMap = colormap( hsv(maxRGB) );
close all;

if altitude <= 0
    altitude = 1.0;
end

count = -1;
ctr = 0;
i = 1;
while( i < length(C) )
    
 
    count =  floor(C(2,i));
    ctr = i;
    
    altitude_tmp = altitude * ones( count, 1 );
    coords = C(:,(ctr+1):(i+count));
    coords = permute(coords, [1 2]);
    coords(3,:) = altitude_tmp;
    
    header=['<Placemark ',id_chars,'>','\n',...
    name_chars,'\n',...
    timeStamp_chars,...
    timeSpan_chars,...
    visibility_chars,'\n',...
    description_chars, ...
    snippet_chars, ...
    '<Style>','\n',...
        '<LineStyle>','\n',...
            lineColor_chars,'\n',...
            lineWidth_chars,'\n',...
        '</LineStyle>','\n',...
    '</Style>','\n',...
    '<LineString ',poly_id_chars,'>','\n',...
    extrude_chars, ...
    altitudeMode_chars, ...
    tessellate_chars,...
    '<coordinates>'];

    coordinates = sprintf('%.6f,%.6f,%.6f ', coords);

    footer = ['</coordinates>',...
    '</LineString>',...
    '</Placemark>'];  

    output_pre = [ header, coordinates, footer ];
    output = [output, output_pre];   
    
    i = i+count+1;      

end




