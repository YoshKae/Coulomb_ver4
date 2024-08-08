function [U] = UA0(X,Y,D,POT1,POT2,POT3,POT4)
%       SUBROUTINE  UA0(X,Y,D,POT1,POT2,POT3,POT4,U)                      01140000
%       IMPLICIT REAL*8 (A-H,O-Z)                                         01150000
%       DIMENSION U(12),DU(12)                                            01160000
% C                                                                       01170000
% C********************************************************************   01180000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-A)             *****   01190000
% C*****    DUE TO BURIED POINT SOURCE IN A SEMIINFINITE MEDIUM   *****   01200000
% C********************************************************************   01210000
% C                                                                       01220000
% C***** INPUT                                                            01230000
% C*****   X,Y,D : STATION COORDINATES IN FAULT SYSTEM                    01240000
% C*****   POT1-POT4 : STRIKE-, DIP-, TENSILE- AND INFLATE-POTENCY        01250000
% C***** OUTPUT                                                           01260000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     01270000
% C                                                                       01280000
%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  01290000
%       COMMON /C1/P,Q,S,T,XY,X2,Y2,D2,R,R2,R3,R5,QR,QRX,A3,A5,B3,C3,     01300000
%      *           UY,VY,WY,UZ,VZ,WZ                                      01310000
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global P Q S T XY X2 Y2 D2 R R2 R3 R5 QR QRX A3 A5 B3 C3 UY VY WY UZ VZ WZ
global N_CELL

F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F3 = ones(N_CELL,1,'double').*3.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

%       DATA F0,F1,F3/0.D0,1.D0,3.D0/                                     01320000
%       DATA PI2/6.283185307179586D0/                                     01330000
% C-----                                                                  01340000
%       DO 111  I=1,12                                                    01350000
%   111 U(I)=F0

DU = zeros(N_CELL,12,'double');
U  = zeros(N_CELL,12,'double');

% C======================================                                 01370000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 01380000
% C======================================
%       IF(POT1.NE.F0) THEN                                               01400000
c1 = POT1 ~= F0;
	DU(:,1)= ALP1.*Q./R3    +ALP2.*X2.*QR;
    DU(:,2)= ALP1.*X./R3.*SD +ALP2.*XY.*QR;
    DU(:,3)=-ALP1.*X./R3.*CD +ALP2.*X.*D.*QR;
    DU(:,4)= X.*QR.*(-ALP1 +ALP2.*(F1+A5) );
    DU(:,5)= ALP1.*A3./R3.*SD +ALP2.*Y.*QR.*A5;
    DU(:,6)=-ALP1.*A3./R3.*CD +ALP2.*D.*QR.*A5;
    DU(:,7)= ALP1.*(SD./R3-Y.*QR) +ALP2.*F3.*X2./R5.*UY;
    DU(:,8)= F3.*X./R5.*(-ALP1.*Y.*SD +ALP2.*(Y.*UY+Q) );
    DU(:,9)= F3.*X./R5.*( ALP1.*Y.*CD +ALP2.*D.*UY );
    DU(:,10)= ALP1.*(CD./R3+D.*QR) +ALP2.*F3.*X2./R5.*UZ;
    DU(:,11)= F3.*X./R5.*( ALP1.*D.*SD +ALP2.*Y.*UZ );
    DU(:,12)= F3.*X./R5.*(-ALP1.*D.*CD +ALP2.*(D.*UZ-Q) );
%for I=1:12
%	U(:,I)=U(I)+POT1/PI2*DU(I);    
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT1./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
%end
% C===================================                                    01560000
% C=====  DIP-SLIP CONTRIBUTION  =====                                    01570000
% C===================================                                    01580000
%       IF(POT2.NE.F0) THEN 
c2 = POT2 ~= F0;
    DU(:,1)=            ALP2.*X.*P.*QR;
    DU(:,2)= ALP1.*S./R3 +ALP2.*Y.*P.*QR;
    DU(:,3)=-ALP1.*T./R3 +ALP2.*D.*P.*QR;
    DU(:,4)=                 ALP2.*P.*QR.*A5;
    DU(:,5)=-ALP1.*F3.*X.*S./R5 -ALP2.*Y.*P.*QRX;
    DU(:,6)= ALP1.*F3.*X.*T./R5 -ALP2.*D.*P.*QRX;
    DU(:,7)=                          ALP2.*F3.*X./R5.*VY;
    DU(:,8)= ALP1.*(S2D./R3-F3.*Y.*S./R5) +ALP2.*(F3.*Y./R5.*VY+P.*QR);
    DU(:,9)=-ALP1.*(C2D./R3-F3.*Y.*T./R5) +ALP2.*F3.*D./R5.*VY;
    DU(:,10)=                          ALP2.*F3.*X./R5.*VZ;
    DU(:,11)= ALP1.*(C2D./R3+F3.*D.*S./R5) +ALP2.*F3.*Y./R5.*VZ;
    DU(:,12)= ALP1.*(S2D./R3-F3.*D.*T./R5) +ALP2.*(F3.*D./R5.*VZ-P.*QR);
%         DO 333 I=1,12                                                   01720000
%   333   U(I)=U(I)+POT2/PI2*DU(I)                                        01730000
%       ENDIF 
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT2./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c2,1,12);
% C========================================                               01750000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               01760000
% C========================================                               01770000
%       IF(POT3.NE.F0) THEN                                               01780000
c3 = POT3 ~= F0;
	DU(:,1)= ALP1.*X./R3 -ALP2.*X.*Q.*QR;
	DU(:,2)= ALP1.*T./R3 -ALP2.*Y.*Q.*QR;
	DU(:,3)= ALP1.*S./R3 -ALP2.*D.*Q.*QR;
	DU(:,4)= ALP1.*A3./R3     -ALP2.*Q.*QR.*A5;
	DU(:,5)=-ALP1.*F3.*X.*T./R5 +ALP2.*Y.*Q.*QRX;
	DU(:,6)=-ALP1.*F3.*X.*S./R5 +ALP2.*D.*Q.*QRX;
	DU(:,7)=-ALP1.*F3.*XY./R5           -ALP2.*X.*QR.*WY;
	DU(:,8)= ALP1.*(C2D./R3-F3.*Y.*T./R5) -ALP2.*(Y.*WY+Q).*QR;
	DU(:,9)= ALP1.*(S2D./R3-F3.*Y.*S./R5) -ALP2.*D.*QR.*WY;
	DU(:,10)= ALP1.*F3.*X.*D./R5          -ALP2.*X.*QR.*WZ;
	DU(:,11)=-ALP1.*(S2D./R3-F3.*D.*T./R5) -ALP2.*Y.*QR.*WZ;
	DU(:,12)= ALP1.*(C2D./R3+F3.*D.*S./R5) -ALP2.*(D.*WZ-Q).*QR;
%         DO 444 I=1,12                                                   01910000
%   444   U(I)=U(I)+POT3/PI2*DU(I)                                        01920000
%       ENDIF                                                             01930000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT3./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
% C=========================================                              01940000
% C=====  INFLATE SOURCE CONTRIBUTION  =====                              01950000
% C=========================================                              01960000
%       IF(POT4.NE.F0) THEN                                               01970000
c4 = POT4 ~= F0;
	DU(:,1)=-ALP1.*X./R3;
	DU(:,2)=-ALP1.*Y./R3;
	DU(:,3)=-ALP1.*D./R3;
	DU(:,4)=-ALP1.*A3./R3;
	DU(:,5)= ALP1.*F3.*XY./R5;
	DU(:,6)= ALP1.*F3.*X.*D./R5;
	DU(:,7)= DU(:,5);
	DU(:,8)=-ALP1.*B3./R3;
	DU(:,9)= ALP1.*F3.*Y.*D./R5;
	DU(:,10)=-DU(:,6);
	DU(:,11)=-DU(:,9);
	DU(:,12)= ALP1.*C3./R3;
%         DO 555 I=1,12                                                   02100000
%   555   U(I)=U(I)+POT4/PI2*DU(I)                                        02110000
%       ENDIF                                                             02120000
%       RETURN                                                            02130000
%       END                                                               02140000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT4./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c4,1,12);

