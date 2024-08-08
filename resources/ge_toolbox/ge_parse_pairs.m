function v = ge_parse_pairs(pairs)
%% ge_parse_pairs
%   helper function allowing named generic name value parameter passing

v = {}; 

for ii=1:2:length(pairs(:))
   
    if isnumeric(pairs{ii+1})
        str = [ pairs{ii} ' = ' num2str(pairs{ii+1}),';'  ];
    else
        str = [ pairs{ii} ' = ' 39 pairs{ii+1} 39,';'  ];
    end
    v{(ii+1)/2,1} = str;
    
end