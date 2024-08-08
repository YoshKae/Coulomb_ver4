%-------------------------------------------------------------------------
%     Draw cross section projection on the map
%-------------------------------------------------------------------------
function draw_dipped_cross_section
global H_MAIN
global HF HO HT1 HT2
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global ICOORD LON_GRID
% section_grid_drawing;
SEC_XS = str2double(get(findobj('Tag','edit_sec_xs'),'String'));
SEC_YS = str2double(get(findobj('Tag','edit_sec_ys'),'String'));
SEC_XF = str2double(get(findobj('Tag','edit_sec_xf'),'String'));
SEC_YF = str2double(get(findobj('Tag','edit_sec_yf'),'String'));
if ICOORD == 2 && isempty(LON_GRID) ~= 1
           temp = zeros(1,4);
           temp  = [SEC_XS SEC_XF SEC_YS SEC_YF];
       a = lonlat2xy([SEC_XS 0.0]); SEC_XS = a(1);
       a = lonlat2xy([SEC_XF 0.0]); SEC_XF = a(1);
       a = lonlat2xy([0.0 SEC_YS]); SEC_YS = a(2);
       a = lonlat2xy([0.0 SEC_YF]); SEC_YF = a(2);
end
SEC_INCRE = str2double(get(findobj('Tag','edit_sec_incre'),'String'));
SEC_DEPTH = str2double(get(findobj('Tag','edit_sec_depth'),'String'));
SEC_DEPTHINC = str2double(get(findobj('Tag','edit_sec_depthinc'),'String'));
SEC_DID = str2double(get(findobj('Tag','edit_section_dip'),'String'));
SEC_DOWNDIP_INC = str2double(get(findobj('Tag','edit_downdip_inc'),'String'));

   figure(H_MAIN);
   hold on;
   h = findobj('Tag','dipped_cross_section_lines');
   if isempty(HF)~=1 && isempty(h)~=1
   delete(HF);
   end
   h = findobj('Tag','cross_section_line');
   if isempty(HO)~=1 && isempty(h)~=1
   delete(HO);
   end
   h = findobj('Tag','cross_section_A');
   if isempty(HT1)~=1 && isempty(h)~=1
   delete(HT1);
   end
   h = findobj('Tag','cross_section_B');
   if isempty(HT2)~=1 && isempty(h)~=1
   delete(HT2);
   end
   hold on;
   c = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,SEC_DEPTH);
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = zeros(4,2);
        a = xy2lonlat([c(:,1) c(:,2)]);
        HF = plot([a(1,1) a(2,1) a(3,1) a(4,1) a(1,1)],...
          [a(1,2) a(2,2) a(3,2) a(4,2) a(1,2)]);
    else
        HF = plot([c(1,1) c(2,1) c(3,1) c(4,1) c(1,1)],...
          [c(1,2) c(2,2) c(3,2) c(4,2) c(1,2)]);
    end
    set (HF,'Tag','dipped_cross_section_lines','Color','b','LineWidth',0.5);

	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        HO = plot([temp(1) temp(2)],[temp(3) temp(4)]);
    else
        HO = plot([SEC_XS SEC_XF],[SEC_YS SEC_YF]);
    end
        set(HO,'Tag','cross_section_line','Color','b','LineWidth',1.5);         %TAG cross_section_line
%        check_sec_input;
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        HT1 = text(temp(1),temp(3),'A','FontSize',18,'Color','k');
        HT2 = text(temp(2),temp(4),'B','FontSize',18,'Color','k');
    else
        HT1 = text(SEC_XS,SEC_YS,'A','FontSize',18,'Color','k');
        HT2 = text(SEC_XF,SEC_YF,'B','FontSize',18,'Color','k');
    end
set(HT1,'HorizontalAlignment','center');
set(HT2,'HorizontalAlignment','center');
set(HT1,'Tag','cross_section_A');         %TAG cross_section_A
set(HT2,'Tag','cross_section_B');         %TAG cross_section_B

