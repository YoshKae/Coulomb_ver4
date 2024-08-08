function more_overlay_plot(varargin)

global H_MAIN ICOORD LON_GRID PREF

    matdata = [];
    rgb     = [0.9 0.1 0.2];
    width   = 0.6;
    
if nargin == 0
    disp('   Please put a binary type EQ data as an argument')
    disp('     e.g., more_overlay_plot(EQ_DATA2)');
    disp('   you can also change the color assigning the second argument');
    disp('     e.g., more_overlay_plot(EQ_DATA2, [0.0 0.0 1.0])'); 
elseif nargin == 1
    matdata = varargin{1};
elseif nargin == 2
	matdata = varargin{1};
	rgb     = varargin{2};
else
  	matdata = varargin{1};
	rgb     = varargin{2};
    width   = varargin{3}; % does not work anymore
end

% ---------------------------- actual plotting --------------
% handvisibility on for main graphic window
set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);

if isempty(matdata)~=1
    hm = wait_calc_window;
    if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
    end
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hold on;
        h = scatter(matdata(:,1),matdata(:,2),5*PREF(5,4));
    else
        hold on;
        h = scatter(matdata(:,16),matdata(:,17),5*PREF(5,4));
    end
    set(h,'MarkerEdgeColor',rgb); % white edge color for earthquakes 
    set(h,'Tag','EqObj2');
    hold on;
    close(hm);
else
    warndlg('No properly formatted data exist.','!!Warning!!');
end

set(H_MAIN,'HandleVisibility','callback');