function DCCON0(ALPHA,DIP)
% Okada 92 code subroutine DCCON0
%
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global N_CELL
%       DATA F0,F1,F2,PI2/0.D0,1.D0,2.D0,6.283185307179586D0/             %09430000
%       DATA EPS/1.D-6/ 
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;
EPS = ones(N_CELL,1,'double').*1.0e-6;

      ALP1=(F1-ALPHA)./F2;
      ALP2= ALPHA./F2;
      ALP3=(F1-ALPHA)./ALPHA;
      ALP4= F1-ALPHA;
      ALP5= ALPHA;

      P18=PI2./double(360.0);                                                    %09520000
      SD=double(sin(DIP.*P18));                                                  %09530000
      CD=double(cos(DIP.*P18)); 
        c1 = abs(CD) < EPS;
        c2 = abs(CD) >= EPS;
        s1 = SD > F0;
        s2 = SD == F0;
        s3 = SD < F0;

        CD = F0.*c1 + CD.*c2;

% CAUTION ************ modified by Shinji Toda (CD = 0.0 produces 'nan')
%                      in MATLAB
%         c3 = abs(CD) < EPS;
%         c4 = abs(CD) <= EPS;
%         CD = c3.*EPS + c4.*CD;
% CAUTION ***************************************************************

%09560000
%     if SD>F0
%        SD= F1;
%     end
%     if SD<F0
%         SD=-F1;                                             %09580000
%     end
    SD = c1.*(F1.*s1 + SD.*s2 + (-1.0).*F1.*s3) + c2.*SD;
%end
                                                            %09590000
      SDSD=SD.*SD;                                                        %09600000
      CDCD=CD.*CD;                                                        %09610000
      SDCD=SD.*CD;                                                        %09620000
      S2D=F2.*SDCD;                                                       %09630000
      C2D=CDCD-SDSD;                                                     %09640000
%       RETURN                                                            %09650000
%       END                                                               %09660000
