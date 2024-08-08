function [pos] = progressbar(varargin);
% Displays a multi leveled progressbar. This makes it easy to nest
% computations and still have a easy interpretable progress indication.
%
% The normal usage is the subsequent calling of these 3 functions:
%
% progressbar('start', [firstVal lastVal], description, ... ); 
%        alternative: progressbar('descend', .. );  
%     Creates a new progressbar (when none exists), or adds a new level to
%     the current progressbar. 
%   [lastVal] or [firstVal lastVal]:
%     This is the range that the progressbar should span, 
%     firstVal (default = 0) implies 0% progress, 
%     lastVal (default = 1) implies 100% progress. 
%   description:
%     Set description to display the current action in the progressbar title.
%   remaining inputs are treated as option value pairs, see further down.
%
% progressbar(newPos, caption)
%   newPos: a scalar numerical argument.
%     Sets the current progressbar level to the desired position, the
%     percentage is computed with respect to the firstVal-lastVal value pair
%     given in the start of this level.
%   caption: optional string argument
%     Set caption to the axes title, display specific progess information.
%     (eg: How many loops have been done)
%
% progressbar('ready' , ... );
%        alternative: progressbar('ascend', ...); 
%   Completes current level of computation, when this was the last level
%   the progressbar is closed. Use this function at the end of a loop to
%   finish the progressbar.
%
%
% Other options, these can be combined; also with 'start' or 'ready' arguments
% [pos] = progressbar('position');
%   Last position the current progressbar was set too.
%   NaN is returned when no progressbar is available.
%
% progressbar('close');
%   Resets and closes the progressbar, use only to reset after a manual
%   break of the computations.
%
% progressbar('EstTimeLeft', 'on'/'off');
%   Display an estimate of the time remaining. This is only a good estimate
%   when (on the average) the progress is linear in time. An uncertainty
%   estimate is included as well.
%
% progressbar('minTimeInterval', interval);
%   Sets the minimum amount of clock time (in seconds) that has to have
%   passed since the last update of the progressbar, sets it for the
%   current level this value is the default for all levels below. 
%
%   Default value = 0 (all updates are displayed);
%
%   This option is provided since updating the progressbar may take a
%   significant amount of time when it's done very often (in a fast loop)
%   and more than (say) 10 updates per second are (usually) not useful for
%   the user.  
%
% progressbar('startStatistics', count);
%  Attempts to get count samples with statistics data from the current
%  progressbar. Call this at start time to get the statistics sampled over
%  the entire progress. Clears previous statistic gathering of the current
%  progressbar.
%
% progressbar('getStatistics');
%  Reads the gathered statistics of the current progressbar (so call it
%  before calling progressbar('close');). The results is a structure array
%  with interesting statistic fields about time and memory usage.
%
% progressbar('clearTimeEstimation');
%   Clears the time estimation history. Use this when the previous points
%   do not give an good indication of the computation time of the remaining
%   part. (for example when you restart the computation at a more accurate
%   level)
%
% progressbar('DebugButton','show'); / progressbar('DebugButton','hide');
%   Shows/hides a button with a caption 'Debug'. When this button is
%   pressed execution is stopped (dbstop). This allows you to dynamically
%   stop to debug your code, which is not possible otherwise. Note that
%   click events are only processed during pause or drawnow commands.
%   (progressbar uses drawnow to update the progressbar, but you might want
%   to add additional drawnow's in your code to more frequently allow a
%   break, as well as allowing screen updates)
%
% progressbar('debugstop');
%   Issues a breakpoint after processing all progressbar commands.
%
% Copyright Dirk Poot (Dirk.Poot@ua.ac.be)
%           University of Antwerp
% 

% Revision history, original version 20-6-2006
% 22- 6-2006 : lots of small improvements/debugging.
%  4- 8-2006 : added 'getStatistics' 
% 11- 9-2006 : added 'DebugButton', improved timeleft estimation
% 20- 9-2006 : enabled using in MATLAB 6.5 (might be broken again?)
% 30-10-2006 : improved handling of deleted object
% 13- 8-2007 : don't divide by zero on interval [0 0].
%  6- 9-2007 : improved help text.

persistent ProgBData
persistent GeneralData
if nargin<1
    error('progressbar needs arguments');
end;

if ischar(varargin{1})
  remInp = varargin;
  if isempty(GeneralData)
      if exist('timer')==2
          GeneralData.timer = timer('TimerFcn','progressbar(''Redraw'');', 'StartDelay', .5 , 'TasksToExecute',1);
      else
          GeneralData.timer = [];
      end;
      GeneralData.CurrIndex = 0;
      GeneralData.NeedDraw = 0;
      GeneralData.ProgB = [];
      GeneralData.doDebugStop = 0;
      GeneralData.DebugButton = [];
  end;
  while length(remInp)>=1
    index = GeneralData.CurrIndex;
    usedInputs = 2;
    switch lower(remInp{1})
        case {'descend', 'start'}
            if isempty(ProgBData)
%                 ProgBData=struct('StartStop',[],'minTimeInterval',[],'AxHndl',[],'PatchHndl',[],'title',[]);
                ProgBData=struct('StartStop',{},'minTimeInterval',{},'AxHndl',{},'PatchHndl',{},'title',{},'EstTimeHndl',{},'Times',{},'TimesUpdIndx',{},'LastUpd',{},'Statistics',{},'StatisticsCount',{});
                % StartStop : [start stop] indices, start = 0%; stop = 100%
                % minTimeInterval: minimum time interval, in units of 'now'.
            end;
            index = index+1;
            GeneralData.CurrIndex = index;
            if index <= 1
                ProgBData(1).minTimeInterval = 0;
                ProgBData(1).title = 'Progressbar';
            else
                ProgBData(index).minTimeInterval = ProgBData(index-1).minTimeInterval;
                % length ProgBData is increased by line above!
                ProgBData(index).title = ProgBData(index-1).title; 
            end;
            if length(remInp)<2 | length(remInp{2})<1
                value = 1;
                usedInputs = 1;
            else
                value = remInp{2};
            end;
            if length(remInp)>=3
                if ~isempty(remInp{3})
                    ProgBData(index).title = remInp{3}; 
                end;
                usedInputs = 3;

%                 if rem(nargin-3,2)
%                     error('option value pairs do not match');
%                 end;
            end;
            if length(value)<2
                value = [0 value];
            end;
            if abs(value(1) - value(2)) < eps* max(abs(value))
                value(2) = value(1) + 200*(realmin+eps * max(abs(value)));
            end;
            ProgBData(index).StartStop = value;
            ProgBData(index).LastUpd = [value(1) now];
            ProgBData(index).Statistics = [];
            
            GeneralData.NeedDraw = GeneralData.NeedDraw + 1;
%             ProgBData(index).EstTimeHndl = [];
%             progressbar('reposition');
%             remInp{end+1} = 'reposition';
            if ishandle(ProgBData(index).EstTimeHndl)
                set(ProgBData(index).EstTimeHndl,'String','');
            end;
            if ~isempty(GeneralData.timer) 
                if ~strcmp(get(GeneralData.timer,'Running'),'on')
                    start(GeneralData.timer);
                end;
            else
                remInp{end+1} = 'Redraw';
            end;
        case {'ascend','ready'}
            if index<=0
                warning('Cannot ascend to higher level when no higher level is present.');
                return;
            end;
            GeneralData.CurrIndex = index-1;
            if ~isempty(GeneralData.timer) 
                if ~strcmp(get(GeneralData.timer,'Running'),'on')
                    start(GeneralData.timer);
                end;
            else
                remInp{end+1} = 'Redraw';                
            end;
            GeneralData.NeedDraw = max(0,GeneralData.NeedDraw -1);
            usedInputs = 1;
        case 'redraw'
            usedInputs = 1;
                % create figure when there is none.
            if isempty(GeneralData.ProgB) | ~ishandle(GeneralData.ProgB)
%                 oldFig = [];
%                 if length(findobj('Type','figure'))>0
%                     oldFig = gcf;
%                 end;
                GeneralData.ProgB = 335965207; % random but constant figure number, high number to minimizes figure number clashes;
                while ishandle(GeneralData.ProgB)
                    GeneralData.ProgB = floor( rand * 2030832096 +1);
                end;
                GeneralData.ProgB = figure(GeneralData.ProgB);
                set(GeneralData.ProgB,'MenuBar', 'none', ...
                                'NumberTitle','off' ...
                                ,'HandleVisibility','off'...
                                ,'Visible','off'...
                  );
%                 % set focus back.
%                 if ~isempty(oldFig) 
%                     figure(oldFig);
%                 end;
            end;
            if GeneralData.NeedDraw>0
            
                for k= GeneralData.NeedDraw-1:-1:0
                    isnotvalid = isempty( ProgBData(index-k).AxHndl );
                    if ~isnotvalid 
                        isnotvalid = ~ishandle(ProgBData(index-k).AxHndl);
                    end;
                    if isnotvalid
%                       if ~activatedFig  
%                           set(GeneralData.ProgB,'HandleVisibility','on');
%                           figure(GeneralData.ProgB);
%                           activatedFig = 1;
%                       end;
                      ProgBData(index-k).AxHndl = axes('XLim',[0 1],...
                        'Box','on', ...
                        'YLim',[0 1],...
                        'XTickMode','manual',...
                        'YTickMode','manual',...
                        'XTick',[],...
                        'YTick',[],...
                        'XTickLabelMode','manual',...
                        'XTickLabel',[],...
                        'YTickLabelMode','manual',...
                        'YTickLabel',[]...
                        ,'parent',GeneralData.ProgB ...
                        );
                    end;
                    xpatch = [0 0 0 0];
                    ypatch = [0 0 1 1];
                    if ishandle(ProgBData(index-k).PatchHndl) % does handle empty correctely.
                        set( ProgBData(index-k).PatchHndl,'XData',xpatch);
                    else
%                         set(GeneralData.ProgB,'HandleVisibility','on');
%                         axes(ProgBData(index-k).AxHndl);
%                         activatedFig = 1;
                        ProgBData(index-k).PatchHndl = patch(xpatch,ypatch,'y','parent',ProgBData(index-k).AxHndl);
                    end;
                    if ProgBData(index-k).EstTimeHndl == -1
                        remInp{end+1} = 'MakeTimeLeftText';
                        remInp{end+1} = index-k;
                    end;
                end;
                GeneralData.NeedDraw = 0;
            end;
            if length(ProgBData)>index
                for k=length(ProgBData):-1:index+1
                    if ishandle(ProgBData(k).AxHndl)
                        delete(ProgBData(k).AxHndl);
                        ProgBData(k).AxHndl = [];
                        ProgBData(k).PatchHndl = [];
                        ProgBData(k).EstTimeHndl =[];
                    end;
%                     if ishandle(ProgBData(k).EstTimeHndl)
%                         delete(ProgBData(k).EstTimeHndl)
%                     end;
                    ProgBData(k)=[];
                end;
            end;
            if index<=0 %| isempty(ProgBData(index).AxHndl)
                if ishandle(GeneralData.ProgB)
                    set(GeneralData.ProgB,'visible','off');
                else 
                    remInp{1}= 'close';
                    usedInputs = 0;
                end;
            else
                remInp{end+1} = 'reposition';
            end;
        case 'reposition'
            if isempty(GeneralData.ProgB) | ~ishandle(GeneralData.ProgB)
                warning('No progressbar, so cannot modify it.');
                return;
            end;
            pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
            pos = get(GeneralData.ProgB,'Position');   
            
            width = 400 * pointsPerPixel; 
            height = (45+60*index) * pointsPerPixel;
            pos(1:2) = pos(1:2) - ([width height]-pos(3:4))/2;
            pos(3:4) = [width height];   
            set(GeneralData.ProgB,'Position',pos);        

            axPosStp = [0 -60*pointsPerPixel/height 0 0];
            axPos = [.1 1-5*pointsPerPixel/height .8 20* pointsPerPixel/height];
            if ~strcmp(get(GeneralData.ProgB,'visible'),'on')
                set(GeneralData.ProgB,'visible','on');
            end;
            for k=1:index
                if ishandle(ProgBData(k).AxHndl)
                    set(ProgBData(k).AxHndl,'Position',axPos+k*axPosStp);
                end;
            end;
            set(GeneralData.ProgB,'name',ProgBData(index).title);
            drawnow;
            usedInputs = 1;
        case 'position'
            if length(ProgBData)>=1 & ishandle(GeneralData.ProgB)
%                 lastPos = get( ProgBData(index).PatchHndl, 'XData');
%                 ststp = ProgBData(index).StartStop;
%                 pos = lastPos(2) * (ststp(2)-ststp(1)) + ststp(1);
                pos = ProgBData(index).LastUpd(1);    
            else
                pos = nan;
            end;
            usedInputs = 1;
        case 'close'
            if ishandle(GeneralData.ProgB)
%                 close(GeneralData.ProgB);
                delete(GeneralData.ProgB);
            end;
            GeneralData = [];
            ProgBData =[];
            usedInputs = 1;
            return;
        case 'mintimeinterval'
            ProgBData(index).minTimeInterval =  remInp{2} / 86400;
        case 'cleartimeestimation'
            ProgBData(index).Times = zeros(0,2);
            ProgBData(index).TimesUpdIndx = 0;
            usedInputs =1;
        case 'esttimeleft'
            if strcmpi(remInp{2},'on')
                if GeneralData.NeedDraw>0
                    if ishandle(ProgBData(index).EstTimeHndl) % treat empty correctely.
                    else
                        ProgBData(index).EstTimeHndl = -1;
                    end;
                else
                    remInp{1} = 'MakeTimeLeftText';
                    remInp{2} = index;
                    usedInputs = 0;
                end;
                ProgBData(index).Times = ProgBData(index).LastUpd;
            elseif strcmpi(remInp{2},'off')
                if ishandle(ProgBData(index).EstTimeHndl)
                    delete(ProgBData(index).EstTimeHndl);
                end;
                ProgBData(index).EstTimeHndl =[];
                ProgBData(index).Times = zeros(0,2);
            else
                error('set EstTimeLeft to [on/off]');
            end;
            ProgBData(index).TimesUpdIndx = 0;
        case 'maketimelefttext'
            index = remInp{2};
            if ishandle(ProgBData(index).EstTimeHndl) % takes care of empty handles.
                set(ProgBData(index).EstTimeHndl,'String',''); % clear time left.
            else
                ProgBData(index).EstTimeHndl = text(0.01,.5,'','parent',ProgBData(index).AxHndl);
            end;
%             set(ProgBData(index).EstTimeHndl,'String','test')
%         case 'title'
%             if ishandle(ProgBData(index).AxHndl)
%                 set(get(ProgBData(index).AxHndl,'title'),'string',remInp{2});
%             end;
        case 'startstatistics'
            count = remInp{2};
            if ~numel(count)==1 | round(count)~=count
                error('number of statistic points should be integer scalar');
            end
            val = imaqmem;
            val.position = ProgBData(index).LastUpd(1);
            val.time = ProgBData(index).LastUpd(2);
            names = fieldnames(val);
            for k=1:length(names)
                eval(['val.' names{k} '(count)=0;']); % required for versions < R13
%                 val.(names{k})(count)=0;
            end;
            ProgBData(index).Statistics = val;
            ProgBData(index).StatisticsCount = 1;
        case 'getstatistics'
            pos = ProgBData(index).Statistics;
            if ~isempty(pos)
                names = fieldnames(pos);
                for k=1:length(names)
                    eval(['pos.' names{k} '(ProgBData(index).StatisticsCount+1:end)=[];']); % required for versions < R13
%                     pos.(names{k})(ProgBData(index).StatisticsCount+1:end)=[];
                end;
            end;
            usedInputs = 1;
        case 'debugbutton'
            if isempty(GeneralData.DebugButton) | ~any(ishandle(GeneralData.DebugButton)) %use any to evaluate empty to 0.
                if ishandle(GeneralData.ProgB) % deal with empty handle
                else
                    progressbar('redraw');
                end;
                GeneralData.DebugButton = uicontrol(GeneralData.ProgB,'Style', 'pushbutton', 'String', 'Debug',...
                    'Position', [30 3 60 20],'Callback', 'progressbar(''DebugStop'');');
            end;
            if strcmpi(remInp{2},'show')% | strcmpi(remInp{2},'immediatestop')
                set(GeneralData.DebugButton,'visible','on');
%                 if strcmpi(remInp{2},'immediatestop')
%                     GeneralData.doDebugStop=-1;
%                 end;
            else
                set(GeneralData.DebugButton,'visible','off');
            end;
        case 'debugstop'
            GeneralData.doDebugStop = 1;
            usedInputs = 1;
        otherwise
            warning(['invallid argument in progressbar (' remInp{1} ')']);
            
%             error('invallid argument in progressbar');
    end;
    remInp = {remInp{1+usedInputs:end}};
  end; % end while inputs;
else
    if isempty(ProgBData)
        error('initialize progressbar first');
    end;
    index = GeneralData.CurrIndex;
    if ProgBData(index).LastUpd(2) + ProgBData(index).minTimeInterval > now
        % no update needed yet 
        return;
    end;
    if GeneralData.NeedDraw>0
        progressbar('Redraw');
    end;
    if isempty(GeneralData.ProgB)
        % figure closed 
        return;
    end;
    if ~ishandle(GeneralData.ProgB)
        warning('Progressbar closed, no further progress displayed until a new level is created.');
        GeneralData.ProgB = [];
        return;
    end;
    newPos = varargin{1};
    
    cur = ProgBData(index);
    ststp = cur.StartStop;
    pos = (newPos-ststp(1))/(ststp(2)-ststp(1));
    if ~ishandle(cur.PatchHndl)
        warning('Do not draw to the progressbar');
        GeneralData.NeedDraw = max(GeneralData.NeedDraw,1);
        progressbar('redraw');
        cur = ProgBData(index);
    end;
    set( cur.PatchHndl,'XData',[0 pos pos 0]);

    if nargin>1 & ~isempty(varargin{2})
        value = varargin{2};
        set(get(ProgBData(index).AxHndl,'title'),'string',value);
    end;

    if ishandle(cur.EstTimeHndl)
        if size(cur.Times,1)<40
            cur.Times = [cur.Times; newPos now];
        else
            cur.Times = [cur.Times(2:end,:); newPos now];
%             % Dont keep to much values but keep some history (~ 1.5* log2(16)*16 samples).
%             cur.TimesUpdIndx = cur.TimesUpdIndx + 1;
%             cur.Times = [cur.Times(1:cur.TimesUpdIndx-1,:); cur.Times(cur.TimesUpdIndx+1:end,:); newPos now];
%             if cur.TimesUpdIndx>16
%                 cur.TimesUpdIndx=0;
%             end;
        end;
        progress = ( newPos-cur.Times(1,1) );
        
        if progress*sign(ststp(2)-ststp(1)) <= eps * abs(ststp(2)-ststp(1))
            timeLeft = nan;
        else
            DC = diff(cur.Times,1,1);
            prgr = DC(:,1)\DC(:,2);
            resid = DC(:,2)-DC(:,1)*prgr;
            resVar = (resid'*resid)./max(eps,size(DC,1)-1);
            if size(DC,1)>3
                % do weighting of exceptionally large intervals.
                % (to make it much more robust to large time steps, as you
                %  get by hibernating)
%                 oldResVar = resVar*6;
%                 while oldResVar>resVar*5
                    W = min(1 , (9.*resVar)^1.5.*abs(resid).^(-3));
                    scaler = inv(DC(:,1)'*(W.*DC(:,1)));
                    prgr = scaler*(DC(:,1)'*(W.*DC(:,2)));
                    resid = DC(:,2)-DC(:,1)*prgr;
                    oldResVar = resVar;
                    resVar = (resid'*(W.*resid))./(size(DC,1)-1);
%                 end;
            else
                scaler = 1./(DC(:,1)'*DC(:,1));
                if size(DC,1)==1
                    resVar = inf;
                end;
            end;
            timeLeftDelt =  sqrt(resVar * scaler) * (ststp(2)-newPos) *86400 * 2.5; 
            timeLeft = (ststp(2)-newPos) .* prgr .* 86400;
           
%             X = [ones(size(cur.Times,1),1) cur.Times(:,1)];
%             prgr = X\ cur.Times(:,2);
%             timeLeft = (ststp(2)-newPos) .* prgr(2) .* 86400;
%             if size(X,1)>=3
%                 resNrm = sum((cur.Times(:,2) - X*prgr).^2) ./ (size(X,1)-2);
%                 % cov(prgr) = inv(X'*X)
%                 % cov of a prediction at x=X0: X0*cov(prgr)*X0'
%                 % don't use inv(X'*X) to avoid problems with bad scaling. (inv(X'*X) * a = (X\(X'\a)) )
%                 % scale by 2 to get ~96% confidence interval; 
%                 % scale by 86400 to get from days to seconds.
%                 timeLeftDelt = 2*sqrt( resNrm * ([1 ststp(2)] * (X \(X'\[1 ststp(2)]'))))*86400;
%             else
%                 timeLeftDelt = nan;
%             end;
%             timeLeft =  (ststp(2)-newPos)* (cur.Times(end,2)-cur.Times(1,2)) / progress *86400;
        end;
        if timeLeft>=0 & timeLeft<1e9
            % make timeleft part:
            if timeLeft<60
                timeLeftStr = sprintf('%4.1fs',timeLeft) ;
            elseif timeLeft<3600
                timeLeftStr = sprintf('%2.0fm:%4.1fs',floor(timeLeft/60),rem(timeLeft,60));
            else
                if timeLeftDelt>=100
                    timeLeftStr = sprintf('%dh:%2.0fm',floor(timeLeft/3600),rem(floor(timeLeft/60),60));
                else
                    timeLeftStr = sprintf('%dh:%2.0fm:%2.0fs',floor(timeLeft/3600),rem(floor(timeLeft/60),60),rem(timeLeft,60));
                end;
            end;
            % make error part:
            if isfinite(timeLeftDelt) 
                if timeLeftDelt>=100
                    timeLeftStr = [timeLeftStr sprintf(' +/- %2.0fm',round(timeLeftDelt/60))];
                elseif timeLeftDelt>=2
                    timeLeftStr = [timeLeftStr ' +/- ' num2str(round(timeLeftDelt)) 's'];
                else
                    timeLeftStr = [timeLeftStr sprintf(' +/- %2.1fs',timeLeftDelt)];
                end;
            else
                timeLeftStr = [timeLeftStr ' +/- ?'];
            end;
        else
            timeLeftStr = 'unknown';
        end;
        set(cur.EstTimeHndl,'String',['Time left: ' timeLeftStr]);
        ProgBData(index) = cur;
    end;
    drawnow;
    ProgBData(index).LastUpd = [newPos now];
    if ~isempty(ProgBData(index).Statistics)
        count = ProgBData(index).StatisticsCount;
        if 1/((length(ProgBData(index).Statistics.time)- count)/max(1e-10,1-pos)) <= (newPos - ProgBData(index).Statistics.position( count ))/(ststp(2)-ststp(1))
            count = min(count+1,length(ProgBData(index).Statistics.time));
            ProgBData(index).StatisticsCount = count;
            val = imaqmem;
            val.position = ProgBData(index).LastUpd(1);
            val.time = ProgBData(index).LastUpd(2);
            names = fieldnames(val);
            for k=1:length(names)
                eval(['ProgBData(index).Statistics.' names{k} '(count)=val.' names{k} ';']);% required for versions < R13
%                 ProgBData(index).Statistics.(names{k})(count)=val.(names{k});
            end;
        end;
    end;    
end;

if GeneralData.doDebugStop
    [st,i]=dbstack;
    if length(st)<=1 | ~strcmp(st(1).name,st(min(length(st),2)).name) % when inside another progressbar function call, step to the outer version.
        GeneralData.doDebugStop =0;
        str=['dbstop in ''' st(1).name ''' at ' num2str(st(1).line+6) ];% last line of progressbar
        eval(str);
% PRESS F10 (dbstep) twice to step out to the calling function.     Happy debugging!
        eval(['dbclear in ''' st(1).name ''' at ' num2str(st(1).line+6)]); return;
    end;
end;
