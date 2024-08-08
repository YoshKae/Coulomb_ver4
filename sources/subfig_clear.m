% script: subfig_clear サブフィギュアをクリアする関数
% 
% このスクリプトは、メインフィギュアを除く図（ウィンドウ）をクリアします
%
global H_MAIN
global H_INPUT H_DISPL H_COULOMB H_SECTION H_SEC_WINDOW H_STRAIN H_GRID_INPUT
global H_STUDY_AREA H_ELEMENT H_UTM H_VERTICAL_DISPL H_EC_CONTROL H_POINT
global H_F3D_VIEW H_DEPTH H_CALC_PRINCIPAL H_HELP H_NODAL H_VIEWPOINT
global H_ELEMENT_MOD H_SPECIFIED_SLIDER

h = findobj('Tag','input_window'); % タグがinput_windowのオブジェクトを検索
if (isempty(h)~=1 && isempty(H_INPUT)~=1)
	close(figure(H_INPUT))
    H_INPUT = [];
end
h = findobj('Tag','displ_h_window');
if (isempty(h)~=1 && isempty(H_DISPL)~=1)
	close(figure(H_DISPL))
    H_DISPL = [];
end
h = findobj('Tag','coulomb_window');
if (isempty(h)~=1 && isempty(H_COULOMB)~=1)
    close(figure(H_COULOMB))
    H_COULOMB = [];
end
h = findobj('Tag','xsec_window');
if (isempty(h)~=1 && isempty(H_SEC_WINDOW)~=1)
    close(figure(H_SEC_WINDOW))
	H_SEC_WINDOW = [];
end
h = findobj('Tag','section_view_window');
if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    close(figure(H_SECTION))
    H_SECTION = [];
end
h = findobj('Tag','strain_window');
if (isempty(h)~=1 && isempty(H_STRAIN)~=1)
    close(figure(H_STRAIN))
    H_STRAIN = [];
end
h = findobj('Tag','grid_input_window');
if (isempty(h)~=1 && isempty(H_GRID_INPUT)~=1)
    close(figure(H_GRID_INPUT))
    H_GRID_INPUT = [];
end
h = findobj('Tag','study_area');
if (isempty(h)~=1 && isempty(H_STUDY_AREA)~=1)
    close(figure(H_STUDY_AREA))
    H_STUDY_AREA = [];
end
h = findobj('Tag','element_input_window');
if (isempty(h)~=1 && isempty(H_ELEMENT)~=1)
    close(figure(H_ELEMENT))
    H_ELEMENT = [];
end
h = findobj('Tag','utm_window');
if (isempty(h)~=1 && isempty(H_UTM)~=1)
    close(figure(H_UTM))
    H_UTM = [];
end
h = findobj('Tag','vertical_displ_window');
if (isempty(h)~=1 && isempty(H_VERTICAL_DISPL)~=1)
    close(figure(H_VERTICAL_DISPL))
    H_UTM = [];
end
h = findobj('Tag','ec_control_window');
if (isempty(h)~=1 && isempty(H_EC_CONTROL)~=1)
    close(figure(H_EC_CONTROL))
    H_EC_CONTROL = [];
end
h = findobj('Tag','point_calc_window');
if (isempty(h)~=1 && isempty(H_POINT)~=1)
    close(figure(H_POINT))
    H_POINT = [];
end
h = findobj('Tag','f3d_view_control_window');
if (isempty(h)~=1 && isempty(H_F3D_VIEW)~=1)
    close(figure(H_F3D_VIEW))
    H_F3D_VIEW = [];
end
h = findobj('Tag','depth_range_window');
if (isempty(h)~=1 && isempty(H_DEPTH)~=1)
    close(figure(H_DEPTH))
    H_DEPTH = [];
end
h = findobj('Tag','calc_principals_window');
if (isempty(h)~=1 && isempty(H_CALC_PRINCIPAL)~=1)
    close(figure(H_CALC_PRINCIPAL))
    H_CALC_PRINCIPAL = [];
end
h = findobj('Tag','nodal_plane_window');
if (isempty(h)~=1 && isempty(H_NODAL)~=1)
    close(figure(H_NODAL))
    H_NODAL = [];
end
h = findobj('Tag','viewpoint3d_window');
if (isempty(h)~=1 && isempty(H_VIEWPOINT)~=1)
    close(figure(H_VIEWPOINT))
    H_VIEWPOINT = [];
end
h = findobj('Tag','figure_specified_slider');
if (isempty(h)~=1 && isempty(H_SPECIFIED_SLIDER)~=1)
    close(figure(H_SPECIFIED_SLIDER))
    H_SPECIFIED_SLIDER = [];
end
% if (isempty(findobj('Tag','figure_element_modification'))~=1 && isempty(H_ELEMENT_MOD)~=1)
% close(figure(H_ELEMENT_MOD))
% H_ELEMENT_MOD = [];
% end
