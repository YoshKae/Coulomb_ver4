function seis_moment()
    % seis_moment: 地震モーメントとモーメントマグニチュードを計算する関数
    % KODE が 100 の場合のみ、地震モーメントを計算

    % グローバル変数
    global INPUT_VARS

    % KODEが100であることを確認（100でない場合はモーメントを計算しない）
    check = max(INPUT_VARS.KODE);
    if check == 100
        amo = 0.0; % 総モーメントを初期化

        % 要素ごとの地震モーメントを計算
        for k = 1:INPUT_VARS.NUM
            % 剛性率を計算
            shearmod = INPUT_VARS.YOUNG / (2.0 * (1.0 + INPUT_VARS.POIS));

            % 断層長を計算
            flength = sqrt((INPUT_VARS.ELEMENT(k,1) - INPUT_VARS.ELEMENT(k,3))^2 + ...
                           (INPUT_VARS.ELEMENT(k,2) - INPUT_VARS.ELEMENT(k,4))^2);

            % 断層の上下端の深さから断層高さを計算
            hfault = INPUT_VARS.ELEMENT(k,9) - INPUT_VARS.ELEMENT(k,8);

            % 傾斜角から断層の幅を計算
            wfault = hfault / sin(deg2rad(INPUT_VARS.ELEMENT(k,7)));

            % すべり量を計算
            slip = sqrt(INPUT_VARS.ELEMENT(k,5)^2.0 + INPUT_VARS.ELEMENT(k,6)^2.0);

            % 地震モーメントを計算
            smo = shearmod * flength * wfault * slip * 1.0e+18;  % dyne-cm 単位

            % 総モーメントに加算
            amo = amo + smo;
        end

        % モーメントマグニチュードを計算
        mw = (2/3) * log10(amo) - 10.7;

        % 計算結果を表示
        disp(['   Total seismic moment = ' num2str(amo,'%6.2e') ' dyne cm (Mw = ', num2str(mw,'%4.2f') ')']);
    else
        disp('モーメント計算は KODE = 100 の場合のみ可能です。');
    end
end
