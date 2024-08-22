function [b] = adjust_char_space(nspace,a,format)
% adjust_char_space は、指定された文字列 a を指定されたフォーマット format で整形し、
% 指定されたスペース数 nspace になるように前に空白を追加して整列させる関数です。
%
% nspace: max 16
% nspace = 10;
% a = 'DEPTH=';
% format = '%6s';

x = zeros(1,nspace);
y = num2str(a,format);
nlength = length(y);

nblank = nspace - nlength;
b1 = zeros(1,nblank);
b = [b1 y];
% size(b)
% b(1)
% b(5)
% b(10)
