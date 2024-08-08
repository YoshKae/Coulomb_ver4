function [foutput] = ge_folder( foldername, output )
%% ge_folder( foldername, output)
%     foldername = filename (character array)
%     output = KML objects (character array)


header = ['<Folder id="' foldername '">',...
         '<name>',foldername,'</name>'];
footer = ['</Folder>'];

foutput = [header output footer];

