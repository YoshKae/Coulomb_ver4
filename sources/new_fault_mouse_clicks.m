% This is a script
global FUNC_SWITCH DONOTSHOW H_MAIN ELEMENT PREF NUM ID INUM
global CALC_DEPTH POIS YOUNG KODE FRIC SIZE HEAD R_STRESS
global SECTION H_ELEMENT
global ICOORD LON_GRID
global FCOMMENT
global CLICK_TAPER

FUNC_SWITCH = 0;
xy = zeros(2,2);
n = 0;
but = 1;

NUM = NUM + 1;
% INUM = INUM + 1;
% ID = INUM;
idt = NUM;
INUM = NUM;

if isempty(DONOTSHOW) == 1 % DONOTSHOWが空の場合
h0 = new_fault_pos_dialog; % new_fault_pos_dialogをh0に代入
waitfor(h0); % h0が閉じるまで待機
else
    if DONOTSHOW ~= 1
        h0 = new_fault_pos_dialog;
        waitfor(h0);
    end
end
%------ mouse clicks -------------------
try
while (but == 1 && n <= 2) % butが1でnが2以下の間繰り返す
    h = figure(H_MAIN); % 現在の図をアクティブにする
   [xi,yi,but] = ginput(1); 
	n = n+1;
    xy(:,n) = [xi;yi];
    xs = xy(1,1); ELEMENT(idt,1) = xy(1,1);
    ys = xy(2,1); ELEMENT(idt,2) = xy(2,1);
    xf = xy(1,2); ELEMENT(idt,3) = xy(1,2);
    yf = xy(2,2); ELEMENT(idt,4) = xy(2,2);
    if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2でLON_GRIDが空でない場合
    a = lonlat2xy([xs 0.0]); ELEMENT(idt,1) = a(1);
    a = lonlat2xy([0.0 ys]); ELEMENT(idt,2) = a(2);
    a = lonlat2xy([xf 0.0]); ELEMENT(idt,3) = a(1);
    a = lonlat2xy([0.0 yf]); ELEMENT(idt,4) = a(2);
    end
    ID(idt) = 1;
    FCOMMENT(idt).ref = 'added by mouse-click'; % FCOMMENTのrefフィールドに文字列を設定
end
catch
    disp('try again choosing NEW from DATA menu');
    return
end
%----------------------------------------
if isempty(findobj('Tag','new_fault_pos_dialog'))~=1 % new_fault_pos_dialogが存在する場合
close(h0);
end
   hold on;
h = plot([xs xf],[ys yf]);
set(h,'Tag','new_fault_line');         %TAG cross_section_line
set (h,'Color',PREF(1,1:3),'LineWidth',PREF(1,4));
h1 = text(xs,ys,'A','FontSize',18);
h2 = text(xf,yf,'B','FontSize',18);
set(h1,'HorizontalAlignment','center');
set(h2,'HorizontalAlignment','center');
set(h1,'Tag','new_fault_A');         %TAG cross_section_A
set(h2,'Tag','new_fault_B');         %TAG cross_section_B

%
ELEMENT(idt,5) = 0.0;     % right-lat. slip (m)
ELEMENT(idt,6) = 0.0;     % reverse slip (m)
ELEMENT(idt,7) = 90.0;    % dip (degree)
ELEMENT(idt,8) = 0.0;     % fault top depth (km)
ELEMENT(idt,9) = 10.0;    % fault bottom depth (km)
ID(idt) = 1;
FCOMMENT(idt).ref = 'added by mouse-click';
% CALC_DEPTH = (ELEMENT(idt,8)+ELEMENT(idt,9)) / 2.0;
% POIS = 0.25;
% YOUNG = 800000;
% KODE = 100;
% FRIC = 0.4;
% SIZE = [2;1;10000];
% HEAD = cell(2,1);
% x1 = ['header line 1'];
% x2 = ['header line 2'];
% HEAD(1,1) = mat2cell(x1);
% HEAD(2,1) = mat2cell(x2);
% R_STRESS = [19.00 -0.01 100.0 0.0;
%             89.99 89.99  30.0 0.0;
%            109.00 -0.01   0.0 0.0];
% SECTION = [-16; -16; 18; 26; 1; 30; 1];
%% default (end)

H_ELEMENT = element_input_window;

set(findobj('Tag','radiobutton_taper'),'Value',0);
CLICK_TAPER = 0;
set(findobj('Tag','radiobutton_taper'),'Visible','off');
set(findobj('Tag','radiobutton_split'),'Visible','off');
set(findobj('Tag','text_strike_dist'),'Visible','off');
set(findobj('Tag','text_dip_dist'),'Visible','off');
set(findobj('Tag','text_n_element'),'Visible','off');
set(findobj('Tag','text_x'),'Visible','off');
set(findobj('Tag','text_strike_by_dip'),'Visible','off');
set(findobj('Tag','edit_taper_strike'),'Visible','off');
set(findobj('Tag','edit_taper_dip'),'Visible','off');
set(findobj('Tag','edit_taper_num'),'Visible','off');
set(findobj('Tag','edit_nf_strike'),'Visible','off');
set(findobj('Tag','edit_nf_dip'),'Visible','off');
set(findobj('Tag','text_split_strike'),'Visible','off');
set(findobj('Tag','text_split_dip'),'Visible','off');
set(findobj('Tag','pushbutton_add_fault'),'Visible','on');
waitfor(H_ELEMENT);
calc_element;
