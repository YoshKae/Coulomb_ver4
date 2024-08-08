function [s_element new_id] = split_element(id,e9)

m = length(id);
ntotal = sum(id);
s_element = zeros(m,10);
new_id = ones(m,1);

nct = 0;
for k = 1:m
    n = int16(id(k));
    xinc = (e9(k,3)-e9(k,1))/double(n);
    yinc = (e9(k,4)-e9(k,2))/double(n);
    zinc = (e9(k,9)-e9(k,8))/double(n);
    for l = 1:n
       nct = nct + 1;
       new_id(nct,1) = k;
       s_element(nct,1) = e9(k,1) + double(l-1) * xinc;
       s_element(nct,3) = e9(k,1) + double(l) * xinc;
       s_element(nct,2) = e9(k,2) + double(l-1) * yinc;
       s_element(nct,4) = e9(k,2) + double(l) * yinc;
       s_element(nct,5) = e9(k,5);
       s_element(nct,6) = e9(k,6);
       s_element(nct,7) = e9(k,7);
       s_element(nct,8) = e9(k,8);
       s_element(nct,9) = e9(k,9);
       s_element(nct,10) = e9(k,10);
%        s_element(nct,8) = e9(k,8) + double(l-1) * zinc;
%        s_element(nct,9) = e9(k,9) + double(l) * zinc;       
    end
end
s_element;
% Each fault element
%       ELEMENT(:,1) xstart (km)
%       ELEMENT(:,2) ystart (km)
%       ELEMENT(:,3) xfinish (km)
%       ELEMENT(:,4) yfinish (km)
%       ELEMENT(:,5) right-lat. slip (m)
%       ELEMENT(:,6) reverse slip (m)
%       ELEMENT(:,7) dip (degree)
%       ELEMENT(:,8) fault top depth (km)
%       ELEMENT(:,9) fault bottom depth (km)
