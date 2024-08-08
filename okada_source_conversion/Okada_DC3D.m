function[UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,IRET] = Okada_DC3D(ALPHA,...
                X,Y,Z,DEPTH,DIP,...
                AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3)
            
%       IMPLICIT REAL*8 (A-H,O-Z)                                         04640000
%       REAL*4   ALPHA,X,Y,Z,DEPTH,DIP,AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3, 04650000
%      *         UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ             04660000
% C                                                                       04670000
% C********************************************************************   04680000
% C*****                                                          *****   04690000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH                      *****   04700000
% C*****    DUE TO BURIED FINITE FAULT IN A SEMIINFINITE MEDIUM   *****   04710000
% C*****                         CODED BY  Y.OKADA ... SEP 1991   *****   04720002
% C*****                         REVISED   Y.OKADA ... NOV 1991   *****   04730002
% C*****                                                          *****   04740000
% C********************************************************************   04750000
% C                                                                       04760000
% C***** INPUT                                                            04770000
% C*****   ALPHA : MEDIUM CONSTANT  (LAMBDA+MYU)/(LAMBDA+2*MYU)           04780000
% C*****   X,Y,Z : COORDINATE OF OBSERVING POINT                          04790000
% C*****   DEPTH : SOURCE DEPTH                                           04800000
% C*****   DIP   : DIP-ANGLE (DEGREE)                                     04810000
% C*****   AL1,AL2   : FAULT LENGTH (-STRIKE,+STRIKE)                     04820000
% C*****   AW1,AW2   : FAULT WIDTH  ( DOWNDIP, UPDIP)                     04830000
% C*****   DISL1-DISL3 : STRIKE-, DIP-, TENSILE-DISLOCATIONS              04840000
% C                                                                       04850000
% C***** OUTPUT                                                           04860000
% C*****   UX, UY, UZ  : DISPLACEMENT ( UNIT=(UNIT OF DISL)               04870000
% C*****   UXX,UYX,UZX : X-DERIVATIVE ( UNIT=(UNIT OF DISL) /             04880000
% C*****   UXY,UYY,UZY : Y-DERIVATIVE        (UNIT OF X,Y,Z,DEPTH,AL,AW) )04890000
% C*****   UXZ,UYZ,UZZ : Z-DERIVATIVE                                     04900000
% C*****   IRET        : RETURN CODE  ( =0....NORMAL,   =1....SINGULAR )  04910002
% C                                                                       04920000
    global DUMMY SD CD
    global XI2 ET2 Q2 R
    global N_CELL

    N_CELL = numel(X);
    
%       COMMON /C0/DUMMY(5),SD,CD                                         04930000
%       COMMON /C2/XI2,ET2,Q2,R                                           04940000
%       DIMENSION  U(12),DU(12),DUA(12),DUB(12),DUC(12)                   04950000
%       DATA  F0/0.D0/                                                    04960000

%    F0 = double(0.0);
F0 = zeros(N_CELL,1,'double');
%C----- 
if Z>0.0
    disp(' ** POSITIVE Z WAS GIVEN IN SUB-DC3D');
end
%for I=1:1:12
        U    = zeros(N_CELL,12,'double');
        DUA  = zeros(N_CELL,12,'double');
        DUB  = zeros(N_CELL,12,'double');
        DUC  = zeros(N_CELL,12,'double');
        IRET = zeros(N_CELL,1,'double');
%         U  (1:N_CELL,1:12)=0.0;
%         DUA(1:N_CELL,1:12)=0.0;
%         DUB(1:N_CELL,1:12)=0.0;
%         DUC(1:N_CELL,1:12)=0.0;
%         IRET(1:N_CELL,1:12)=0.0;
%end
      AALPHA=ALPHA;
      DDIP=DIP;
% % NEED TO CHECK THE CODE CAREFULLY but here is a temporal solution!
% % high dip gives really unstable solutions
%        if DDIP>=89.999
%            DDIP = double(89.999);
%        end
      
DCCON0(AALPHA,DDIP);
% C======================================                                 05080000
% C=====  REAL-SOURCE CONTRIBUTION  =====                                 05090000
% C======================================                                 05100000
      D=DEPTH+Z;
      P=Y.*CD+D.*SD;
      Q=Y.*SD-D.*CD;
%       JXI=0;
%       JET=0;
        JXI = int8(zeros(N_CELL,1));
        JET = int8(zeros(N_CELL,1));
      aa = (X+AL1).*(X-AL2);
        cneg = aa <= 0.0;
        JXI = JXI + int8(cneg);
        jxi_sum = sum(rot90(sum(JXI)));
      bb = (P+AW1).*(P-AW2);
        cneg = bb <= 0.0; 
        JET = JET + int8(cneg);
        jet_sum = sum(rot90(sum(JET)));
%       if aa<=0.0
%           JXI=1;
%       end
%       if bb<=0.0
%           JET=1;
%       end
      DD1=DISL1;
      DD2=DISL2;
      DD3=DISL3;
%C-----                                                                  05210000
for K=1:2
      if(K==1)
          ET=P+AW1;
      end
      if(K==2)
          ET=P-AW2;
      end
    for J=1:2
        if(J==1)
            XI=X+AL1;
        end
        if(J==2)
            XI=X-AL2;
        end
            
DCCON2(XI,ET,Q,SD,CD);

% To detect singular point
    cjxi1 = JXI == 1;
    cjxi2 = JXI ~= 1;
    cjet1 = JET == 1;
    cjet2 = JET ~= 1;
    cq1   = abs(Q)   <= 1.0e-12;
    cq2   = abs(Q)   > 1.0e-12;
    cet1  = abs(ET)  <= 1.0e-12;
    cet2  = abs(ET)  > 1.0e-12;
    cxi1  = abs(XI)  <= 1.0e-12;
    cxi2  = abs(XI)  > 1.0e-12;
%     cq1   = Q  == 0.0;
%     cq2   = Q  ~= 0.0;
%     cet1  = ET  == 0.0;
%     cet2  = ET  ~= 0.0;
%     cxi1  = XI  == 0.0;
%     cxi2  = XI  ~= 0.0;
    cc1 = cjxi1.*cq1.*cet1; cc2 = (cc1 - 1.0).*(-1.0);
    cc3 = cjet1.*cq1.*cxi1; cc4 = (cc3 - 1.0).*(-1.0);
    cc0 = (cc1 + cc3) >= 1;
    cc5 = (cc1 + cc3) < 1;
	IRET = IRET + cc0;
% sum(rot90(sum(cc3)))

%         q_sum = sum(rot90(sum(Q)));
%         et_sum = sum(rot90(sum(ET)));
%         xi_sum = sum(rot90(sum(ET)));
% %        if ((jxi_sum>=1 & Q==F0 & ET==F0) | (jet_sum>=1 & Q==F0 & XI==F0))
%         if ((jxi_sum>=1 & q_sum==0.0 & et_sum==0.0) | (jet_sum>=1 & q_sum==0.0 & xi_sum==0.0))
% %        if ((jxi_sum>=1) | (jet_sum>=1))
% % C=======================================                                06030000
% % C=====  IN CASE OF SINGULAR (R=0)  =====                                06040000
% % C=======================================                                06050000
%          UX=zeros(N_CELL,1,'double');
%          UY=zeros(N_CELL,1,'double');
%          UZ=zeros(N_CELL,1,'double');
%          UXX=zeros(N_CELL,1,'double');
%          UYX=zeros(N_CELL,1,'double');
%          UZX=zeros(N_CELL,1,'double');
%          UXY=zeros(N_CELL,1,'double');
%          UYY=zeros(N_CELL,1,'double');
%          UZY=zeros(N_CELL,1,'double');
%          UXZ=zeros(N_CELL,1,'double');
%          UYZ=zeros(N_CELL,1,'double');
%          UZZ=zeros(N_CELL,1,'double');
%          IRET=ones(N_CELL,1,'double');
%             disp('error');
% %         return
%             break;
%          end
DUA = UA(XI,ET,Q,DD1,DD2,DD3);
%C-----                                                                  05320000
        for I=1:3:10
          DU(:,I)  =-DUA(:,I);
          DU(:,I+1)=-DUA(:,I+1).*CD+DUA(:,I+2).*SD;
          DU(:,I+2)=-DUA(:,I+1).*SD-DUA(:,I+2).*CD;
          if I<10.0
            continue;
          end
          DU(:,I)  =-DU(:,I);
          DU(:,I+1)=-DU(:,I+1);
          DU(:,I+2)=-DU(:,I+2);
        end
%        for I=1:1:12
          if(J+K)~=3
              U(:,1:12)=U(:,1:12)+DU(:,1:12);
          end
          if(J+K)==3
              U(:,1:12)=U(:,1:12)-DU(:,1:12);
          end
%        end
    end
end
% C=======================================                                05490000
% C=====  IMAGE-SOURCE CONTRIBUTION  =====                                05500000
% C=======================================                                05510000
      ZZ=Z;
      D=DEPTH-Z;
      P=Y.*CD+D.*SD;
      Q=Y.*SD-D.*CD;
%      JET=0;
    JET = int8(ones(N_CELL,1));
      
      cc=(P+AW1).*(P-AW2);
      
      c1 = cc <= 0.0;
      c2 = cc >  0.0;
      JET = int8(c1).*JET;
%       if cc<=0.0
%           JET=1;
%       end
%C-----                                                                  05580000
for K=1:2
      if K==1 
          ET=P+AW1;
      end
      if K==2
          ET=P-AW2;
      end
      for J=1:2
        if J==1
          XI=X+AL1;
        end
        if J==2
          XI=X-AL2;
        end
        DCCON2(XI,ET,Q,SD,CD);
        DUA = UA(XI,ET,Q,DD1,DD2,DD3);
        DUB = UB(XI,ET,Q,DD1,DD2,DD3);
        DUC = UC(XI,ET,Q,ZZ,DD1,DD2,DD3);        
%C-----                                                                  05690000
        for I=1:3:10
          DU(:,I)=DUA(:,I)+DUB(:,I)+Z.*DUC(:,I);
          DU(:,I+1)=(DUA(:,I+1)+DUB(:,I+1)+Z.*DUC(:,I+1)).*CD...
                    -(DUA(:,I+2)+DUB(:,I+2)+Z.*DUC(:,I+2)).*SD;
          DU(:,I+2)=(DUA(:,I+1)+DUB(:,I+1)-Z.*DUC(:,I+1)).*SD...
                    +(DUA(:,I+2)+DUB(:,I+2)-Z.*DUC(:,I+2)).*CD;
                if I<10.0
                    continue;
                end
          DU(:,10)=DU(:,10)+DUC(:,1);
          DU(:,11)=DU(:,11)+DUC(:,2).*CD-DUC(:,3).*SD;
          DU(:,12)=DU(:,12)-DUC(:,2).*SD-DUC(:,3).*CD;
        end
%        for I=1:1:12
          if(J+K~=3)
              U(:,1:12)=U(:,1:12)+DU(:,1:12);
          end
          if(J+K==3)
              U(:,1:12)=U(:,1:12)-DU(:,1:12);
% end
        end
%C-----                                                                  05850000
      end
end

%C=====                                                                  05880000
      UX=U(:,1);
      UY=U(:,2);
      UZ=U(:,3);
      UXX=U(:,4);
      UYX=U(:,5);
      UZX=U(:,6);
      UXY=U(:,7);
      UYY=U(:,8);
      UZY=U(:,9);
      UXZ=U(:,10);
      UYZ=U(:,11);
      UZZ=U(:,12);
      cc5 = IRET >= 1;
      IRET = cc5;
%      IRET=0;
%      IRET = zeros(N_CELL,1,'double');
%      IRET = IRET + cc0;
      sum(rot90(sum(IRET)));
%       isa(UX,'double')
%       isa(UXX,'double')
%       isa(UYZ,'double')
%       isa(IRET,'double')
%       RETURN                                                            06020000
% C=======================================                                06030000
% C=====  IN CASE OF SINGULAR (R=0)  =====                                06040000
% C=======================================                                06050000
%    99 UX=F0                                                             06060000
%       UY=F0                                                             06070000
%       UZ=F0                                                             06080000
%       UXX=F0                                                            06090000
%       UYX=F0                                                            06100000
%       UZX=F0                                                            06110000
%       UXY=F0                                                            06120000
%       UYY=F0                                                            06130000
%       UZY=F0                                                            06140000
%       UXZ=F0                                                            06150000
%       UYZ=F0                                                            06160000
%       UZZ=F0                                                            06170000
%       IRET=1                                                            06180002
%       RETURN                                                            06190000
%       END
  
