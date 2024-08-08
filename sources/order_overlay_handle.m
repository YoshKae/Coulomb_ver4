function order_overlay_handle(n)
% This function make all overlay graphic object handles in a good order.
%
% n = 1: coastline overlay is modified.
% n = 2: active fault overlay is modified.
% n = 3: earthquake data overlay is modified.
% n = 4: comment overlay is modified.
%
global NH_COAST NH_AFAULT NH_EQ NH_COMMENT

switch n
    case 1
        NH_AFAULT  = NH_AFAULT  + NH_COAST(2);
        NH_EQ      = NH_EQ      + NH_COAST(2);
        NH_COMMENT = NH_COMMENT + NH_COAST(2);
    case 2
        NH_COAST   = NH_COAST   + NH_AFAULT(2);
        NH_EQ      = NH_EQ      + NH_AFAULT(2);
        NH_COMMENT = NH_COMMENT + NH_AFAULT(2);
    case 3
        NH_COAST   = NH_COAST   + NH_EQ(2);
        NH_AFAULT  = NH_AFAULT  + NH_EQ(2);
        NH_COMMENT = NH_COMMENT + NH_EQ(2);
    case 4
        NH_COAST   = NH_COAST   + NH_COMMENT(2);
        NH_AFAULT  = NH_AFAULT  + NH_COMMENT(2);
        NH_EQ      = NH_EQ      + NH_COMMENT(2);
    otherwise

end