function clear_obj_and_subfig()
    % clear_obj_and_subfig: メインウィンドウおよびサブフィギュア内のオブジェクトをクリアする関数

    % グローバル変数
    global H_MAIN

    % サブフィギュア（サブウィンドウや補助的なウィンドウ）をクリアする関数を呼び出し
    subfig_clear(); 

    % メインウィンドウ上のすべてのオブジェクトをクリアする
    ch = get(H_MAIN, 'Children'); % メインウィンドウ内のすべての子オブジェクトを取得
    n = length(ch) - 3;           % 子オブジェクトの数を取得（最後の3つは保持）

    % メインウィンドウ内の不要なオブジェクトを削除
    if n >= 1
        for k = 1:n
            delete(ch(k));        % 各子オブジェクトを削除
        end
        % メインウィンドウのメニューバーとツールバーを非表示に設定
        set(H_MAIN, 'Menubar', 'none', 'Toolbar', 'none');
    end
end
