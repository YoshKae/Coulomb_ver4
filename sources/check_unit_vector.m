function [unit,unitText] = check_unit_vector(xs,xf,oneMeterSize,ratioMin,...
                                             ratioMax) 
% This function finds the appropriate unit length to show on the disp. map

% Input
%   xs: x start position (in km) or y for vertical disp.
%   xf: x finish position (in km) or y for vertical disp.
%   oneMeterSize: exaggerated one meter vector in km
%   ratioMax: 0 to 1. e.g., 0.5 means it does not allow the unit vector
%               arrow over the half of the graphic.
%   ratioMin: minimum ratio to show the unit vector
%
% Output
%   unit: unit length in double (e.g., 0.01, 0.1, 1, 10)
%   unit_text: string of unit

totalLength = abs(xf - xs);
maxLength   = totalLength * ratioMax;
minLength   = totalLength * ratioMin;

if oneMeterSize > maxLength 
    unit = 0.1; unitText = '0.1 m';
    oneMeterSize = oneMeterSize * 0.1;
    if oneMeterSize > maxLength
        unit = 0.01; unitText = '0.01 m';
        oneMeterSize = oneMeterSize * 0.1;
        if oneMeterSize > maxLength
            unit = 0.001; unitText = '0.001 m';
        end
    end
else
    if oneMeterSize >= minLength
        unit = 1; unitText = '1 m';
    elseif oneMeterSize < minLength
        unit = 10; unitText = '10 m';
        oneMeterSize = oneMeterSize * 10;
        if oneMeterSize > maxLength
            unit = 1; unitText = '1 m';
        end
        if oneMeterSize < minLength
            unit = 10; unitText = '100 m';
            oneMeterSize = oneMeterSize * 10;
            if oneMeterSize > maxLength
                unit = 10; unitText = '10 m';
            end
            if oneMeterSize < minLength
                unit = 10; unitText = '1000 m';
            end
        end
    end
end