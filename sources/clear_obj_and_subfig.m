% script clear_obj_and_subfig
global H_MAIN

subfig_clear;
%--- clear all object on the main window
ch = get(H_MAIN,'Children');
n = length(ch) - 3;
if n >= 1
    for k = 1:n
        delete(ch(k));
    end
    set(H_MAIN,'Menubar','none','Toolbar','none');
end
%--- (end)