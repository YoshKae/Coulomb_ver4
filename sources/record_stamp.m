function record_stamp(hw,x,y,varargin)
global INODAL % hate to add this but cannot help doing this for nodal plane identification

% This function put a stamp describing date, file name, and eventually
% other info.
% AuthorizedOptions = {'SoftwareVersion',...
%                     'FileName',...
%                     'LineSpace',...
%                     'SectionFlag',...
%                     'FunctionType',...
%                     'StressType',...
%                     'DepthType',...
%                     'DepthMin',...
%                     'DepthMax',...
%                     'Friction',...
%                     'Depth',...
%                     'Strike',...
%                     'Dip',...
%                     'Rake',...
%                     'FontName',...
%                     'FontSize',...
%                     'SectionStartX',...
%                     'SectionStartY',...
%                     'SectionFinishX',...
%                     'SectionFinishY',...
%                     'SectionDip'};

AuthorizedOptions = {'SoftwareVersion',...
                    'FileName',...
                    'LineSpace',...
                    'SectionFlag',...
                    'FunctionType',...
                    'StressType',...
                    'DepthType',...
                    'DepthMin',...
                    'DepthMax',...
                    'Friction',...
                    'Depth',...
                    'Strike',...
                    'Dip',...
                    'Rake',...
                    'FontName',...
                    'FontSize',...
                    'SectionStartX',...
                    'SectionStartY',...
                    'SectionFinishX',...
                    'SectionFinishY',...
                    'SectionDip'};
for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 'in' 21,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end

if(isempty(x)||isempty(y))
    error('Empty coordinates passed to record_stamp');
end

% --- default values ----------------
    SoftwareVersion = '3.0.1';
	FileName        = 'Untitled';
	LineSpace        = 5.0;
	SectionFlag     = 0;
    FunctionType    = 1;
	StressType      = 5;
	DepthType       = 0;
    DepthMin        = 0;
    DepthMax        = 20;
	Friction        = 0.4;
	Depth           = 10.0;
	Strike          = 90.0;
	Dip             = 90.0;
	Rake            = 180.0;
    FontName        = 'Arial';
    FontSize        = 10;
	SectionStartX   = -100;
	SectionStartY   = -100;
	SectionFinishX  = 100;
	SectionFinishY  = 100;
	SectionDip      = 90;
    DateStamp = datestr(now,0); % automatic
% -----------------------------------

v = parse_pairs(varargin);  % internal function seen in this file.
for j = 1:length(v)
    eval(v{j});             % might be changed for MATLAB compiler.
end

if FunctionType >= 1 && FunctionType <= 6
    if FunctionType == 1
        calc_stamp = 'Map view grid';
    elseif FunctionType == 2
        calc_stamp = 'Horizontal vectors';
    elseif FunctionType == 3
        calc_stamp = 'Deformed wireframe';
    elseif FunctionType == 4
        calc_stamp = 'Vertical displacement';
    elseif FunctionType == 6
        calc_stamp = 'Strain calc.';
    else
        calc_stamp = '---';
    end
    if SectionFlag == 0
        depth_stamp = ['  Depth: ',num2str(Depth,'%6.2f'),' km'];
    else
        calc_stamp = ' ';
        depth_stamp = [' A(',num2str(SectionStartX),',',num2str(SectionStartY),') --- B(',...
            num2str(SectionFinishX),',',num2str(SectionFinishY),')'];
    end

    h3_stamp = [calc_stamp,depth_stamp];
elseif FunctionType >= 7 && FunctionType <=9
    switch StressType
        case 1
            calc_stamp = 'Opt. oriented faults';
        case 2
            calc_stamp = 'Opt. strike-slip faults';
        case 3
            calc_stamp = 'Opt. thrust faults';
        case 4
            calc_stamp = 'Opt. normal faults';
        case 5
            calc_stamp = ['Specified faults: ',num2str(Strike),'/',...
                num2str(Dip),'/',num2str(Rake)];            
        otherwise
            calc_stamp = '---';    
    end
    fric_stamp  = ['  Friction: ',num2str(Friction,'%4.2f')];
    if SectionFlag == 0
        depth_stamp = ['  Depth: ',num2str(Depth,'%6.2f'),' km'];
        if DepthType == 1 |DepthType == 2   % maximum value pickup (1) and mean (2)
            depth_stamp = ['  Depth: ',num2str(DepthMin),'-',...
                            num2str(DepthMax),' km'];  
        end
    else
        depth_stamp = [' A(',num2str(SectionStartX),',',num2str(SectionStartY),') --- B(',...
            num2str(SectionFinishX),',',num2str(SectionFinishY),') dip ',num2str(SectionDip),' deg.'];
    end
    h3_stamp = [calc_stamp,depth_stamp,fric_stamp];
else
    if INODAL == 1
            calc_stamp = 'Stress on nodal plane 1';  
    elseif INODAL == 2
            calc_stamp = 'Stress on nodal plane 2'; 
    else
            calc_stamp = 'Stress on randomly selected nodal planes'; 
    end
%    depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
    depth_stamp = ['  Depth: --- km'];
    fric_stamp  = ['  Friction: ',num2str(Friction,'%4.2f')];
%    fric_stamp  = ['  Friction: ',num2str(fric,'%4.2f')];
    h3_stamp = [calc_stamp,fric_stamp];    
end

% underscore _ treatment
FileNameRep = strrep(FileName,'_','\_');    % MATLAB is using LaTex expression

figure(hw);
hold on;
h1 = text(x,y,['Coulomb ' SoftwareVersion ' ' DateStamp ' ' FileNameRep]);
h2 = text(x,y-1.0*LineSpace,h3_stamp);
set(h1,'HorizontalAlignment','right','FontSize',FontSize,'FontName',FontName);
set(h2,'HorizontalAlignment','right','FontSize',FontSize,'FontName',FontName);


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