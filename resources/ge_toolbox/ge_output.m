function ge_output( filename, output )
%% ge_output( filename, output)
%   filename is a character array of filename.
%     if '.kml' is used as the extension, kml is saved
%     if '.kmz' is used as the extension, kmz is saved
%   output is a character array of objects created by M2GE Toolbox


fileoutput = filename( (end-2):end );

if fileoutput == 'kml'

    fid = fopen(filename, 'wt');

    header = ['<?xml version="1.0" encoding="UTF-8"?>\n',...
             '<kml xmlns="http://earth.google.com/kml/2.1">\n',...
             '<Document>\n',...
             '<name>\n',filename,'\n</name>\n'];
    footer = ['\n</Document>\n',...
        '\n</kml>\n'];

    fprintf(fid, header );
    fprintf(fid, output );
    fprintf(fid, footer );
    fclose(fid);

else
  
    newfilename = filename(1:(end-4));
    newfilename = strcat(newfilename,'.kml');
    
    fid = fopen( newfilename, 'wt');

    header = ['<?xml version="1.0" encoding="UTF-8"?>\n',...
             '<kml xmlns="http://earth.google.com/kml/2.1">\n',...
             '<Document>\n',...
             '<name>\n',filename,'\n</name>\n'];
    footer = ['\n</Document>\n',...
        '\n</kml>\n'];

    fprintf(fid, header );
    fprintf(fid, output );
    fprintf(fid, footer );
    fclose(fid);
    
    zip( filename, newfilename );
    
    if ispc
        eval( ['!del ',newfilename] );
        eval( ['!move ', filename, '.zip ', filename ] );
    else
        eval( ['!rm ', newfilename] );
    end
    
end

