function [foutput] = ge_folder( foldername, output )
%% function[foutput] = ge_folder( foldername, output)
%     foldername = filename (character array)
%     output = KML objects (character array)
%     foutput = KML objects inside folder (character array)
%   Note:  This does not check valid nesting of objects.

header = ['<Folder id="' foldername '">',...
         '<name>',foldername,'</name>'];
footer = '</Folder>';

foutput = [header output footer];

