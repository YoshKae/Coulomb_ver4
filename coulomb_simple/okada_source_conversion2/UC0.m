function [U] = UC0(X,Y,D,Z,POT1,POT2,POT3,POT4)

%       SUBROUTINE  UC0(X,Y,D,Z,POT1,POT2,POT3,POT4,U)                    03380000
%       IMPLICIT REAL*8 (A-H,O-Z)                                         03390000
%       DIMENSION U(12),DU(12)                                            03400000
% C                                                                       03410000
% C********************************************************************   03420000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-B)             *****   03430000
% C*****    DUE TO BURIED POINT SOURCE IN A SEMIINFINITE MEDIUM   *****   03440000
% C********************************************************************   03450000
% C                                                                       03460000
% C***** INPUT                                                            03470000
% C*****   X,Y,D,Z : STATION COORDINATES IN FAULT SYSTEM                  03480000
% C*****   POT1-POT4 : STRIKE-, DIP-, TENSILE- AND INFLATE-POTENCY        03490000
% C***** OUTPUT                                                           03500000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     03510000
% C                                                                       03520000
%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  03530000
%       COMMON /C1/P,Q,S,T,XY,X2,Y2,D2,R,R2,R3,R5,QR,QRX,A3,A5,B3,C3      03540000
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global P Q S T XY X2 Y2 D2 R R2 R3 R5 QR QRX A3 A5 B3 C3
global N_CELL
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
F3 = ones(N_CELL,1,'double').*3.0;
F4 = ones(N_CELL,1,'double').*4.0;
F5 = ones(N_CELL,1,'double').*5.0;
F7 = ones(N_CELL,1,'double').*7.0;
F10 = ones(N_CELL,1,'double').*10.0;
F15 = ones(N_CELL,1,'double').*15.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

%       DATA F0,F1,F2,F3,F5,F7,F10,F15                                    03550000
%      *        /0.D0,1.D0,2.D0,3.D0,5.D0,7.D0,10.D0,15.D0/               03560000
%       DATA PI2/6.283185307179586D0/                                     03570000

% C-----                                                                  03580000
	C=D+Z;
    Q2=Q.*Q;
	R7=R5.*R2;
	A7=F1-F7.*X2./R2;
	B5=F1-F5.*Y2./R2;
	B7=F1-F7.*Y2./R2;
	C5=F1-F5.*D2./R2;
	C7=F1-F7.*D2./R2;
	D7=F2-F7.*Q2./R2;
	QR5=F5.*Q./R2;
	QR7=F7.*Q./R2;
	DR5=F5.*D./R2;
% C-----                                                                  03710000
%       DO 111  I=1,12
%       03720000
%   111 U(I)=F0                                                           03730000
    U  = zeros(N_CELL,12,'double');
% C======================================                                 03740000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 03750000
% C======================================                                 03760000
%       IF(POT1.NE.F0) THEN                                               03770000
c1 = POT1 ~= F0;
	DU(:,1)=-ALP4.*A3./R3.*CD  +ALP5.*C.*QR.*A5;
	DU(:,2)= F3.*X./R5.*( ALP4.*Y.*CD +ALP5.*C.*(SD-Y.*QR5) );
	DU(:,3)= F3.*X./R5.*(-ALP4.*Y.*SD +ALP5.*C.*(CD+D.*QR5) );
	DU(:,4)= ALP4.*F3.*X./R5.*(F2+A5).*CD   -ALP5.*C.*QRX.*(F2+A7);
	DU(:,5)= F3./R5.*( ALP4.*Y.*A5.*CD +ALP5.*C.*(A5.*SD-Y.*QR5.*A7) );
	DU(:,6)= F3./R5.*(-ALP4.*Y.*A5.*SD +ALP5.*C.*(A5.*CD+D.*QR5.*A7) );
	DU(:,7)= DU(:,5);
	DU(:,8)= F3.*X./R5.*( ALP4.*B5.*CD -ALP5.*F5.*C./R2.*(F2.*Y.*SD+Q.*B7) );
	DU(:,9)= F3.*X./R5.*(-ALP4.*B5.*SD +ALP5.*F5.*C./R2.*(D.*B7.*SD-Y.*C7.*CD) );
	DU(:,10)= F3./R5.*   (-ALP4.*D.*A5.*CD +ALP5.*C.*(A5.*CD+D.*QR5.*A7) );
	DU(:,11)= F15.*X./R7.*( ALP4.*Y.*D.*CD  +ALP5.*C.*(D.*B7.*SD-Y.*C7.*CD) );
	DU(:,12)= F15.*X./R7.*(-ALP4.*Y.*D.*SD  +ALP5.*C.*(F2.*D.*CD-Q.*C7) );
%         DO 222 I=1,12                                                   03900000
%   222   U(I)=U(I)+POT1/PI2*DU(I)                                        03910000
%       ENDIF                                                             03920000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT1./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
% C===================================                                    03930000
% C=====  DIP-SLIP CONTRIBUTION  =====                                    03940000
% C===================================
%       IF(POT2.NE.F0) THEN                                               03960000
c2 = POT2 ~= F0;
	DU(:,1)= ALP4.*F3.*X.*T./R5-ALP5.*C.*P.*QRX;
	DU(:,2)=-ALP4./R3.*(C2D-F3.*Y.*T./R2)...
        +ALP5.*F3.*C./R5.*(S-Y.*P.*QR5);
	DU(:,3)=-ALP4.*A3./R3.*SDCD+ALP5.*F3.*C./R5.*(T+D.*P.*QR5);
	DU(:,4)= ALP4.*F3.*T./R5.*A5-ALP5.*F5.*C.*P.*QR./R2.*A7;
	DU(:,5)= F3.*X./R5.*(ALP4.*(C2D-F5.*Y.*T./R2)...
        -ALP5.*F5.*C./R2.*(S-Y.*P.*QR7));
	DU(:,6)= F3.*X./R5.*(ALP4.*(F2+A5).*SDCD...
        -ALP5.*F5.*C./R2.*(T+D.*P.*QR7));
	DU(:,7)= DU(:,5);
	DU(:,8)= F3./R5.*(ALP4.*(F2.*Y.*C2D+T.*B5)...
        +ALP5.*C.*(S2D-F10.*Y.*S./R2-P.*QR5.*B7));
	DU(:,9)= F3./R5.*(ALP4.*Y.*A5.*SDCD...
        -ALP5.*C.*((F3+A5).*C2D+Y.*P.*DR5.*QR7));
	DU(:,10)= F3.*X./R5.*(-ALP4.*(S2D-T.*DR5)...
        -ALP5.*F5.*C./R2.*(T+D.*P.*QR7));
	DU(:,11)= F3./R5.*(-ALP4.*(D.*B5.*C2D+Y.*C5.*S2D)...
        -ALP5.*C.*((F3+A5).*C2D+Y.*P.*DR5.*QR7));
	DU(:,12)= F3./R5.*(-ALP4.*D.*A5.*SDCD...
        -ALP5.*C.*(S2D-F10.*D.*T./R2+P.*QR5.*C7));
%         DO 333 I=1,12                                                   04110000
%   333   U(I)=U(I)+POT2/PI2*DU(I)                                        04120000
%       ENDIF                                                             04130000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT2./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c2,1,12);
% C========================================                               04140000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               04150000
% C========================================                               04160000
%       IF(POT3.NE.F0) THEN                                               04170000
c3 = POT3 ~= F0;
	DU(:,1)= F3.*X./R5.*(-ALP4.*S +ALP5.*(C.*Q.*QR5-Z));
	DU(:,2)= ALP4./R3.*(S2D-F3.*Y.*S./R2)...
        +ALP5.*F3./R5.*(C.*(T-Y+Y.*Q.*QR5)-Y.*Z);
	DU(:,3)=-ALP4./R3.*(F1-A3.*SDSD)...
        -ALP5.*F3./R5.*(C.*(S-D+D.*Q.*QR5)-D.*Z);
	DU(:,4)=-ALP4.*F3.*S./R5.*A5...
        +ALP5.*(C.*QR.*QR5.*A7-F3.*Z./R5.*A5);
	DU(:,5)= F3.*X./R5.*(-ALP4.*(S2D-F5.*Y.*S./R2)...
        -ALP5.*F5./R2.*(C.*(T-Y+Y.*Q.*QR7)-Y.*Z));
    DU(:,6)= F3.*X./R5.*( ALP4.*(F1-(F2+A5).*SDSD)...
        +ALP5.*F5./R2.*(C.*(S-D+D.*Q.*QR7)-D.*Z));
	DU(:,7)= DU(:,5);
	DU(:,8)= F3./R5.*(-ALP4.*(F2.*Y.*S2D+S.*B5)...
        -ALP5.*(C.*(F2.*SDSD+F10.*Y.*(T-Y)./R2-Q.*QR5.*B7)+Z.*B5));
	DU(:,9)= F3./R5.*( ALP4.*Y.*(F1-A5.*SDSD)...
        +ALP5.*(C.*(F3+A5).*S2D-Y.*DR5.*(C.*D7+Z)));
	DU(:,10)= F3.*X./R5.*(-ALP4.*(C2D+S.*DR5)...
        +ALP5.*(F5.*C./R2.*(S-D+D.*Q.*QR7)-F1-Z.*DR5));
	DU(:,11)= F3./R5.*( ALP4.*(D.*B5.*S2D-Y.*C5.*C2D)...
        +ALP5.*(C.*((F3+A5).*S2D-Y.*DR5.*D7)-Y.*(F1+Z.*DR5)));
	DU(:,12)= F3./R5.*(-ALP4.*D.*(F1-A5.*SDSD)...
        -ALP5.*(C.*(C2D+F10.*D.*(S-D)./R2-Q.*QR5.*C7)+Z.*(F1+C5)));
%         DO 444 I=1,12                                                   04370000
%   444   U(I)=U(I)+POT3/PI2*DU(I)                                        04380000
%       ENDIF                                                             04390000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT3./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
% C=========================================                              04400000
% C=====  INFLATE SOURCE CONTRIBUTION  =====                              04410000
% C=========================================                              04420000
%       IF(POT4.NE.F0) THEN                                               04430000
c4 = POT4 ~= F0;
	DU(:,1)= ALP4.*F3.*X.*D./R5;
	DU(:,2)= ALP4.*F3.*Y.*D./R5;
	DU(:,3)= ALP4.*C3./R3;
	DU(:,4)= ALP4.*F3.*D./R5.*A5;
	DU(:,5)=-ALP4.*F15.*XY.*D./R7;
	DU(:,6)=-ALP4.*F3.*X./R5.*C5;
	DU(:,7)= DU(:,5);
	DU(:,8)= ALP4.*F3.*D./R5.*B5;
	DU(:,9)=-ALP4.*F3.*Y./R5.*C5;
	DU(:,10)= DU(:,6);
	DU(:,11)= DU(:,9);
	DU(:,12)= ALP4.*F3.*D./R5.*(F2+C5);
%         DO 555 I=1,12                                                   04560000
%   555   U(I)=U(I)+POT4/PI2*DU(I)                                        04570000
%       ENDIF                                                             04580000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT4./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c4,1,12);
%       RETURN                                                            04590000
%       END                                                               04600000
