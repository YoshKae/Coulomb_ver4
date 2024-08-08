function [b] = adjust_char_space(nspace,a,format)
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


