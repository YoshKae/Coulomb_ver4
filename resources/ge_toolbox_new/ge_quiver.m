function [output] = ge_quiver(X, Y, DX, DY, varargin)
%% ge_quiver(X, Y, DX, DY, varargin)
% X, Y, DX, DY should be the same constructs as used by the quiver
% function.
% AuthorizedOptions = {'id',...
%                      'idTag', ...
%                      'name',...
%                      'description', ...
%                      'visibility', ...
%                      'timeStamp', ...
%                      'timeSpanStart', ...
%                      'timeSpanStop', ...
%                      'LineWidth', ...
%                      'LineColor', ...
%                      'extrude', ...
%                      'altitude', ...
%                      'altitudeMode', ...
%                      'magnitudeScale',...
%                      'magnitudemax',...
%                      'Snippet'};

AuthorizedOptions = {'id',...
                     'idTag', ...
                     'name',...
                     'description', ...
                     'visibility', ...
                     'timeStamp', ...
                     'timeSpanStart', ...
                     'timeSpanStop', ...
                     'LineWidth', ...
                     'LineColor', ...
                     'extrude', ...
                     'altitude', ...
                     'altitudeMode', ...
                     'magnitudeScale',...
                     'magnitudemax',...
                     'Snippet'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end
                     
                            
if( isempty( X ) || isempty( Y ) || isempty( DX ) || isempty( DY ) )
    error('empty coordinates passed to ge_quiver(...).');
end

         id = 'default_quiver';
      idTag = 'id';
       name = 'ge_guiver';
description = '';
    timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
 visibility = 1;
 extrude = 0;
  LineColor = 'ffffffff';
  LineWidth = 0.0;
    Snippet = '';
   altitude = 1.0;
 altitudeMode = 'relativeToGround';

if (max(size(X)) >= 2) && (max(size(Y)) >= 2)

    step_size_x = abs( X(1,1) - X(1,2) );
    step_size_y = abs( Y(1,1) - Y(2,1) );
    magnitudeMax = max( [ max(max(X)) max(max(Y)) ] );
    magnitudeScale = min( [step_size_x step_size_y] );

elseif max(size( X )) >= 2

    step_size_x = abs( X(1,1) - X(1,2) );
    magnitudeMax = max( [ max(max(X)) max(Y) ] );
    magnitudeScale = step_size_x;

elseif max(size( Y )) >= 2

    step_size_y = abs( Y(1,1) - Y(2,1) );
    magnitudeMax = max( [ max(max(Y)) max(X) ] );
    magnitudeScale = step_size_y;     

else
    magnitudeMax = max(max(X));
    magnitudeScale = 1.0;
end
    
v = ge_parse_pairs(varargin);

for j = 1:length(v)
    eval(v{j});
end

%id_chars = [ idTag '="' id '"' ];
name_chars = [ '<name>\n' name '\n</name>\n' ];
description_chars = [ '<description>\n<![CDATA[' description ']]>\n</description>\n' ];
visibility_chars = [ '<visibility>\n' int2str(visibility) '\n</visibility>\n' ];
lineColor_chars = [ '<color>\n' LineColor '\n</color>\n' ];
lineWidth_chars= [ '<width>\n' num2str(LineWidth, '%.2f') '\n</width>\n' ];
altitudeMode_chars = [ '<altitudeMode>\n' altitudeMode '\n</altitudeMode>\n' ];
extrude_chars = [ '<extrude>' int2str(extrude) '</extrude>\n' ];
snippet_chars = [ '<Snippet>' Snippet '</Snippet>\n' ];

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


[row_count, col_count] = size(X);
%output = '';
output = cell((row_count * col_count), 1);
ctr = 1;

for row = 1:row_count
    for col = 1:col_count

        if (DX(row,col) == 0) && (DY(row,col) == 0)
            
            direction = 0;
            
        elseif DX(row,col) == 0
            
            if DY(row,col) > 0
                direction = 0;
            else
                direction = 180;
            end

        elseif DY(row,col) == 0
            
            if DX(row,col) > 0
                direction = 90;
            else
                direction = 270;
            end
            
        else
            direction = rad2deg( atan2(  DX(row,col) , DY(row,col)  ) );

        end
        
        magnitude = sqrt( DX(row,col) .^ 2 + DY(row,col) .^ 2 );
 
        part1 = [' <Document ',idTag,'="qc_',int2str(row),'_',int2str(col),'">',...
                    '<name>',int2str(row),' ',int2str(col),'</name>',...
                    '<Placemark ',idTag,'="q_',int2str(row),'_',int2str(col),'">',...
                        name_chars,...
                        timeStamp_chars,...
                        timeSpan_chars,...
                        snippet_chars,...
                        description_chars,...
                        '<Style ',idTag,'="qs_',int2str(row),'_',int2str(col),'">',...
                            '<LineStyle ',idTag,'="qls_',int2str(row),'_',int2str(col),'">',...
                                lineColor_chars,...
                                lineWidth_chars,...
                           '</LineStyle>',...
                        '</Style>',...
                        visibility_chars,...
                        '<LineString ',idTag,'="ql_',int2str(row),'_',int2str(col),'">',...
                            extrude_chars,...
                            altitudeMode_chars,...
                            '<tessellate>1</tessellate>',...
                            '<coordinates>'];

        %continued ugliness
        alpharad = deg2rad( [direction, (direction + 12), (direction - 12)]  );           %[rad]  
        scaleFactor = ( magnitude / magnitudeMax ) * magnitudeScale; 
        divPer= [scaleFactor, (3*scaleFactor/4), (3*scaleFactor/4) ]';

        %how to do this step once in parrallel?
        %     x = sin( alpharad ) * divPer;
        %     y = cos( alpharad ) * divPer;
        x(1) = sin( alpharad(1) ) * divPer(1);
        y(1) = cos( alpharad(1) ) * divPer(1);
        x(2) = sin( alpharad(2) ) * divPer(2);
        y(2) = cos( alpharad(2) ) * divPer(2);
        x(3) = sin( alpharad(3) ) * divPer(3);
        y(3) = cos( alpharad(3) ) * divPer(3);


        arrow_coords = [ num2str(X(row, col)),',',num2str(Y(row, col)),',',num2str(altitude),' ',...
                        num2str(X(row, col)+x(1)),',',num2str(Y(row, col)+y(1)),',',num2str(altitude),' ',...
                        num2str(X(row, col)+x(2)),',',num2str(Y(row, col)+y(2)),',',num2str(altitude),' ',...
                        num2str(X(row, col)+x(3)),',',num2str(Y(row, col)+y(3)),',',num2str(altitude),' ',...
                        num2str(X(row, col)+x(1)),',',num2str(Y(row, col)+y(1)),',',num2str(altitude),' '];

        part2 = [ '</coordinates>',...
                '</LineString>',...
              '</Placemark>',...
            '</Document>'];

        chunk = strcat(part1, arrow_coords, part2);
        output{ctr} = chunk;
        
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

