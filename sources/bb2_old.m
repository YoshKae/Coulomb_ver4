function [hg] = bb2(fm, centerX, centerY, diam, ta, iFlag, color)
% bb2 は、地震のダブルカップル焦点メカニズムに基づいてビーチボール図を描画する関数です。

% 入力:
%   fm      - 地震の焦点メカニズムを表す行列。行列は (NM x 3) または (NM x 6) の形で、各行はそれぞれのメカニズムの
%             ストライク、ディップ、レイクまたはモーメントテンソルの6成分（mxx, myy, mzz, mxy, mxz, myz）を示します。
%   centerX - ビーチボールの中心のX座標（または経度）
%   centerY - ビーチボールの中心のY座標（または緯度）
%   diam    - ビーチボールの直径。diamがゼロの場合、ビーチボールはステレオネット上に描画されます。
%   ta      - 軸のタイプを指定します。taが0なら通常の軸、1なら地図軸です。
%   iFlag   - ノーダルプレーンの描画フラグ。0なら通常のビーチボール、1ならビーチボールに赤い弧が描画されます。
%   color   - 張力四分円に使用する色を指定します。文字列 ('r', 'b' など) または RGBカラーのベクトル [R G B] です。

% 出力:
%   hg      - 描画されたオブジェクトのハンドル。

% ペンのサイズを設定
penw = 0.1;
penc = 1.1; % 一つのノーダルプレーンをコールーム計算用に描画する設定

% ビーチボールの縦横比を調整
adj = 1.35;
% 描画されたオブジェクトのハンドルグループを初期化
hg = hggroup;

% fmのサイズを取得
[ne,n] = size(fm);
% fmが6成分のモーメントテンソルの場合、対応するストライク、ディップ、レイクを計算
if n == 6
	for j = 1:ne
		[s1(j),d1(j),r1(j)] = mij2sdr(fm(j,1),fm(j,2),fm(j,3),fm(j,4),fm(j,5),fm(j,6));
	end
% fmがストライク、ディップ、レイクの場合、そのまま使用
else
	s1 = fm(:,1);
	d1 = fm(:,2);
	r1 = fm(:,3);
end

% 角度の変換係数
r2d = 180/pi;
d2r = pi/180;
ampy = cos(mean(centerY)*d2r)*adj;
ampy = 1;

% 機構の初期化
mech = zeros(ne,1);
j = find(r1 > 180);
r1(j) = r1(j) - 180;
mech(j) = 1;
j = find(r1 < 0);
r1(j) = r1(j) + 180;
mech(j) = 1;

% 第2プレーンのストライクとディップを取得
[s2,d2,r2] = AuxPlane(s1,d1,r1);

% 直径が正の場合、保持しながら描画
if diam(1) > 0
	hold on
end

% 各イベントについてビーチボールを描画
for ev = 1:ne
	S1 = s1(ev);
	D1 = d1(ev);
	S2 = s2(ev);
	D2 = d2(ev);
	P = r1(ev);
	CX = centerX(ev);
	CY = centerY(ev);
	D = diam(ev);
	M = mech(ev);

if M > 0
   P = 2;
else
   P = 1;
end

% ディップ角が90度を超えないように調整
if D1 >= 90
   D1 = 89.9999;
end
if D2 >= 90
   D2 = 89.9999;
end

% 角度phiの設定
phi = 0:.05:pi;

% 第1プレーンの半径の計算
d = 90 - D1;
m = 90;
l1 = sqrt(d^2./(sin(phi).^2 + cos(phi).^2 * d^2/m^2));

% 第2プレーンの半径の計算
d = 90 - D2;
m = 90;
l2 = sqrt(d^2./(sin(phi).^2 + cos(phi).^2 * d^2/m^2));

% ステレオネットに描画
if D == 0
   stereo(phi+S1*d2r,l1,'k')
   hold on
   stereo(phi+S2*d2r,l2,'k')
end

% プロットのための座標変換
inc = 1;
[X1,Y1] = pol2cart(phi+S1*d2r,l1);
if P == 1
   lo = S1 - 180;
   hi = S2;
   if lo > hi
      inc = -inc;
   end
   th1 = S1-180:inc:S2;
   [Xs1,Ys1] = pol2cart(th1*d2r,90*ones(1,length(th1)));
   [X2,Y2] = pol2cart(phi+S2*d2r,l2);
   th2 = S2+180:-inc:S1;
else
   hi = S1 - 180;
   lo = S2 - 180;
   if lo > hi
      inc = -inc;
   end
   th1 = hi:-inc:lo;
   [Xs1,Ys1] = pol2cart(th1*d2r,90*ones(1,length(th1)));
   [X2,Y2] = pol2cart(phi+S2*d2r,l2);
   X2 = fliplr(X2);
   Y2 = fliplr(Y2);
   th2 = S2:inc:S1;
end
[Xs2,Ys2] = pol2cart(th2*d2r,90*ones(1,length(th2)));

X = cat(2,X1,Xs1,X2,Xs2);
Y = cat(2,Y1,Ys1,Y2,Ys2);
%---
% Xc1 = X1;
% Yc1 = Y1;
% Xc1 = cat(2,X1,Xs1);
% Yc1 = cat(2,Y1,Ys1);
%---

% ビーチボールの描画
if D > 0
   X = ampy*X * D/90 + CY;
   Y = Y * D/90 + CX;
   Xc1 = ampy*X1 * D/90 + CY;
   Yc1 = Y1 * D/90 + CX;
   phid = 0:.01:2*pi;
   [x,y] = pol2cart(phid,90);
   xx = x*D/90 + CX;
   yy = ampy*y*D/90 + CY;

   if ta == 0
      h1 = fill(xx,yy,'w');
      try
      h2 = fill(Y,X,color(ev,:));
      catch
      h2 = fill(Y,X,color); % when simple color (e.g., 'r')
      end
                 set(h1,'Parent',hg);
                 set(h2,'Parent',hg);
      if iFlag == 1
        hold on; h3 = plot(Yc1,Xc1,'m','linewidth',penc);
                 set(h3,'Parent',hg);
      end
                 h4 = line(xx,yy,'color','k','linewidth',penw);
                 set(h4,'Parent',hg);
   else
      fillm(yy,xx,'w')
      fillm(X,Y,color)
      if iFlag == 1
        hold on; plot(Yc1,Xc1,'r','linewidth',penc)
      end
      linem(yy,xx,'color','k','linewidth',penw);
   end
else
   if ta == 0
      fill(X,Y,color(ev,:))
   else
      fillm(Y,X,color)
   end
   view(90,-90)
end
%     set(hg,'Visible','off');
end

%---------------------------------------------
% 第2プレーンのストライク、ディップ、レイクを計算する補助関数
%---------------------------------------------
function [strike, dip, rake] = AuxPlane(s1,d1,r1)
r2d = 180/pi;

z = (s1+90)/r2d;
z2 = d1/r2d;
z3 = r1/r2d;
% 第1プレーンのスリックベクトル
sl1 = -cos(z3).*cos(z)-sin(z3).*sin(z).*cos(z2);
sl2 = cos(z3).*sin(z)-sin(z3).*cos(z).*cos(z2);
sl3 = sin(z3).*sin(z2);
[strike, dip] = strikedip(sl2,sl1,sl3);

n1 = sin(z).*sin(z2);  % 第1プレーンの法線ベクトル
n2 = cos(z).*sin(z2);
n3 = cos(z2);
h1 = -sl2; % 第2プレーンの走向ベクトル
h2 = sl1;

z = h1.*n1 + h2.*n2;
z = z./sqrt(h1.*h1 + h2.*h2);
z = acos(z);

rake = zeros(size(strike));
j = find(sl3 > 0);
rake(j) = z(j)*r2d;
j = find(sl3 <= 0);
rake(j) = -z(j)*r2d;

%---------------------------------------------
% 法線ベクトルからストライクとディップを計算する関数
%---------------------------------------------
function [strike, dip] = strikedip(n, e, u)
%　関数 [strike, dip] = strikedip(n, e, u)
%  成分 n, e, u を持つ法線ベクトルが与えられたとき、平面の走向・傾斜を求める。

r2d = 180/pi;

j = find(u < 0);
n(j) = -n(j);
e(j) = -e(j);
u(j) = -u(j);

strike = atan2(e,n)*r2d;
strike = strike - 90;
while strike >= 360
        strike = strike - 360;
end
while strike < 0
        strike = strike + 360;
end

x = sqrt(n.^2 + e.^2);
dip = atan2(x,u)*r2d;

%---------------------------------------------
% ステレオネットに描画する関数
%---------------------------------------------
function hpol = stereo(theta,rho,line_style)

if nargin < 1
    error('Requires 2 or 3 input arguments.')
elseif nargin == 2 
    if isstr(rho)
        line_style = rho;
        rho = theta;
        [mr,nr] = size(rho);
        if mr == 1
            theta = 1:nr;
        else
            th = (1:mr)';
            theta = th(:,ones(1,nr));
        end
    else
        line_style = 'auto';
    end
elseif nargin == 1
    line_style = 'auto';
    rho = theta;
    [mr,nr] = size(rho);
    if mr == 1
        theta = 1:nr;
    else
        th = (1:mr)';
        theta = th(:,ones(1,nr));
    end
end
if isstr(theta) | isstr(rho)
    error('Input arguments must be numeric.');
end
if ~isequal(size(theta),size(rho))
    error('THETA and RHO must be the same size.');
end

% プロットの状態を取得
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% x軸のテキストカラーを取得し、グリッドが同じ色になるように設定
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% デフォルトのテキスト設定を保持し、軸のフォント属性にリセット
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% グリッドの描画
if ~hold_state
    hold on;
    maxrho = max(abs(rho(:)));
    hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
    set(gca,'daspectratio',[1 1 1],'pbaspectratiomode',[1 1 1])  
    set(gca,'xlim',[-90 90])
    set(gca,'ylim',[-90 90])
    v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);
    rmin = 0; rmax = v(4); rticks = max(ticks-1,2);
	rticks = 1;

    % 円の定義
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
    % x軸とy軸の点が正確に一致するようにする。　
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
    % 背景の描画
    if ~isstr(get(cax,'color')),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end

    % 放射円の描画
    c82 = cos(82*pi/180);
    s82 = sin(82*pi/180);
    rinc = (rmax-rmin)/rticks;
    for i=(rmin+rinc):rinc:rmax
        hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',1,...
                   'handlevisibility','off');
    end
    % 外側の円を実線にする
    set(hhh,'linestyle','-')

    % 放射状のスポークを描画
    th = (1:6)*2*pi/12;
    cst = cos(th); snt = sin(th);

    % 放射状のスポークを描画
    rt = 1.1*rmax;
    for i = 1:length(th)
        text(rt*cst(i),rt*snt(i),int2str(i*30),...
             'horizontalalignment','center',...
             'handlevisibility','off');
        if i == length(th)
            loc = int2str(0);
        else
            loc = int2str(180+i*30);
        end
        text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center',...
             'handlevisibility','off')
    end

    % 2Dのビューに設定
    view(2);
    % 軸のリミットを設定
	axis(rmax*[-1 1 -1.15 1.15]);
end

% デフォルト設定をリセット
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );

% データをデカルト座標に変換
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% グリッド上にデータをプロット
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hpol = q;
end
if ~hold_state
    set(gca,'daspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')

%---------------------------------------------
% モーメントテンソルからストライク、ディップ、レイクを計算する関数
%---------------------------------------------
function [str,dip,rake] = mij2sdr(mxx,myy,mzz,mxy,mxz,myz)
% 関数 [str,dip,rake] = mij2sdr(mxx,myy,mzz,mxy,mxz,myz)

% INPUT
%    mij - モーメントテンソルのサイズ独立成分

% OUTPUT
%    str - 最初の焦点面の走向（度）
%    dip - 第1焦点面の傾き（度）
%    rake - 第1焦点面のすくい角（度）

a = [mxx mxy mxz; mxy myy myz; mxz myz mzz];
[V,d] = eig(a);

D = [d(3,3) d(1,1) d(2,2)];
V(2:3,1:3) = -V(2:3,1:3);
V = [V(2,3) V(2,1) V(2,2); V(3,3) V(3,1) V(3,2); V(1,3) V(1,1) V(1,2)];

IMAX = find(D == max(D));
IMIN = find(D == min(D));
AE = (V(:,IMAX)+V(:,IMIN))/sqrt(2.0);
AN = (V(:,IMAX)-V(:,IMIN))/sqrt(2.0);
AER = sqrt(AE(1)^2+AE(2)^2+AE(3)^2);
ANR = sqrt(AN(1)^2+AN(2)^2+AN(3)^2);
AE = AE/AER;
AN = AN/ANR;
if (AN(3) <= 0.)
	AN1 = AN;
	AE1 = AE;
else
	AN1 = -AN;
	AE1 = -AE;
end 
[ft,fd,fl] = TDL(AN1,AE1);
str = 360 - ft;
dip = fd;
rake = 180 - fl;

%---------------------------------------------
% 法線ベクトルを使ってストライク、ディップ、レイクを計算する補助関数
%---------------------------------------------
function [FT,FD,FL] = TDL(AN,BN)
XN=AN(1);
YN=AN(2);
ZN=AN(3);
XE=BN(1);
YE=BN(2);
ZE=BN(3);
AAA=1.0E-06;
CON=57.2957795;
if (abs(ZN) < AAA)
	FD=90.;
	AXN=abs(XN);
	if (AXN > 1.0) 
		AXN=1.0;
	end
	FT=asin(AXN)*CON;
	ST=-XN;
	CT=YN;
	if (ST >= 0. & CT < 0) 
		FT=180.-FT;
	end
	if (ST < 0. & CT <= 0) 
		FT=180.+FT;
	end
	if (ST < 0. & CT > 0) 
		FT=360.-FT;
	end
	FL=asin(abs(ZE))*CON;
	SL=-ZE;
	if (abs(XN) < AAA) THEN
		CL=XE/YN;
	else
		CL=-YE/XN;
	end 
	if (SL >= 0. & CL < 0) 
		FL=180.-FL;
	end
	if (SL < 0. & CL <= 0) 
		FL=FL-180.;
	end
	if (SL < 0. & CL > 0) 
		FL=-FL;
	end
else
	if (-ZN > 1.0) 
		ZN=-1.0;
	end
	FDH=acos(-ZN);
	FD=FDH*CON;
	SD=sin(FDH);
	if  (SD == 0)
		return;
	end 
	ST=-XN/SD;
	CT=YN/SD;
	SX=abs(ST);
	if (SX > 1.0) 
		SX=1.0;
	end
	FT=asin(SX)*CON;
	if (ST >= 0. & CT < 0) 
		FT=180.-FT;
	end
	if (ST < 0. & CT <= 0) 
		FT=180.+FT;
	end
	if (ST < 0. & CT > 0) 
		FT=360.-FT;
	end
	SL=-ZE/SD;
	SX=abs(SL);
	if (SX > 1.0) 
		SX=1.0;
	end
	FL=asin(SX)*CON;
	if (ST == 0) THEN
		CL=XE/CT;
	else
		XXX=YN*ZN*ZE/SD/SD+YE;
		CL=-SD*XXX/XN;
		if (CT == 0) 
			CL=YE/ST;
		end
	end 
	if (SL >= 0. & CL < 0) 
		FL=180.-FL;
	end
	if (SL < 0. & CL <= 0) 
		FL=FL-180.;
	end
	if (SL < 0. & CL > 0) 
		FL=-FL;
	end
end
