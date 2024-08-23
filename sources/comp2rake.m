function [rake netslip] = comp2rake(latslip,dipslip)
% comp2rake - 横ずれ（latslip）と傾斜ずれ（dipslip）を、掘削角（rake）と総ずれ量（netslip）に変換する関数。
% 各入力はベクトル形式の列で与えられ、対応する出力ベクトルが返されます。

% 入力ベクトルの長さを取得
n = length(latslip);

% 出力ベクトルをゼロで初期化
rake = zeros(n,1);    % 掘削角を格納するベクトル
netslip = zeros(n,1); % 総ずれ量を格納するベクトル

% 総ずれ量を計算 - ピタゴラスの定理を使用
netslip = sqrt(latslip.^2.0 + dipslip.^2.0);

% 横ずれが正の部分と負の部分を条件分岐で計算
c1 = latslip >= 0.0;  % 横ずれが正の場合
c2 = latslip < 0.0;  % 横ずれが負の場合

% 掘削角の計算 - 横ずれと傾斜ずれのアークタンジェントを使用
rake = c1.*(180.0 - rad2deg(atan(dipslip./latslip)))+c2.*(-1.0).*rad2deg(atan(dipslip./latslip));

% 掘削角が180度を超える場合の調整
if rake > 180
    rake = rake - 360.0;
end
