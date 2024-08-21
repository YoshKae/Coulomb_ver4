function [outsdr] = nodal_plane_calc(st1,dp1,rk1)
%          dimension sdr(3), p(2),t(2),b(2),ptb(6),dum1(3),dum2(3),dum3(3)
%          write(6,'(a,$)') 'INPUT (strike,dip,rake)-->   '
%          read(5,*) sdr(1),sdr(2),sdr(3)
% Original code was written by Hiroshi Tsuruoka, ERI, Univ. Tokyo in
% FORTRAN

% 90 deg causes error !
dp_index = find(dp1 == 90);
dp1(dp_index) = 89.99;

rk_index = find(rk1 == 90);
rk1(rk_index) = 89.5;

rk_index = find(rk1 == -90);
rk1(rk_index) = -89.5;

% to avoid error
st1 = st1 - 0.1;


m = length(st1);
sdr(:,1) = st1;
sdr(:,2) = dp1;
sdr(:,3) = rk1;
[ptb,dum1,dum2,dum3] = sdr2pt(sdr);
         p(:,1)=ptb(:,1);
         p(:,2)=ptb(:,2);
         t(:,1)=ptb(:,3);
         t(:,2)=ptb(:,4);
[st1,dp1,rk1,st2,dp2,rk2] = pt2sdr(p,t);

% process to find out the input nodal plane to make the order correct.
allowance = 1.5;
dum_st_min = sdr(:,1) - allowance; dum_st_max = sdr(:,1) + allowance; % strike check
dum_dp_min = sdr(:,2) - allowance; dum_dp_max = sdr(:,2) + allowance; % dip check
c1 = st1 > dum_st_min; c2 = st1 < dum_st_max;
c3 = dp1 > dum_dp_min; c4 = dp1 < dum_dp_max;
c5 = (c1 + c2 + c3 + c4) >= 4; c6 = (c1 + c2 + c3 + c4) < 4;
st11 = double(c5) .* double(st1) + double(c6) .* double(st2);
dp11 = double(c5) .* double(dp1) + double(c6) .* double(dp2);
rk11 = double(c5) .* double(rk1) + double(c6) .* double(rk2);
st22 = double(c6) .* double(st1) + double(c5) .* double(st2);
dp22 = double(c6) .* double(dp1) + double(c5) .* double(dp2);
rk22 = double(c6) .* double(rk1) + double(c5) .* double(rk2);
outsdr = [st11 dp11 rk11 st22 dp22 rk22];
% outsdr = [st1 dp1 rk1 st2 dp2 rk2];

%===============================================================
function [ptb,p,t,b] = sdr2pt(sdr)        
% subroutine sdr2pt(sdr,p,t,b,ptb) c=======================================================================
% c PURPOSE: STRIKE,DIP,RAKE --> P,T,B AXIS c=======================================================================
% c INPUT ARGUMENTS:
% c       sdr(1):strike
% c       sdr(2):dip
% c       sdr(3):rake
% c=======================================================================
% c OUTPUT ARGUMENTS:
% c       p: P axis (p(1),p(2),p(3)) -> (north,east,down)
% c       t: T axis
% c       b: B axis
% c       (ptb(1),ptb(2)): P axis (trend,plunge)
% c       (ptb(3),ptb(4)): T axis (trend,plunge)
% c       (ptb(5),ptb(6)): B axis (trend,plunge)
% c=======================================================================
% c // SUBROUTINE CALL: dsrin
% c=======================================================================
% c // FUNCTION CALL:
% c=======================================================================
% c MODIFICATION HISTORY
% c       SEP 11, 1994 ORIGINAL VERSION
% c=======================================================================
%          dimension sdr(3),p(3),t(3),b(3),ptb(6)
%          dimension angs(3),pttp(4),anbtp(6)
%         pi=3.14159
%         rad=pi/180.
         angs(:,2)=deg2rad(sdr(:,1));
         angs(:,1)=deg2rad(sdr(:,2));
         angs(:,3)=deg2rad(sdr(:,3));
%         call dsrin(angs,anbtp,pttp,p,t,b,pi)
        [pttp,anbtp,p,t,b] = dsrin(angs) ;
         ptb(:,1)=rad2deg(pttp(:,1));
         ptb(:,2)=rad2deg(pttp(:,2));
         ptb(:,3)=rad2deg(pttp(:,3));
         ptb(:,4)=rad2deg(pttp(:,4));
         ptb(:,5)=rad2deg(anbtp(:,5));
         ptb(:,6)=rad2deg(anbtp(:,6));

%=====================================================================
    function [pttp,anbtp,p,t,b] = dsrin(angs) 
%          SUBROUTINE DSRIN (ANGS,ANBTP,PTTP,p,t,b,PI) C
% C       Calculates other representations of fault planes with
% C               dip, strike and rake (A&R convinention) input.  All
% C               angles are in radians.
% C       22 July 1985:  Added moment tensor output (D&W convention)
% C                      normalized to unit scalar moment
% C-
%          REAL N(3), MOMTEN(6)
%          DIMENSION PTTP(4),ANGS(3),ANBTP(6),P(3),T(3),A(3),B(3)
%          DATA SR2/0.707107/
        sr2 = 0.707107;
         rake =angs(:,3);
         str = angs(:,2);
         dip = angs(:,1);

         a(:,1) = cos(double(rake)).*cos(double(str)) ...
             + sin(double(rake)).*cos(double(dip)).*sin(double(str));
         a(:,2) = cos(double(rake)).*sin(double(str)) ...
             - sin(double(rake)).*cos(double(dip)).*cos(double(str));
         a(:,3) = -sin(double(rake)).*sin(double(dip));
         n(:,1) = -sin(double(str)).*sin(double(dip));
         n(:,2) = cos(double(str)).*sin(double(dip));
         n(:,3) = -cos(double(dip));

         [dummy1] = v2trpl(a);
         [dummy2] = v2trpl(n);
%          [anbtp(1)] = v2trpl(a);
%          [anbtp(3)] = v2trpl(n);
         anbtp(:,1) = dummy1(:,1);
         anbtp(:,2) = dummy1(:,2);
         anbtp(:,3) = dummy2(:,1);
         anbtp(:,4) = dummy2(:,2);
         
%          CALL V2TRPL(a,ANBTP(1),PI)
%          CALL V2TRPL(N,ANBTP(3),PI)

%         DO 100 J=1,3
	t(:,1:3) = double(sr2.*(a(:,1:3) + n(:,1:3)));
	p(:,1:3) = double(sr2.*(a(:,1:3) - n(:,1:3)));  
         b(:,1) = p(:,2).*t(:,3) - p(:,3).*t(:,2);
         b(:,2) = p(:,3).*t(:,1) - p(:,1).*t(:,3);
         b(:,3) = p(:,1).*t(:,2) - p(:,2).*t(:,1);

%          p = p + 0.001;
         
         % problem code
         [dummy1]  = v2trpl(p);
         [dummy2]  = v2trpl(t);
         [dummy3]  = v2trpl(b);

%         disp('finish')

%          [pttp(1)]  = v2trpl(p);
%          [pttp(3)]  = v2trpl(t);
%          [anbtp(5)] = v2trpl(b);
         pttp(:,1) = dummy1(:,1);
         pttp(:,2) = dummy1(:,2);
         pttp(:,3) = dummy2(:,1);
         pttp(:,4) = dummy2(:,2);
         anbtp(:,5) = dummy3(:,1);
         anbtp(:,6) = dummy3(:,2);
         
         [momten]   = an2mom(a,n);
         
%          CALL V2TRPL(P,PTTP(1),PI)
%          CALL V2TRPL(T,PTTP(3),PI)
%          CALL V2TRPL(b,ANBTP(5),PI)
%          CALL AN2MOM(a,N,MOMTEN)

% C+
% C       SUBROUTINE AN2DSR(a,N,ANGS,PI)
% C
% C       Calculates dip, strike and rake (ANGS) - A&R convention,
% C               from a and N.
% C-
%=====================================================================
        function [angs] = an2dsr(a,n)
%             
%          SUBROUTINE AN2DSR(a,N,ANGS,PI)
%          REAL N(3),a(3),ANGS(3)
        c1 = abs(n(:,3)) == 1.0;
        c2 = abs(n(:,3)) ~= 1.0;
        angs(:,2) = (atan2(double(a(:,2)),double(a(:,1)))).*c1 ...
            + (atan2(double(-n(:,1)),double(n(:,2)))).*c2; 
        d1 = n(:,3) == 1.0;
        d2 = abs(sin(double(angs(:,2)))) >= 0.1;
        d2 = d2 .* (-1) .* (d1-1);
        d3 = (d1 + d2) <= 0.0;
        d  = 0.5*pi.*d1 + (atan2(double(-n(:,1)./sin(double(angs(:,2)))),...
            double(-n(:,3)))).*d2...
            + (atan2(double(n(:,2)./cos(double(angs(:,2)))),...
            double(-n(:,3)))).*d3;
        angs(:,1) = 0.0.*c1 + d.*c2;
           
         a1 = a(:,1).*cos(double(angs(:,2))) + a(:,2).*sin(double(angs(:,2)));
            c1 = abs(a1) < 0.001;
            c2 = abs(a1) >= 0.001;
         a1 = 0.0.*c1 + a1.*c2;
%          if abs(a1) < 0.0001
%              a1 = 0.0;
%          end
            c1 = a(:,3) ~= 0.0;
            c2 = a(:,3) == 0.0;
            d1 = abs(sin(2.*double(angs(:,2)))) >= 0.0001;
            d2 = abs(sin(double(angs(2)))) >= 0.0001;
            d2 = d2 .* (-1) .* (d1-1);
            d3 = d1 + d2 <= 0.0;
            a2 = a(:,1).*sin(double(angs(:,2))) - a(:,2).*cos(double(angs(:,2)));
            e1 = abs(a2) >= 0.0001;
            a2 = a2.*e1;
    angs(:,3) = (atan2(double(-a(:,3)./sin(double(angs(:,1)))),double(a1))).*c1...
            +((atan2(double(a2./sin(2*double(angs(:,2)))),double(a1))).*d1...
            +(acos(double(a(:,2)./sin(double(angs(:,2))))).*d2...
            +(acos(double(a1)))).*d3).*c2;

            c1 = angs(:,1) < 0.0;
            c2 = angs(:,1) >= 0.0;
            d1 = angs(:,3) > pi;
            d2 = angs(:,3) <= pi;
        angs(:,1) = (angs(:,1)+pi).*c1 + angs(:,1).*c2;
        angs(:,3) = ((angs(:,3) - 2*pi).*d1+(pi-angs(:,3)).*d2).*c1 + angs(:,3).*c2;

            c1 = angs(:,1) > 0.5*pi;
            c2 = angs(:,1) <= 0.5*pi;
            d1 = angs(:,2) >= 2*pi;
            d2 = angs(:,2) < 2*pi;
        angs(:,1) = (pi - angs(:,1)).*c1 + angs(:,1).*c2;
        angs(:,2) = ((angs(:,2) - 2*pi).*d1+(angs(:,2) + pi).*d2).*c1 + angs(:,2).*c2;
        angs(:,3) = (-angs(:,3)).*c1 + angs(:,3).*c2;        

            c1 = angs(:,2) < 0.0;
            c2 = angs(:,2) >= 0.0;
        angs(:,2) = (angs(:,2) + 2.0*pi).*c1 + angs(:,2).*c2;


%=====================================================================
%          SUBROUTINE V2TRPL(XYZ,TRPL,PI)
function [trpl] = v2trpl(xyz)
% C
% C       Transforms from XYZ components of a unit vector to
% C         the trend and plunge for the vector.
% C       Trend is the azimuth (clockwise from north looking down)
% C       Plunge is the downward dip measured from the horizontal.
% C       All angles in radians
% C       X is north, Y is east, Z is down
% C       If the component of Z is negative (up), the plunge,TRPL(2),
% C         is replaced by its negative and the trend, TRPL(1),
% C         Is changed by PI.
% C       The trend is returned between 0 and 2*PI, the plunge
% C         between 0 and PI/2.
% C-
%          DIMENSION XYZ(3),TRPL(2)
%         do j=1,3
% for j = 1:3
    
xyz = double(xyz);
    c1 = abs(xyz(:,1:3)) > 0.000001;
    xyz(:,1:3) = xyz(:,1:3).*c1;

    c1 = abs(abs(xyz(:,1:3))-1.0) < 0.00001;
    c2 = abs(abs(xyz(:,1:3))-1.0) >= 0.00001;
    xyz(:,1:3) = double(xyz(:,1:3)./abs(xyz(:,1:3))).*c1 + xyz(:,1:3).*c2;

    c1 = abs(xyz(:,3)) == 1.0;
    c2 = abs(xyz(:,3)) ~= 1.0;

    d1 = abs(xyz(:,1)) < 0.0001;
    d2 = abs(xyz(:,1)) >= 0.0001;
    e1 = xyz(:,2) > 0.0;
    e2 = xyz(:,2) < 0.0;
%     e2 = e2 .* (-1).*(e1-1);
%     e3 = e1 + e2 <= 0.0;
    e3 = xyz(:,2) == 0.0;
  
    trpl(:,1) = 0.0.*c1+(((pi/2.).*e1+(3.0*pi/2.0).*e2+0.0.*e3).*d1...
        +(atan2(double(xyz(:,2)),double(xyz(:,1)))).*d2).*c2;

	c = cos(double(trpl(:,1)));
	s = sin(double(trpl(:,1)));
    f1 = abs(c) >= 0.1;
    f2 = abs(c) < 0.1;
    
    trpl(:,2) = 0.5*pi.*c1+((atan2(double(xyz(:,3)),double(xyz(:,1)./c))).*f1...
        +(atan2(double(xyz(:,3)),double(xyz(:,2)./s))).*f2).*c2;
 

    c1 = trpl(:,2) < 0.0;
    c2 = trpl(:,2) >= 0.0;
    trpl(:,2) = (-trpl(:,2)).*c1 + trpl(:,2).*c2;
    trpl(:,1) = (trpl(:,1) - pi).*c1 + trpl(:,1).*c2;
    c1 = trpl(:,1) < 0.0;
    c2 = trpl(:,1) >= 0.0;
    trpl(:,1) = (trpl(:,1) + 2.0*pi).*c1 + trpl(:,1).*c2; 

          
%=====================================================================
    function [momten] = an2mom(a,n)
%          SUBROUTINE AN2MOM(a,N,MOMTEN)
% C
% C       Starting with the a and N axis, calculates the elements
% C         of the moment tensor with unit scalar moment.
% C         Convention used is that of Dziewonski & Woodhouse
% C         (JGR 88, 3247-3271, 1983) and Aki & Richards (p 118)
% C       24 September 1985: If an element is < 0.000001 (ABS), set to  
% zero
% C-
%          REAL*4 a(3), N(3), MOMTEN(6)
% C             Moment tensor components:  M(I,j) = a(I)*N(J)+a(J)*N(I)
         momten(:,1) = 2.0.*a(:,3).*n(:,3);           %!  MRR = M(3,3)
         momten(:,2) = 2.0.*a(:,1).*n(:,1);          %!  MTT = M(1,1)
         momten(:,3) = 2.0.*a(:,2).*n(:,2);          %!  MFF = M(2,2)
         momten(:,4) = a(:,1).*n(:,3)+a(:,3).*n(:,1);    %!  MRT = M(1,3)
         momten(:,5) = -a(:,2).*n(:,3)-a(:,3).*n(:,2);   %!  MRF = -M(2,3)
         momten(:,6) = -a(:,2).*n(:,1)-a(:,1).*n(:,2);   %!  MTF = -M(2,1)
%         for j = 1:6
           c1 = abs(momten(:,1:6)) >= 0.000001;
           momten(:,1:6) = momten(:,1:6).*c1;
%            if abs(momten(j)) < 0.000001
%                momten(:,j) = 0.0;
%            end
%         end

%=====================================================================
% C       SUBROUTINE TRPL2V(TRPL,XYZ)
% C
% C       Transforms to XYZ components of a unit vector from
% C               the trend and plunge for the vector.
% C       Trend is the azimuth (clockwise from north looking down)
% C       Plunge is the downward dip measured from the horizontal.
% C       All angles in radians
% C       X is north, Y is east, Z is down
% C-
%         SUBROUTINE TRPL2V(TRPL,XYZ)
        function [xyz] = trpl2v(trpl)
%         DIMENSION XYZ(3),TRPL(2)
         xyz(:,1) = cos(double(trpl(:,1))).*cos(double(trpl(:,2)));
         xyz(:,2) = sin(double(trpl(:,1))).*cos(double(trpl(:,2)));
         xyz(:,3) = sin(double(trpl(:,2)));

         c1 = abs(xyz(:,1:3)) >= 0.000001;
         xyz(:,1:3) = xyz(:,1:3).*c1;
         c1 = abs(abs(xyz(:,1:3))-1.0) < 0.00001;
         c2 = abs(abs(xyz(:,1:3))-1.0) >= 0.00001;
         xyz(:,1:3) = (xyz(:,1:3)./abs(xyz(:,1:3))).*c1 + xyz(:,1:3).*c2;


%=====================================================================
% 
%          SUBROUTINE PTTPIN (PTTP,ANGS,ANGS2,ANBTP,MOMTEN,PI) C
% C       Calculates other representations of fault planes with
% C               trend and plunge of P and T as input.  All
% C               angles are in radians.
% C       22 July 1985:  Added moment tensor output
% C-
%          REAL N(3),MOMTEN(6)
%          DIMENSION PTTP(4),ANGS(3),ANGS2(3),ANBTP(6),P(3),T(3),a(3),b(3)
%          DATA SR2/0.707107/
function [angs,angs2,anbtp,momten] = pttpin(pttp)
    sr2 = 0.707107;
    [p] = trpl2v([pttp(:,1) pttp(:,2)]);
    [t] = trpl2v([pttp(:,3) pttp(:,4)]);
%          CALL TRPL2V(PTTP(1),P)
%          CALL TRPL2V(PTTP(3),T)
% for j = 1:3
           a(:,1:3) = sr2.*(p(:,1:3) + t(:,1:3));
           n(:,1:3) = sr2.*(t(:,1:3) - p(:,1:3));
%end
         b(:,1) = p(:,2).*t(:,3) - p(:,3).*t(:,2);
         b(:,2) = p(:,3).*t(:,1) - p(:,1).*t(:,3);
         b(:,3) = p(:,1).*t(:,2) - p(:,2).*t(:,1);
         
         [dummy1] = v2trpl(a);
         [dummy2] = v2trpl(n); 
         [dummy3] = v2trpl(b);
         
         anbtp(:,1) = dummy1(:,1);
         anbtp(:,2) = dummy1(:,2);
         anbtp(:,3) = dummy2(:,1);
         anbtp(:,4) = dummy2(:,2);
         anbtp(:,5) = dummy3(:,1);
         anbtp(:,6) = dummy3(:,2);
         
         [angs]     = an2dsr(a,n);
         [angs2]    = an2dsr(n,a);
         [momten]   = an2mom(a,n);
%          CALL V2TRPL(a,ANBTP(1),PI)
%          CALL V2TRPL(N,ANBTP(3),PI)
%          CALL V2TRPL(b,ANBTP(5),PI)
%          CALL AN2DSR(a,N,ANGS,PI)
%          CALL AN2DSR(N,a,ANGS2,PI)
%          CALL AN2MOM(a,N,MOMTEN)

%=====================================================================
function [str1,dip1,rake1,str2,dip2,rake2] = pt2sdr(p,t)

%         subroutine pt2sdr(p,t,str1,dip1,rake1,str2,dip2,rake2)
% c=======================================================================
% c PURPOSE: P,T AXIS --> STRIKE,DIP,RAKE c
% c=======================================================================
% c INPUT ARGUMENTS:
% c       p(1): p-axis azimth
% c       p(2):        plunge
% c       t(1): t-axis azimth
% c       t(2):        pluge
% c=======================================================================
% c OUTPUT ARGUMENTS:
% c       �f�w��
% c       str1:  strike
% c       dip1:  dip
% c       rake1: rake
% c       �⏕��
% c       str2:  strike
% c       dip2:  dip
% c       rake2: rake
% c=======================================================================
% c // SUBROUTINE CALL: pttpin
% c=======================================================================
% c // FUNCTION CALL:
% c=======================================================================
% c       SEP 15, 1994 ORIGINAL VERSION   from H.Tsuru
% c=======================================================================
%          dimension p(2),t(2)
%          dimension pttp(4),angs(3),angs2(3),anbtp(6)
%          real momten(6)
%          integer str1,dip1,rake1,str2,dip2,rake2
%          pi=3.14159
%          rad=pi/180.
         pttp(:,1)=deg2rad(p(:,1));
         pttp(:,2)=deg2rad(p(:,2));
         pttp(:,3)=deg2rad(t(:,1));
         pttp(:,4)=deg2rad(t(:,2));
         
%         call pttpin(pttp,angs,angs2,anbtp,momten,pi);
        [angs,angs2,anbtp,momten] = pttpin(pttp);
         
         str1  = int16(rad2deg(angs(:,2)));
         dip1  = int16(rad2deg(angs(:,1)));
         rake1 = int16(rad2deg(angs(:,3)));
         str2  = int16(rad2deg(angs2(:,2)));
         dip2  = int16(rad2deg(angs2(:,1)));
         rake2 = int16(rad2deg(angs2(:,3)));



