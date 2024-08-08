% Instruction to write your own plug-in script
%
% first set the handvisibility for the main window on

set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);

% read meanings of the global variables from
% 'Parameters_description.m'
% then, using some global variables, you can calculate and display your own
% functions and script here, and save them.

% clear some variables you made and then set the handvisibility of the main
% window callback.

set(H_MAIN,'HandleVisibility','callback');