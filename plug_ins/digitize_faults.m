function digitize_faults(varargin)
%DIGITIZE07  Digitze points on an image using the mouse  
%   DIGITIZE07(filename) displays an image and allows the user to 
%   digitize points using the mouse, similar to MATLAB's built-in GINPUT
%   and similar to other digitizers available at the MATLAB Central File
%   Exchange: 'digitize','digitize2.m', etc.  The main new feature of
%   this version is that points are draggable; this permits fine tuning
%   of already digitized points using the zoom feature.  
%   
%   Other features adopted from previous versions include:
%       - Import previously digitized points
%       - Export digitized points to the workspace or file
%       - Interactively change the marker color, size, and shape
%       - Pin digitized points (i.e. toggle draggable mode)
%       - Delete unwanted points by right-clicking on the point
%       - Fully interactive GUI:  Errors are reported to dialog boxes
%         rather than to the Workspace
%
%   DIGITIZE07(filename) opens an interactive GUI and allows the user to
%   digitize an unlimited number of points.  The file must be an image that
%   is recognized by IMREAD
%
%   DIGITIZE07 by itself opens the digitizer and prompts the use to load an image file 
% 
%
%USING THE GUI:
% (a) Digitizing points.  Point-and-click (left or right button to create a new point).
% (b) Drag a new point.  Hold the button you used to create the point and
%     drag it to a new location.  A point may be dragged anywhere within
%     the axes boundaries.
% (c) Drag an existing point.  Left-click and hold to drag.
% (d) Disable/enable drag.  Use the pin toggle button on the left of the
%     figure's toolbar.  This will pin all existing points.  New points are
%     still draggable.
% (e) Other features.  Other menu features and the zoom tool are self-explanatory.  
%
%
%   See also GINPUT
%
%
%   Acknowledgements:
%   This was developed based on the functions "draggable" and "digitize2"
%   which are both available from the MATLAB Central File Exchange.
%
%   Author:
%   Todd C Pataky (0todd0@gmail.com)  ['zero' todd 'zero'@gmail.com]
%   18-April-2007


%IMPLEMENTATION NOTES:
%   1. The handles of digitized points are stored as application data in
%   the image's axes.  These handles are passed into different callback
%   functions which allows for easy implementation of dragging using the
%   figure properties: WindowButtonMotionFcn and WindowButtonUpFcn
%   2. The digitizer uses Figure 1 to open the image.  If Figure 1 already
%   existis it will be cleared.
%   3. Features for a future version:
%       - Display point labels
%       - Reorder points
%       - Connect points
%       - Create reference axes
%       - Calibration (scale image coordinates to mm, m, etc.)
%





%% PRELIMINARY DATA CHECKS

%%%%%%%%%%%%%%%%%%%%%
%(1) Ensure proper argument specification:
%%%%%%%%%%%%%%%%%%%%%
switch nargin
    case 0
        initializeFigure  %see INITIALIZATION FUNCTIONS below
        initializeAxes([])
    case 1
        try  %Attempt to initiate the GUI:
            imfinfo(varargin{1});  %This will generate an error if not recognized by IMREAD
            initializeFigure
            initializeAxes(varargin{1})
        catch
            fprintf('\n\n\nError opening file.\n')
            fprintf('  Please ensure that the file exists\n')
            fprintf('  and that its format is recognized by ''imread.m''\n');
            error(lasterror)
        end
    otherwise
        error('Maximum of one input argument.')
end
%%%%%%%%%%%%%%%%%%%%%
%(2) Check Workspace for existence of 'XY':
%%%%%%%%%%%%%%%%%%%%%
if evalin('base','exist(''XY'');')==1
    msgbox(['The variable XY exists in the Workspace.                               ',...
        'Selecting ''Export XY''...''To Workspace'' will overwrite the current XY data.'],...
        'Warning!','warn')
end






%% INITIALIZATION FUNCTIONS

function initializeFigure
figure(1)
clf
set(gcf,'numberTitle','off','name','Digitize Faults')
set(gcf,'menubar','none','closeRequestFcn',@closeFigure)
%%%%%%%%%%%%%%%%%%%%%%%%%
%CREATE MENU
%%%%%%%%%%%%%%%%%%%%%%%%%
%(a) Load functions
%%%%%%%%%%%%%%%%%%%%%%%%%
mh = uimenu(gcf,'Label','Load','separator','on');
uimenu(mh,'Label','Image...','callback',@callback_loadImage);
% uimenu(mh,'Label','Points...','callback',@callback_loadPoints);

%%%%%%%%%%%%%%%%%%%%%%%%%
%(b) Export functions
%%%%%%%%%%%%%%%%%%%%%%%%%
mh = uimenu(gcf,'Label','Export XY');
uimenu(mh,'label','To Workspace','callback',@callback_export2Base)
% uimenu(mh,'label','To .mat File...','callback',{@callback_export2File,'.mat'},'separator','on')
uimenu(mh,'label','To .dat File...','callback',{@callback_export2File,'.dat'})
% uimenu(mh,'Label','To .dat File...','callback',@callback_export2dat)
%%%%%%%%%%%%%%%%%%%%%%%%%
%(c) Marker style functions
%%%%%%%%%%%%%%%%%%%%%%%%%
mh = uimenu(gcf,'Label','Marker Style');
mh1 = uimenu(mh,'Label','Color');
    uimenu(mh1,'Label','Static Color...','callback',@callback_changeStaticColor);
    uimenu(mh1,'Label','Dragging Color...','callback',@callback_changeDragColor);
uimenu(mh,'Label','Size...','callback',@callback_changeMarkerSize);
mh2 = uimenu(mh,'Label','Symbol');
    uimenu(mh2,'Label','+  Plus sign','callback',{@callback_changeSymbol,'+'})
    uimenu(mh2,'Label','o  Circle','callback',{@callback_changeSymbol,'o'})
    uimenu(mh2,'Label','*  Asterisk','callback',{@callback_changeSymbol,'*'})
    uimenu(mh2,'Label','.  Point','callback',{@callback_changeSymbol,'.'})
    uimenu(mh2,'Label','x  Cross','callback',{@callback_changeSymbol,'x'})
    uimenu(mh2,'Label','s  Square','callback',{@callback_changeSymbol,'s'})
    uimenu(mh2,'Label','d  Diamond','callback',{@callback_changeSymbol,'d'})
    uimenu(mh2,'Label','^  Triangle (up)','callback',{@callback_changeSymbol,'^'},'separator','on')
    uimenu(mh2,'Label','v  Triangle (down)','callback',{@callback_changeSymbol,'v'})
    uimenu(mh2,'Label','>  Triangle (right)','callback',{@callback_changeSymbol,'>'})
    uimenu(mh2,'Label','<  Triangle (left)','callback',{@callback_changeSymbol,'<'})
    uimenu(mh2,'Label','p  Pentagram','callback',{@callback_changeSymbol,'p'},'separator','on')
    uimenu(mh2,'Label','h  Hexagram','callback',{@callback_changeSymbol,'h'})
%%%%%%%%%%%%%%%%%%%%%%%%%
%CREATE TOGGLE ICONS:
%%%%%%%%%%%%%%%%%%%%%%%%%
ht = uitoolbar;
%%%%%%%%%%%%%%%%%%%%%%%%%
%(a) Pin points
%%%%%%%%%%%%%%%%%%%%%%%%%
% [x,map] = imread([matlabroot,'\toolbox\matlab\icons\pin_icon.gif']);
[x,map] = imread([matlabroot,'/toolbox/matlab/icons/pin_icon.gif']);
cdata = ind2rgb(x,map);
cdata(cdata==1)=NaN;
uitoggletool(ht,'cdata',cdata,'TooltipString','Pin Points',...
    'onCallback', 'setappdata(gca,''pinPoints'',1)',...
    'offCallback','setappdata(gca,''pinPoints'',0)');
%%%%%%%%%%%%%%%%%%%%%%%%%
%(b) Zoom tool
%%%%%%%%%%%%%%%%%%%%%%%%%
% fname = [matlabroot,'\toolbox\matlab\icons\zoomplus.mat'];
fname = [matlabroot,'/toolbox/matlab/icons/zoomplus.mat'];
load(fname)  %var name: 'cdata' (stored in zoomplus.mat)
uitoggletool(ht,'cdata',cdata,'TooltipString','Zoom','clickedCallback','zoom');

fname = [matlabroot,'/toolbox/matlab/icons/zoomminus.mat'];
load(fname)  %var name: 'cdata' (stored in zoomplus.mat)
uitoggletool(ht,'cdata',cdata,'TooltipString','Zoom minus','clickedCallback','zoom');

% [x,map] = imread([matlabroot,'/toolbox/matlab/icons/pin_icon.gif']);
% cdata = ind2rgb(x,map);
% cdata(cdata==1)=NaN;
% uitoggletool(ht,'cdata',cdata,'TooltipString','Pin Points',...
%     'onCallback', 'setappdata(gca,''pinPoints'',1)',...
%     'offCallback','setappdata(gca,''pinPoints'',0)');

function initializeAxes(fname,varargin)
axes('position',[0.05 0.05 0.9 0.9])
%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize application data:
%%%%%%%%%%%%%%%%%%%%%%%%%
setappdata(gca,'axlim',[])  %required for dragging points
setappdata(gca,'H',[])
setappdata(gca,'pinPoints',0)
setappdata(gca,'nfault',1) 
setappdata(gca,'h_nfault',[])  % handle # and number of fault (same number if dif points on same seg.)
setappdata(gca,'fname',[])  % name of the target fault
setappdata(gca,'nclick',1); % number of clicks to identify the points
setappdata(gca,'edges',[]); % a vector of [upperleft-x upperleft-y lowerright-x lowerright-y]
if nargin==1
    markerSpecs = struct('statColor',[0 0 1],'dragColor',[1 0 0],'size',6,'style','o');
    setappdata(gca,'markerSpecs',markerSpecs)
else setappdata(gca,'markerSpecs',varargin{1})
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Create message or display image
%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(fname)
    th = text(0.5,0.5,'Please load an image to begin.');
    set(th,'fontsize',14,'horizontalalignment','center','verticalalignment','middle',...
        'backgroundcolor',0.9*[1 1 1],'edgecolor','k')
    axis off
else displayImage(fname)
end





function displayImage(fname)


X = imread(fname);
ih = imagesc(X);
setappdata(gca,'nclick',1); % number of clicks to identify the points

    prompt = {'longitude(deg) at upper-left corner?','latitude(deg)  at upper-left corner?',...
        'longitude(deg) at lower-right corner?','latitude(deg) at lower-right corner?'};
    dlg_title = 'Input the position'; num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    a1 = str2double(answer{1}); a2 = str2double(answer{2});
    a3 = str2double(answer{3}); a4 = str2double(answer{4});
    setappdata(gca,'edges',[a1 a2 a3 a4])
    
set(ih,'buttonDownFcn',@d07_createPoint);
axis equal tight
hold on
axlim = [get(gca,'xlim') get(gca,'ylim')];
setappdata(gca,'axlim',axlim);

    x = get(gca,'XLim');
    xunit = abs(a3 - a1) / (x(2) - x(1));
    setappdata(gca,'x2lon',xunit);
    y = get(gca,'YLim');
    yunit = abs(a2 - a4) / (y(2) - y(1));
    setappdata(gca,'y2lat',yunit);




%% MAIN DIGITIZING CODE

function d07_createPoint(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
xy = get(gca,'CurrentPoint');  %CurrentPoint yields two output rows
xy = xy(1,1:2);
setappdata(gca,'nclick',getappdata(gca,'nclick') + 1);
getappdata(gca,'nclick');
% if getappdata(gca,'nclick')==2
%     prompt = {'longitude(deg) at point 1?','latitude(deg) at point 1?',...
%         'longitude(deg) at point 2?','latitude(deg) at point 2?'};
%     dlg_title = 'Input the position'; num_lines = 1;
%     inputdlg(prompt,dlg_title,num_lines)
% end

h = d07_plotPoints(xy);
setappdata(gca,'H',[getappdata(gca,'H'); h]);
setappdata(gca,'h_nfault',[getappdata(gca,'h_nfault');...
    h getappdata(gca,'nfault')]);  % handle number & fault number
%Enable dragging until button is released:


seltype = get(gcf,'SelectionType');
if strcmp('alt',seltype)        % Push right button to end the fault segment
%     disp('You just click the right button.');

    setappdata(gca,'nfault',getappdata(gca,'nfault')+1);
    prompt = {'Enter segment name'};
    dlg_title = 'Input segment name';
    num_lines = 1;
%    def = {'20','hsv'};
%    answer = inputdlg(prompt,dlg_title,num_lines,def);
    setappdata(gca,'fname',[getappdata(gca,'fname') inputdlg(prompt,dlg_title,num_lines)]);
    
else
    set(gcf,'WindowButtonMotionFcn',{@d07_dragPoint,h},'WindowButtonUpFcn',{@d07_buttonUp,h});
end
getappdata(gca,'h_nfault');
getappdata(gca,'fname');
% set(gcf,'WindowButtonMotionFcn',{@d07_dragPoint,h},'WindowButtonUpFcn',{@d07_buttonUp,h})




function [H] = d07_plotPoints(XY)
%%%%%%%%%%%%%%%%%%%%%%%%%
H = zeros(size(XY,1),1);
for k=1:size(XY,1)
    H(k) = plot(XY(k,1),XY(k,2),'.');
    %Create context menu for deleting points:
    cmenu = uicontextmenu;
    uimenu(cmenu, 'Label', 'Delete this point','Callback', {@deletePoint,H(k)});
    uimenu(cmenu, 'Label', 'Delete all points...','Callback', @deleteAllPoints,'separator','on');
    set(H(k),'UIContextMenu', cmenu)
end
markerSpecs = getappdata(gca,'markerSpecs');
set(H,'Color',markerSpecs.statColor,...
    'MarkerSize',markerSpecs.size,...
    'Marker',markerSpecs.style,...
    'ButtonDownFcn',@d07_clickPoint);

        


function d07_clickPoint(h,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
if ~getappdata(gca,'pinPoints')
    markerSpecs = getappdata(gca,'markerSpecs');
    set(h,'color',markerSpecs.dragColor)
    set(gcf,'WindowButtonMotionFcn',{@d07_dragPoint,h},'WindowButtonUpFcn',{@d07_buttonUp,h})
end





function d07_dragPoint(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
h = varargin{3};
markerSpecs = getappdata(gca,'markerSpecs');
set(h,'color',markerSpecs.dragColor)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that the dragged point lies within the axis bounds:
%%%%%%%%%%%%%%%%%%%%%%%%%
axlim = getappdata(gca,'axlim');
X = get(gca,'currentpoint');
[x,y] = deal(X(1,1),X(1,2));
if x<axlim(1)
    x=axlim(1);
elseif x>axlim(2)
    x=axlim(2);
end
if y<axlim(3)
    y=axlim(3);
elseif y>axlim(4)
    y=axlim(4);
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% Update marker position
%%%%%%%%%%%%%%%%%%%%%%%%%
set(h,'xdata',x,'ydata',y)




function d07_buttonUp(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
h = varargin{3};
markerSpecs = getappdata(gca,'markerSpecs');
set(h,'color',markerSpecs.statColor)
set(gcf,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[])






%% CALLBACK FUNCTIONS

function callback_loadImage(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if there are existing points
if ~isempty(getappdata(gca,'H'))
    button = questdlg(['Loading a new image will clear current points.  ',...
        'OK to continue?'],'Warning!!','OK','Cancel','OK');
    if isequal(button,'Cancel')
        return
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% Get an image file
[fname,pathName] = uigetfile('*.*');
if isequal(fname,0)
    return
end
markerSpecs = getappdata(gca,'markerSpecs');
delete(gca)
initializeAxes([pathName,fname],markerSpecs)
%     msgbox('Start from defining two points.')


function callback_loadPoints(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if an image has been loaded
if ~isempty(findobj(gca,'type','text'))
    errordlg('Please load an image before loading points.','Error')
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if there are existing points
if ~isempty(getappdata(gca,'H'))
    button = questdlg(['Loading new points will clear current points.  ',...
        'OK to continue?'],'Warning!!','OK','Cancel','OK');
    if isequal(button,'Cancel')
        return
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a points file
[fname,pathName] = uigetfile({'*.dat','Data files (*.dat)';  '*.mat','MAT files (*.mat)'});
if isequal(fname,0)
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% Check that the data are in the correct format
ext = fname(end-3:end);
switch ext
    case '.dat'
        XY = load([pathName,fname]);
        if size(XY,2)~=2
            errordlg('Data must be an m-by-2 matrix.','Error')
            return
        end
    case '.mat'
        w = whos('-file',[pathName fname]);
        if length({w(:).name})>1
            errordlg('.mat file must contain only one variable.','Error')
            return
        elseif w.size(2)~=2 || length(w.size)~=2
            errordlg('Data must be an m-by-2 matrix','Error')
            return
        else load([pathName,fname])
             eval(['XY = ',w.name,';'])
        end
    otherwise
        errordlg('Must only load .dat or .mat files.','Error')
        return
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%Check that the data fall within the axes boundaries
axlim = getappdata(gca,'axlim');
if min(XY(:,1)) < axlim(1) ||...
        max(XY(:,1)) > axlim(2) ||...
        min(XY(:,2)) < axlim(3) ||...
        max(XY(:,2)) > axlim(4)
    errordlg('Loaded points must be inside axes boundaries.','Error')
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%Delete old data:
delete(getappdata(gca,'H'))
%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot new data
H = d07_plotPoints(XY);
setappdata(gca,'H',H)




function callback_export2Base(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
[XY] = getXY;
if isempty(XY)
    msgbox('No existing points.  Please digitize at least one point before exporting.',...
        'Warning!','warn')
else
    assignin('base','XY',XY)
    msgbox('Data exported to Workspace.  Variable name: ''XY''')
end

%=========================================================
function callback_export2File(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for existing points
[XY] = getXY;
if isempty(XY)
    msgbox('No existing points.  Please digitize at least one point before exporting.',...
        'Warning!','warn')
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%
    nseg = getappdata(gca,'h_nfault');
    nmax = max(nseg(:,2));
    xunit = getappdata(gca,'x2lon');
    yunit = getappdata(gca,'y2lat');
    a = getappdata(gca,'edges');
    H = getappdata(gca,'H');
	TAG = getappdata(gca,'nfault');
    fname = getappdata(gca,'fname');
    X = a(1) + cell2mat(get(H,'xdata'))*xunit;
    Y = a(2) - cell2mat(get(H,'ydata'))*yunit;
% if length(H)>1
%     XY = cell2mat(XY);
% end
%    filename = 'digitized.dat'; % default file name
    [filename,pathname] = uiputfile('digitized.dat',...
        ' Save digitized data As');
    fid = fopen(filename,'wt');
    ncounter = 1;
    ndummy = 100;
    for i = 1:nmax
        fprintf(fid,'\n');
        fprintf(fid,[cell2mat(fname(i)) '   < \n']);
        for j = 1:ndummy
            if ncounter > length(X)
                break
            end
        if nseg(ncounter,2)==i
            fprintf(fid,'%10.4f %10.4f',[X(ncounter) Y(ncounter)]);
            fprintf(fid,'\n');
            ncounter = ncounter + 1;
        end
        end
    end
    fclose(fid); 


% %**************************************************************
% function callback_export2dat
% %%%%%%%%%%%%%%%%%%%%%%%%%
% % Check for existing points
% [XY] = getXY;
% if isempty(XY)
%     msgbox('No existing points.  Please digitize at least one point before exporting.',...
%         'Warning!','warn')
%     return
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%
%     nseg = getappdata(gca,'h_nfault');
%     nmax = max(nseg(:,2));
%     xunit = getappdata(gca,'x2lon');
%     yunit = getappdata(gca,'y2lon');
%     filename = 'digitized.dat'; % default file name
%     fid = fopen(filename,'wt');
%     for i = 1:nmax
%         fprintf(fid,'dummy\n');
%         fprintf(fid,'%10.4f %10.4f',XY);
%     end
%     fclose(fid); 


function callback_changeStaticColor(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
markerSpecs = getappdata(gca,'markerSpecs');
c = uisetcolor(markerSpecs.statColor,'Choose Marker Color');
if ~isequal(c,0)
    markerSpecs.statColor = c;
    set(getappdata(gca,'H'),'color',c)
    setappdata(gca,'markerSpecs',markerSpecs)
end


function callback_changeDragColor(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
markerSpecs = getappdata(gca,'markerSpecs');
c = uisetcolor(markerSpecs.dragColor,'Choose Marker Color');
if ~isequal(c,0)
    markerSpecs.dragColor = c;
    setappdata(gca,'markerSpecs',markerSpecs)
end





function callback_changeMarkerSize(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
markerSpecs = getappdata(gca,'markerSpecs');
a = inputdlg({'Enter marker size:'},'',1,{num2str(markerSpecs.size)});
if ~isempty(a)
    a = str2double(a{1});
    try
        H = getappdata(gca,'H');
        set(H,'markersize',a)
        markerSpecs.size = a;
        setappdata(gca,'markerSpecs',markerSpecs)
    catch
        err = lasterror;
        errordlg(err.message,'Marker Size Error')
        return
    end
end




function callback_changeSymbol(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
symbol = varargin{3};
H = getappdata(gca,'H');
set(H,'marker',symbol)
markerSpecs = getappdata(gca,'markerSpecs');
markerSpecs.style = symbol;
setappdata(gca,'markerSpecs',markerSpecs)






function deletePoint(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
h = varargin{3};
H = getappdata(gca,'H');
H(H==h)=[];
setappdata(gca,'H',H)
delete(h)




function deleteAllPoints(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
button = questdlg('OK to delete all points?','Warning!!','OK','Cancel','OK');
if isequal(button,'Cancel')
    return
end
delete(getappdata(gca,'H'))
setappdata(gca,'H',[])





function closeFigure(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
button = questdlg('Export data to Workspace before closing?',...
    '','Export&Close','Close','Cancel','Export&Close');
switch button
    case 'Export&Close'
        [XY] = getXY;
        assignin('base','XY',XY)
        fprintf('\n\nData imported from Digitize2D:\n')
        fprintf('   Name: ''XY''\n')
        fprintf('   Size: [%.0f %.0f]\n\n',size(XY))
        delete(gcf)
    case 'Close'
        delete(gcf)
    case 'Cancel'
        return
end







%% UTILITY FUNCTIONS


function [XY] = getXY
H = getappdata(gca,'H');
TAG = getappdata(gca,'nfault');
XY = [get(H,'xdata') get(H,'ydata')];
if length(H)>1
    XY = cell2mat(XY);
end






