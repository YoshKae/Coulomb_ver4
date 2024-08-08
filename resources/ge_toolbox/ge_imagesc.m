function [output] = ge_imagesc( x, y, data, varargin )
%% ge_imagesc(x, y, data, varargin)
%   x, y & data should be the same constructs as used by the imagesc function
% Lat,Long are decimal degree coordinates (WGS84)
% AuthorizedOptions = {'id',...
%                      'idTag', ...
%                      'name',...
%                     'timeStamp', ...
%                     'timeSpanStart', ...
%                     'timeSpanStop', ...
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
                     'Snippet'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end
                     
                            
if( isempty( x ) || isempty( y ) || isempty(data) )
    error('empty coordinates passed to ge_imagesc(...).');
end

         %id = 'default_imagesc';
      idTag = 'id';
       %name = 'ge_imagesc';
%description = '';
 visibility = 1;
  LineColor = '00000000';
   timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
  %PolyColor = 'ffffffff';
  LineWidth = 0.0;
    %Snippet = '';
   altitude = 1.0;
   extrude = 0;
 altitudeMode = 'relativeToGround';
  transparency = 'ff';
 
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

%output= '';

[longMesh, latMesh] = meshgrid( x, y );
[col_count, row_count] = size(longMesh);
output = cell((row_count * col_count), 1);

minval = min(min(data));
if minval <= 0
    data = data - minval + 1;
end
maxval = max(max(data));
maxRGB = 255;

h = findobj;

set( h, 'HandleVisibility','off');
gridColorMap = colormap( hsv(maxRGB) );
close all;

if altitude <= 0
    altitude = 1.0;
end


ctr = 1;
for row = 1:row_count;

    for col = 1:col_count

        if data(col,row) > 0

            val = ceil((data(col,row)/maxval) * maxRGB);
            valColor = ceil(gridColorMap(val,:) .* maxRGB);
            valColorChars=dec2hex(mod(round(valColor)+2.^8,2.^8));
            subPolyColor = [transparency,valColorChars(1,:),valColorChars(2,:),valColorChars(3,:)];

            output{ctr} = ge_cell( latMesh(col,row)+latRes, latMesh(col,row), longMesh(col,row)+lonRes, longMesh(col,row), ...
                             'id', ['gridcell_',int2str(row),'_',int2str(col)], ...
                             'idTag', idTag, ...
                             'name', ['gridcell ',int2str(row),' ',int2str(col)], ...
                             'description', ['value =',num2str(data(col,row))], ...
                             'LineWidth', LineWidth, ...
                             'LineColor', LineColor, ...
                             'PolyColor', subPolyColor , ...
                             'altitude', altitude, ...
                             'extrude', extrude, ...
                             'altitudeMode', altitudeMode, ...
                             'visibility', visibility, ...
                             'timeStamp', timeStamp, ...
                             'timeSpanStart', timeSpanStart, ...
                             'timeSpanStop', timeSpanStop);

        else
            output{ctr} = '';
        end

        ctr = ctr + 1;
        
    end

    
end

output = char(output);
[sx, sy] = size(output);
foutput = char(zeros(1,sx*sy));

offset = 1;
for i = 1:sx

    trimmed = strtrim(output(i,:));
    end_offset = length(trimmed) + (offset) - 1;

    foutput(offset:end_offset) = trimmed;
    offset = end_offset + 1;

end


output = foutput;

