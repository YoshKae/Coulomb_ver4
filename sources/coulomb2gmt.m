function coulomb2gmt(varargin)
% This function put a stamp describing date, file name, and eventually
% other info.
% AuthorizedOptions = {'SoftwareVersion',...
%                     'FileName',...
%                     'FunctionType',...
%                     'ProjectionType',...
%                     'StudyArea',...
%                     'MapSize',...
%                     'XShift',...
%                     'YShift'};

AuthorizedOptions = {'SoftwareVersion',...
                    'FileName',...
                    'Title',...
                    'FunctionType',...
                    'ProjectionType',...
                    'StudyArea',...
                    'MapSize',...
                    'XShift',...
                    'YShift',...
                    'XIncrement',...
                    'YIncrement',...
                    'FaultClip',... % 5 rows & 2 columns (lon. & lat.) x number of elements
                    'OutputFName'};
for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 'in' 21,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end

% --- default values ----------------
    SoftwareVersion = '3.X.X';
	FileName        = 'Untitled';
    Title           = 'Untitled';
    FunctionType    = 1;
	StressType      = 5;
    ProjectionType  = 'JM';
	StudyArea       = '136.0/140.0/36.0/39.0';
    MapSize         = 5;
    XShift          = 0.0;
    YShift          = 0.0;
    XIncrement      = 0.1;          % degree
    YIncrement      = 0.1;          % degree
    Pen1            = '1/0/0/0';    
    Pen2            = '2/255/1/1';
    LandColor       = '255/200/125';
    SeaColor        = '80/130/180';
    CoastlineRes    = 'Df';
    FaultClip       = [136.8 36.5; 137.7 37.9; 137.2 38.65; 139.0 38.3; 136.8 36.5];
    OutputFName     = 'out.gmt';
% -----------------------------------

v = parse_pairs(varargin);  % internal function seen in this file.
for j = 1:length(v)
    eval(v{j});             % might be changed for MATLAB compiler.
end

%----- write GMT script --------------------------
% pscoast
timestamp = date;
header1  = ['# GMT script converted from Coulomb ' timestamp];
pscoast1 = ['pscoast -R' StudyArea ' -' ProjectionType num2str(MapSize,'%3i') ' '];
pscoast2 = ['-G' LandColor ' -S' SeaColor ' -' CoastlineRes]; 
pscoast3 = [' -Ba1.0f0.5g0.1:"Longitude"::,"‹":/a1.0f0.5g0.1:"Latitude"::,"‹":'];
pscoastend = [' -K -P -U > out.ps'];
dlmwrite(OutputFName,header1,'delimiter','');
dlmwrite(OutputFName,[pscoast1 pscoast2 pscoast3 pscoastend],'-append','delimiter','');
% psxy for fault lines
psxy1    = ['psxy -R -' ProjectionType ' -W' Pen2 ' -P -O -K << END >> out.ps'];
psxyend  = 'END';
dlmwrite(OutputFName,psxy1,'-append','delimiter','');
dlmwrite(OutputFName,FaultClip,'-append','delimiter',' ');
dlmwrite(OutputFName,psxyend,'-append','delimiter','');

% psxy -R -JM -: -W2/255/0/0 -M -P -O -K ${ffile}>>${psfile}



%=======================================================================
function v = parse_pairs(pairs)
v = {}; 
for ii=1:2:length(pairs(:))  
    if isnumeric(pairs{ii+1})
        str = [ pairs{ii} ' = ' num2str(pairs{ii+1}),';'  ];
    else
        str = [ pairs{ii} ' = ' 39 pairs{ii+1} 39,';'  ];
    end
    v{(ii+1)/2,1} = str;
end