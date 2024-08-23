function [unit,unitText] = check_unit_vector(xs,xf,oneMeterSize,ratioMin,ratioMax) 
% この関数は、ディスプレイに表示するための適切な単位長を決定します。
% 地図やグラフ上での表示に適した単位ベクトルの長さとその表示用のテキストを返します。

% 入力:
%   xs: xの開始位置 (km単位) または、垂直方向の表示のためのyの開始位置
%   xf: xの終了位置 (km単位) または、垂直方向の表示のためのyの終了位置
%   oneMeterSize: 1メートルのベクトルを誇張して表したkm単位の長さ
%   ratioMax: 0から1の範囲の最大比率 (例: 0.5は、グラフィック全体の半分を超えないようにする)
%   ratioMin: 最小比率 (単位ベクトルを表示するための最小比率)

% 出力:
%   unit: 決定された単位長さ (例: 0.01, 0.1, 1, 10)
%   unitText: 単位長さを表す文字列 (例: '1 m')


% 総距離を計算
totalLength = abs(xf - xs);           % 開始位置と終了位置の絶対距離を計算
maxLength   = totalLength * ratioMax; % 最大長さの制限を設定
minLength   = totalLength * ratioMin; % 最小長さの制限を設定

% oneMeterSizeがmaxLengthより大きい場合、unitを0.1に縮小して再計算
if oneMeterSize > maxLength 
    unit = 0.1; unitText = '0.1 m';             % 単位を0.1メートルに設定
    oneMeterSize = oneMeterSize * 0.1;          % oneMeterSizeを0.1倍に縮小
    if oneMeterSize > maxLength
        unit = 0.01; unitText = '0.01 m';       % 単位を0.01メートルに設定
        oneMeterSize = oneMeterSize * 0.1;      % oneMeterSizeをさらに0.1倍に縮小
        if oneMeterSize > maxLength
            unit = 0.001; unitText = '0.001 m'; % 単位を0.001メートルに設定
        end
    end
else
    % oneMeterSizeがminLength以上であれば、unitを1メートルに設定
    if oneMeterSize >= minLength
        unit = 1; unitText = '1 m';             % 単位を1メートルに設定 
    elseif oneMeterSize < minLength
        unit = 10; unitText = '10 m';           % 単位を10メートルに設定
        oneMeterSize = oneMeterSize * 10;       % oneMeterSizeを10倍に拡大
        if oneMeterSize > maxLength
            unit = 1; unitText = '1 m';         % 再び単位を1メートルに設定
        end
        if oneMeterSize < minLength
            unit = 10; unitText = '100 m';      % 単位を100メートルに設定
            oneMeterSize = oneMeterSize * 10;   % oneMeterSizeを再び10倍に拡大
            if oneMeterSize > maxLength
                unit = 10; unitText = '10 m';   % 単位を10メートルに再設定
            end
            if oneMeterSize < minLength
                unit = 10; unitText = '1000 m'; % 単位を1000メートルに設定
            end
        end
    end
end
