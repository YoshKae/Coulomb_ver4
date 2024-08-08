function DCCON2(XI,ET,Q,SD,CD)
% Okada 92 code subroutine DCCON2
%
global XI2 ET2 Q2 R R2 R3 R5 Y D TT ALX ALE X11 Y11 X32 Y32
global EY EZ FY FZ GY GZ HY HZ
global N_CELL

%disp('DCCON2');
% DATA  F0,F1,F2,EPS/0.D0,1.D0,2.D0,1.D-6/
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
EPS = ones(N_CELL,1,'double').*0.000001;

c1 = abs(XI) < EPS;
c2 = abs(XI) >= EPS;
% if abs(XI)<EPS
%     XI=F0;
% end
XI = F0.*c1 + XI.*c2;
% if abs(ET)<EPS
%     ET=F0;
% end
c1 = abs(ET) < EPS;
c2 = abs(ET) >= EPS;
ET = F0.*c1 + ET.*c2;
% if abs( Q)<EPS
%     Q=F0;
% end
c1 = abs(Q) < EPS;
c2 = abs(Q) >= EPS;
Q = F0.*c1 + Q.*c2;

      XI2=XI.*XI;
      ET2=ET.*ET;
      Q2=Q.*Q;
      R2=XI2+ET2+Q2;
      R =double(sqrt(R2));
c1 = R==F0;
c1_sum = sum(rot90(sum(c1)));
if c1_sum > 0
    return;
end
      R3=R .*R2;
      R5=R3.*R2;
      Y =ET.*CD+Q.*SD;
      D =ET.*SD-Q.*CD;
%C----- 
c1 = Q == F0;
c2 = Q ~= F0;
s1 = Q.*R == F0;
s2 = Q.*R ~= F0;
% if Q==F0                                                  %10480000
%         TT=F0;                                                           %10490000
% else
% %    	if (Q.*R)==0.0                  % modified by Shinji Toda
% %        TT=double(atan(XI.*ET./EPS));  % modified by Shinji Toda 
% %        else                            % modified by Shinji Toda
%         TT=double(atan(XI.*ET./(Q.*R)));  
% %        end                             % modified by Shinji Toda
% end

% TT = c1.*F0 + c2.*(double(atan(XI.*ET./EPS)).*s1+double(atan(XI.*ET./(Q.*R))).*s2);
TT = c1.*F0 + c2.*double(atan(XI.*ET./(Q.*R)));

%C-----  
c1 = XI < F0; c2 = Q == F0; c3 = ET == F0;
c4 = c1.*c2.*c3;
c5 = zeros(N_CELL,1,'double'); c5 = (c5 - c4)+1.0;
        RXI=R+XI;
        ALX = (-double(log(R-XI))).*c4 + double(log(RXI)).*c5;
        X11 = F0.*c4 + (F1./(R.*RXI)).*c5;
        X32 = F0.*c4 + ((R+RXI).*X11.*X11./R) .*c5;
%       if(XI<F0 & Q==F0 & ET==F0)                    %10540002
%         ALX=-double(log(R-XI));                                                 %10550000
%         X11=F0;                                                          %10560000
%         X32=F0;                                                          %10570000
%       else                                                              %10580000
%         RXI=R+XI;                                                        %10590002
%         ALX=double(log(RXI));                                                   %10600000
%         X11=F1./(R.*RXI);                                                  %106%10000
%         X32=(R+RXI).*X11.*X11./R;                                           %10620002
%       end                                                             %10630000
%C----- 
c1 = ET < F0; c2 = Q == F0; c3 = XI == F0;
c4 = c1.*c2.*c3;
c5 = zeros(N_CELL,1,'double'); c5 = (c5 - c4)+1.0;
        RET=R+ET;
        ALE = (-double(log(R-ET))).*c4 + double(log(RET)).*c5;
        Y11 = F0.*c4 + (F1./(R.*RET)).*c5;
        Y32 = F0.*c4 + ((R+RET).*Y11.*Y11./R).*c5;
%         
%       if(ET<F0 & Q==F0 & XI==F0)                   %10650002
%         ALE=-double(log(R-ET));                                                 %10660000
%         Y11=F0;                                                          %10670000
%         Y32=F0;                                                          %10680000
%       else                                                              %10690000
%         RET=R+ET;                                                        %10700002
%         ALE=double(log(RET));                                                   %107%10000
%         Y11=F1./(R.*RET);                                                  %10720000
%         Y32=(R+RET).*Y11.*Y11./R;                                          %10730002
%       end                                                             %10740000
%C-----                                                                  %10750000
      EY=SD./R-Y.*Q./R3;                                                    %10760000
      EZ=CD./R+D.*Q./R3;                                                    %10770000
      FY=D./R3+XI2.*Y32.*SD;                                                %10780000
      FZ=Y./R3+XI2.*Y32.*CD;                                                %10790000
      GY=F2.*X11.*SD-Y.*Q.*X32;                                              %10800000
      GZ=F2.*X11.*CD+D.*Q.*X32;                                              %108%10000
      HY=D.*Q.*X32+XI.*Q.*Y32.*SD;                                            %10820000
      HZ=Y.*Q.*X32+XI.*Q.*Y32.*CD;                                            %10830000
%      RETURN                                                            %10840000
%      END                                                               %10850000
