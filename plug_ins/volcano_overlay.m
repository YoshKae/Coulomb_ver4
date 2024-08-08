function volcano_overlay(varargin)
global H_MAIN VOLCANO ICOORD
global PREF

AuthorizedOptions = {'EruptionType',...
                    'SymbolType',...
                    'MarkerEdgeColor',...
                    'MarkerFaceColor',...
                    'MarkerSize',...
                    'LabelToggle',...
                    'FontName',...
                    'FontSize'};
for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 'in' 21,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end

fileread = 2; % 1: ascii, 2: binary

% --- default values ----------------
    EruptionType    = 'all';
	SymbolType      = '^';
	MarkerEdgeColor = [.1 .1 .1];
%	MarkerFaceColor = [.9 .9 .1];
    MarkerFaceColor = PREF(9,1:3);
    MarkerSize      = 10;
	LabelToggle     = 'Off';
	FontName        = 'Helvetica';
    FontSize        = 14;
% -----------------------------------
v = parse_pairs(varargin);  % internal function seen in this file.
for j = 1:length(v)
    eval(v{j});             % might be changed for MATLAB compiler.
end


% Instruction to write your own plug-in script
%
% first set the handvisibility for the main window on

%***************************************************
set(H_MAIN,'HandleVisibility','on');
%***************************************************
h = figure(H_MAIN);
if ~isempty(findobj('Tag','VolcanoObj'))
    c = findobj('Tag','VolcanoObj');
    delete(c);
end

if isempty(VOLCANO)
    if fileread == 1
% ASCII data reading (now off, commented)
    [filename,pathname] = uigetfile({'*.*'},' Open volcano file');
    if isequal(filename,0)
        return
    else
        disp('  ----- volcano data -----');
        disp(['  User selected', fullfile(pathname, filename)]);
    end
	myData = textread(fullfile(pathname, filename), '%s', 'delimiter', '\n', 'whitespace', '');
    n = size(myData,1)/9; % 9 columns from NOAA format
    j = 1;
    for i = 1:n
        j = 1 + (i - 1) * 9;
        VOLCANO(i).number  = (myData{j}(:))';      % number
        VOLCANO(i).name    = (myData{j+1}(:))';    % volcano name
        VOLCANO(i).region  = (myData{j+2}(:))';    % region
        VOLCANO(i).lat     = str2double((myData{j+3}(:))');    % latitude
        VOLCANO(i).lon     = str2double((myData{j+4}(:))');    % longitude
        VOLCANO(i).elev    = str2double((myData{j+5}(:))');    % elevation
        VOLCANO(i).type    = (myData{j+6}(:))';    % type
        VOLCANO(i).status  = (myData{j+7}(:))';    % status
        VOLCANO(i).lasterp = (myData{j+8}(:))';    % last know eruption
    end
    elseif fileread == 2
    try
        load -mat volcanoes_NGDC_NOAA.mat;
    catch
        errordlg('volcanoes_NGDC_NOAA.mat not found.','File Error');
    end
    end
end   
    % plot
        x = [VOLCANO(:).lon];
        y = [VOLCANO(:).lat];
    if ICOORD == 1
        xy = lonlat2xy([x' y']);
        x = xy(:,1)';
        y = xy(:,2)';
    end
        hold on;
        a = plot(x,y,SymbolType,...
            'MarkerFaceColor',MarkerFaceColor,...
            'MarkerEdgeColor',MarkerEdgeColor,...
            'MarkerSize',MarkerSize);
%         posshift = 5;
%         hold on;
%         b = text(x,y,VOLCANO(nn).name);
%         set(b,'FontSize',FontSize);
        set(a,'Tag','VolcanoObj');
    %   
%***************************************************   
set(H_MAIN,'HandleVisibility','callback');
%***************************************************

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