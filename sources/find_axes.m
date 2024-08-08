function [pt_stress] = find_axes(evc,eva)
% This function read eigen vectors and eigen values and then find
% orientation and dip (plunge) of three principal axes.
%
% INPUT
%   evc: eigenvector (n,9)
%      (xx xy xz yx yy yz zx zy zz) x n (row);
%   eva: eigen value (n,3)
%
% OUTPUT
%   pt_stress: (n,9)
%              (sigma-1-strike dip value sigma-2-strike dip value
%               sigma-3-strike dip value) x n (row);
%

[m n] = size(evc);
pt = zeros(m,9);
pt_stress = zeros(m,9);

for k = 1:3
    mmp = evc(1,k);
    llp = evc(1,k+3);
    nnp = evc(1,k+6);
%     mmp = evc(1,3*(k-1)+1);
%     llp = evc(1,3*(k-1)+2);
%     nnp = evc(1,3*(k-1)+3);
% nnp
    delrad = asin(nnp);
    delta  = rad2deg(delrad);
    dcos   = cos(delrad);
% mmp
    if dcos == 0.0
        betmmp = 1.0;
    else
        betmmp = mmp./dcos;
    end
    beradmmp_1 = asin(betmmp);
    if beradmmp_1 >= 0.0
         beradmmp_2 = pi - beradmmp_1;
    else
         beradmmp_2 = (-1.0) .* (pi + beradmmp_1);
    end
        dum1 = beradmmp_1;
        dum2 = beradmmp_2;
        if dum1 <= dum2
            beradmmp_1 = dum2;
            beradmmp_2 = dum1;
        end
% llp
    if dcos == 0.0
        betllp = 1.0;
    else
        betllp = llp ./ dcos;
    end
    beradllp = acos(betllp);
    beradllp_1 = beradllp;
    beradllp_2 = -beradllp;
        dum1 = beradllp_1;
        dum2 = beradllp_2;
        if dum1 <= dum2
            beradllp_1 = dum2;
            beradllp_2 = dum1;
        end
        
        a1 = abs(beradllp_1-beradmmp_1);
        a2 = abs(beradllp_2-beradmmp_2);
        a3 = abs(beradllp_1-beradmmp_2);
        a4 = abs(beradllp_2-beradmmp_1);
        am = [a1;a2;a3;a4];
        amin = min(am);
        ind = find(am == amin);
        if ind == 1 | ind == 3
            berad = rad2deg(beradllp_1);
        else
            berad = rad2deg(beradllp_2);
        end
%         
%         if a1 <= a2
%             berad = rad2deg(beradllp_2);
%         else
%             berad = rad2deg(beradllp_1);
%         end

        if berad < 0.0
            berad = berad + 180.0;
            delta = -delta;
        elseif berad >= 180.0
            berad = berad - 180.0;
            delta = -delta;
        end
        
        pt(1,(k-1)*3+1) = berad;
        pt(1,(k-1)*3+2) = delta;
%        if k==1
        pt(1,(k-1)*3+3) = eva(1,k);
%         elseif k==2
%                 pt(1,(k-1)*3+3) = eva(1,3);
%         elseif k==3
%                     pt(1,(k-1)*3+3) = eva(1,2);
%         end        
end

f1 = pt(3);
f2 = pt(6);
f3 = pt(9);
fall = [f1; f2; f3];
fmin = min(fall); fmax = max(fall);
ind_min = find(fall == fmin);
ind_max = find(fall == fmax);
% if ind_min == 1
%     if ind_max == 2
%         pt_stress = [pt(1) pt(2) pt(3) pt(7) pt(8) pt(9) pt(4) pt(5) pt(6)];
%     elseif ind_max ==3
%         pt_stress = [pt(1) pt(2) pt(3) pt(4) pt(5) pt(6) pt(7) pt(8) pt(9)];
%     end
% elseif ind_min == 2    
%     if ind_max == 1
%         pt_stress = [pt(4) pt(5) pt(6) pt(7) pt(8) pt(9) pt(1) pt(2) pt(3)];        
%     elseif ind_max == 3
%         pt_stress = [pt(4) pt(5) pt(6) pt(1) pt(2) pt(3) pt(7) pt(8) pt(9)];  
%     end
% elseif ind_min == 3
%     if ind_max == 1
%         pt_stress = [pt(7) pt(8) pt(9) pt(4) pt(5) pt(6) pt(1) pt(2) pt(3)]; 
%     elseif ind_max == 2
%         pt_stress = [pt(7) pt(8) pt(9) pt(1) pt(2) pt(3) pt(4) pt(5) pt(6)]; 
%     end
% end

% temporal solution ???
% (need to be clearified... I do not know the reason...)
if ind_min == 1
    if ind_max == 2
        pt_stress = [pt(1) pt(2) pt(3) pt(7) pt(8) pt(9) pt(4) pt(5) pt(6)];
    elseif ind_max ==3
        pt_stress = [pt(1) pt(2) pt(3) pt(4) pt(5) pt(6) pt(7) pt(8) pt(9)];
    end
elseif ind_min == 2    
    if ind_max == 1
        pt_stress = [pt(4) pt(5) pt(6) pt(7) pt(8) pt(9) pt(1) pt(2) pt(3)];        
    elseif ind_max == 3
        pt_stress = [pt(4) pt(5) pt(6) pt(1) pt(2) pt(3) pt(7) pt(8) pt(9)];  
    end
elseif ind_min == 3
    if ind_max == 1
        pt_stress = [pt(7) pt(8) pt(9) pt(4) pt(5) pt(6) pt(1) pt(2) pt(3)]; 
    elseif ind_max == 2
        pt_stress = [pt(7) pt(8) pt(9) pt(1) pt(2) pt(3) pt(4) pt(5) pt(6)]; 
    end
end
