function [flag] = coulomb_registration_check
% ソフトウェアのライセンスチェックを行う関数
% 出力: flag = 'in' (ライセンス有効), 'out' (ライセンス無効)

user_act1  = sum(license);           % MATLABのライセンス情報を取得し、その合計値を計算
serial_sum = 419;                    % 予め定義されたシリアル番号の合計値
user_act   = user_act1 + serial_sum; % シリアル番号とライセンス情報の合計値を計算
abi = 0;                             % 初期化
homedir = pwd;                       % 現在の作業ディレクトリを保存

flag = 'in'; % デフォルトではライセンスが有効と設定

try
    cd license % 'license'ディレクトリに移動
    if exist('my_personal_license.txt') % ライセンスファイルが存在するか確認
        abi = textread('my_personal_license.txt'); % ファイルからライセンス情報を読み込む
    else
        answer = inputdlg('Enter 8 digit serial number.','Serial Number'); % シリアル番号を入力するダイアログを表示
        user_serial = [answer{:}]; % 入力されたシリアル番号を取得
        sum(user_serial);
        if sum(user_serial)==serial_sum % 入力されたシリアル番号が正しいか確認
            abi = sum(user_serial) + user_act1; % シリアル番号とライセンス情報の合計値を計算
            save my_personal_license.txt abi -ascii % 計算されたライセンス情報をファイルに保存
        else
        flag = 'out'; % シリアル番号が間違っている場合、ライセンス無効として設定
        cd homedir % 元のディレクトリに戻る
        return
    end
end
cd .. % 元のディレクトリに戻る

if abi ~= user_act
    cd license
        answer = inputdlg('Enter 8 digit serial number.','Serial Number'); % 再度シリアル番号を入力するダイアログを表示
        user_serial = [answer{:}];
        sum(user_serial);
        abi = sum(user_serial) + user_act1; % 新たに計算されたライセンス情報を更新
        save my_personal_license.txt abi -ascii % 新しいライセンス情報をファイルに保存
    cd ..
    if abi ~= user_act % それでも一致しない場合
        disp(' ');
        disp('A proler license file is not found. To use Coulomb, you need a serial number first.');
        disp('Send email to Volkan Sevilgen <vsevilgen@usgs.gov> to get the number');
        disp('有効なライセンスファイルが見つかりません。Coulombを使用するには、シリアル番号が必要です。');
        disp('Volkan Sevilgen <vsevilgen@usgs.gov> に連絡してシリアル番号を取得してください。');
        flag = 'out'; % ライセンス無効として設定
        return
    end
else
    flag = 'in'; % ライセンスが有効な場合
end

catch
    cd homedir % 例外が発生した場合、元のディレクトリに戻る
end
