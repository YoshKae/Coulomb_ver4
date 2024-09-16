function subfig_clear()
    % subfig_clear: サブフィギュア（補助ウィンドウやビュー）を閉じる関数

    % グローバル変数
    global H_MAIN
    global H_INPUT H_DISPL H_COULOMB H_SECTION H_SEC_WINDOW H_STRAIN H_GRID_INPUT
    global H_STUDY_AREA H_ELEMENT H_UTM H_VERTICAL_DISPL H_EC_CONTROL H_POINT
    global H_F3D_VIEW H_DEPTH H_CALC_PRINCIPAL H_HELP H_NODAL H_VIEWPOINT
    global H_ELEMENT_MOD H_SPECIFIED_SLIDER

    % 各ウィンドウのハンドルが存在している場合、それを閉じ、ハンドルをクリア
    close_if_exists('input_window', H_INPUT);
    H_INPUT = [];
    close_if_exists('displ_h_window', H_DISPL);
    H_DISPL = [];
    close_if_exists('coulomb_window', H_COULOMB);
    H_COULOMB = [];
    close_if_exists('xsec_window', H_SEC_WINDOW);
    H_SEC_WINDOW = [];
    close_if_exists('section_view_window', H_SECTION);
    H_SECTION = [];
    close_if_exists('strain_window', H_STRAIN);
    H_STRAIN = [];
    close_if_exists('grid_input_window', H_GRID_INPUT);
    H_GRID_INPUT = [];
    close_if_exists('study_area', H_STUDY_AREA);
    H_STUDY_AREA = [];
    close_if_exists('element_input_window', H_ELEMENT);
    H_ELEMENT = [];
    close_if_exists('utm_window', H_UTM);
    H_UTM = [];
    close_if_exists('vertical_displ_window', H_VERTICAL_DISPL);
    H_VERTICAL_DISPL = [];
    close_if_exists('ec_control_window', H_EC_CONTROL);
    H_EC_CONTROL = [];
    close_if_exists('point_calc_window', H_POINT);
    H_POINT = [];
    close_if_exists('f3d_view_control_window', H_F3D_VIEW);
    H_F3D_VIEW = [];
    close_if_exists('depth_range_window', H_DEPTH);
    H_DEPTH = [];
    close_if_exists('calc_principals_window', H_CALC_PRINCIPAL);
    H_CALC_PRINCIPAL = [];
    close_if_exists('nodal_plane_window', H_NODAL);
    H_NODAL = [];
    close_if_exists('viewpoint3d_window', H_VIEWPOINT);
    H_VIEWPOINT = [];
    close_if_exists('figure_specified_slider', H_SPECIFIED_SLIDER);
    H_SPECIFIED_SLIDER = [];
end

%------------------------------------------------------------------------------
% 補助関数: 指定されたタグのウィンドウが存在すれば閉じる
function close_if_exists(tag, handle)
    h = findobj('Tag', tag);  % タグでオブジェクトを検索
    if ~isempty(h) && ~isempty(handle)  % ウィンドウが存在すれば閉じる
        close(figure(handle));
    end
end
