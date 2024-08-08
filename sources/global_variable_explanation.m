%----------------------------------------------------------------------
%
%       Descriptions for GLOBAL VARIABLES
%
%----------------------------------------------------------------------

H_ELEMENT
TAPER_CALLED

ANATOLIA

AX
AY
AZ
% x y & z positions in a mapped coordinate along the cross section line.
% Their sizes are (ndepth x nsec). repmat function is used to copy vector
% (1,:) information to matrix. AZ is depth info matrix on a given cross
% section.
% (in "coulomb_section.m")
% % y = (-1.0) * double(y - 1.0) * sec_depthinc;
% % xx = sec_xs + (sec_xf-sec_xs)/double(nsec-1) * double(xt-1);
% % yy = sec_ys + (sec_yf-sec_ys)/double(nsec-1) * double(xt-1);
% % AX = repmat(xx,abs(ndepth),1);   % repmat(M, v, h) copy function of Matrix
% % AY = repmat(yy,abs(ndepth),1);
% % AZ = repmat(reshape(y,abs(ndepth),1),1,nsec);

CALCDEPTH
% Calculation depth for deformation <scalar>

CURRENT_VERSION
% current version of Coulomb. This is also used to check if the new version
% si available or not.

C_SAT
% a value saturate color codes (should be always positive)

DC3D
% Essential calculation results from Okada's half space codes. All results
% are summarized into this DC3D. The structure is
%       (N_CELL x 14)
% The column elements are,
%       XYCOORD,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY
%                                                (see, "Okada_halfspace.m")
%       DC3D(:,1:2) : XYCOORD (x, y position in a study area)
%       DC3D(:,3)   : X       (x position for a certain fault coordinate
%                              changed by each fault element)
%       DC3D(:,4)   : Y       (y position for a certain fault coordinate
%                              changed by each fault element)
%       DC3D(:,5)   : Z       (z position for a certain fault coordinate
%                              changed by each fault element)
%       DC3D(:,6)   : UXG     (Displacement along x-axis)
%       DC3D(:,7)   : UYG     (Displacement along y-axis)
%       DC3D(:,8)   : UZG     (Displacement along z-axis)
%       DC3D(:,9)   : SXX     (Principal strain along x-axis, sxx)
%       DC3D(:,10)   : SYY     (Principal strain along y-axis, syy)
%       DC3D(:,11)  : SZZ     (Principal strain along z-axis, szz)
%       DC3D(:,12)  : SYZ     (Shear strain on yz surface, syz)
%       DC3D(:,13)  : SYZ     (Shear strain on xz surface, sxz)
%       DC3D(:,14)  : SYZ     (Shear strain on xy surface, sxy)

DC3DS
% Same as DC3D but prepared for cross sectio calculation. This matrix is
% necessary to keep DC3D separately to avoid overwriting a new result on
% the DC3D
%       (N_CELL x 14)

DC3DE

DIP

ELEMENT
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

EQ_DATA

FCOMMENT

FRIC
% Coefficient of friction for Coulomb stress calculation
% It should be apparent friction exactly.

FUNC_SWITCH
%    1: Grid drawing
%    2: Horizontal displacement
%    3: Wireframe
%    4: Vertical displacement
%    5: 3D draped plot
%  5.5: 3D wireframed surface plot
%  5.7: 3D vector plot
%    6: Strain calc
%    7: Shear stress change
%    8: Normal stress change
%    9: Coulomb stress change
%   10: Stress on faults (former EC function)

GRID
% Areal information of study area
%       GRID(1,1) xstart (km)
%       GRID(2,1) ystart (km)
%       GRID(3,1) xfinish (km)
%       GRID(4,1) yfinish (km)
%       GRID(5,1) x increment (grid spacing) (km)
%       GRID(6,1) y increment (grid spacing) (km)

HEAD <2x1 cell>
% Two-line header text information in input file

%-------------------------------------------------------------------------
%   Figure (window), axis,  handles
%-------------------------------------------------------------------------
H_INPUT

H_GRID
% handle for grid draing on the main menu window
H_MAIN
% handle for main menu window ('Tag','main_manu_window')
H_SECTION
% handle for cross section window ('Tag','section_view_window')
H_DISPL
% handle for displacement control window ('Tag','displ_h_window')
H_COULOMB
% handle for coulomb stress control window ('Tag','coulomb_window')
H_SEC_WINDOW
% handle for cross section control window ('Tag','xsec_window')
H_STRAIN
% handle for strain control window ('Tag','strain_window')
H_GRID_INPUT
% handle for grid input control window ('Tag','grid_input_window')
H_STUDY_AREA
% handle for study area control window ('Tag','study_area')
H_ELEMENT
% handle for element input control window ('Tag','element_input_window')
H_UTM
% handle for UTM control window ('Tag','utm_window')
H_VERTICAL_DISPL
% handle for vertical control window ('Tag','vertical_displ_window')

HO
% object handle for a cross section line on a map view
HT1
% object handle for a label "A" along a cross section line on a map view
HT2
% object handle for a label "B" along a cross section line on a map view
%-------------------------------------------------------------------------

HOME_DIR
% home directory routinely get from start-up using "pwd" function

IACT
% Flag to avoid the unnecessary recalcution of Okada's half space code
%
% IACT = 1 : skip recalc. use the current DC3D information to save time.
% IACT = others: do recalculation since at least one parameter is modified.

IACTS
% Flag to avoid the unnecessary recalcution of Okada's half space code
% for cross section
%
% IACT = 1 : skip recalc. use the current DC3D information to save time.
% IACT = others: do recalculation since at least one parameter is modified.

ICOORD
% Flag to identify the map coordinates.
% 1: Cartesian coordinates
% 2: map coordinate (lon. & lat.)

ID
% ID number of each fault element <scalar>
%       This is tight to ELEMENT
%		number of elements

KODE
% KODE number which distinguishes types of calculations. <scalar>
%       Normally 100. 
%        ####(7th column)        ####(8th column)
% 100:  right-lateral slip (m)   reverse slip (m)
% 100:  rake (degree)            net slip (m)     if label above contains word "rake".
% 200:  tensile opening          right-lateral slip (m)
% 300:  tensile opening          reverse slip (m)
% 400:  point source right-lat   point source reverse
% 500:  tensile opening          point source inflation
% (NEED TO MAKE SURE...)

MIN_LAT
% minimum latitude (degree)
MAX_LAT
% maximum latitude (degree)
ZERO_LAT
% latitude of the reference point set to zero (degree)
MIN_LON
% minimum longitude (degree)
MAX_LON
% maximum longitude (degree)
ZERO_LON
% longitude of the reference point set to zero (degree)

N_CELL
% Number of total node points (cell numbers) <scalar>
% Number of x nodes x number of y nodes.
%       N_CELL = NXINC x NYINC

NORMAL
% Normal stress change (1,:)

NUM
% Number of fault elements <scalar>

NXINC
NYINC
% Numbers of x nodes & y nodes on a give graphic <scalar>
% These are depending on whether it is map view or cross section
%   e.g.,
% % if SEC_FLAG == 1        % cross section
% %     NXINC = nsec;
% %     NYINC = abs(ndepth);
% % else
% %     NXINC = int16((xfinish-xstart)/xinc);
% %     NYINC = int16((yfinish-ystart)/yinc);
% % end

OVERLAYFLG
% Flag to identify which information (coastline, eq, etc...) should be
% overlaid on top of the current graphic object. This parameter is mainly
% used in "study_area.m"
%       OVERLAYFLAG == 1 : earthquake_plot;
%       OVERLAYFLAG == 2 : coastline_drawing;
%       (others, not yet determined...)

OUTFLAG

PLATFORM
% user's environment
% get the value from built-in fuction "computer"
%   < MAC	MACI PCWIN GLNX86 >

POIS
% Poisson ratio <scalar>

PREF
% Preference for line color and line width (6x4 single)
%       PREF(1,1:3) fault color RGB   PREF(1,4) fault line width
%       PREF(2,1:3) disp. vector RGM  PREF(2,4) disp. vector width
%       PREF(3,1:3) grid line RGB     PREF(3,4) grid line width
%       PREF(4,1:3) coastline RGB     PREF(4,4) coastline width
%       PREF(5,1:3) earthquake RGB    PREF(5,4) earthquake size
%       PREF(6,1:3) active fault RGB  PREF(6,4) active fault width

PREF_DIR
% directory preference file exists

RAKE

R_STRESS
% Regional stress field (3x4 single)
%       R_STRESS(1,1): orientation of sigma-1 (degree)
%       R_STRESS(1,2): plunge of sigma-1 (degree)
%       R_STRESS(1,3): magnitude at the surface (bar)
%       R_STRESS(1,4): depth gradient (S0 + gradient * depth (km))
%       R_STRESS(2,1): orientation of sigma-2 (degree)
%       R_STRESS(2,2): plunge of sigma-2 (degree)
%       R_STRESS(2,3): magnitude at the surface (bar)
%       R_STRESS(2,4): depth gradient (S0 + gradient * depth (km))
%       R_STRESS(3,1): orientation of sigma-3 (degree)
%       R_STRESS(3,2): plunge of sigma-3 (degree)
%       R_STRESS(3,3): magnitude at the surface (bar)
%       R_STRESS(3,4): depth gradient (S0 + gradient * depth (km))

SCRS
% Screen size for the current computer (1x4)
%       [1 1 max_horizontal_res_width max_vertical_res_height]
%       [left bottom width height]
SCRW_X
% Width of x axis margin to place a window
SCRW_Y
% Width of y axis margin to place a window
% margin_ratio = 0.03;
% SCRW_X = int16(SCRS(1,3) * margin_ratio);   % margin width
% SCRW_Y = int16(SCRS(1,4) * margin_ratio);   % margin height

SECTION

SEC_FLAG
% Flag to indentify dislocation calculation should be mapview or cross
% section. This flag is particularly useful in "Okada_halfspace.m" or
% similar functions. This flag is necessary to keep the mapview calc result
% in Computer memory without recalculating that.
%       SEC_FLAG = 0 : map view calc.
%       SEC_FLAG = 1 : cross section calc.

SEIS_RATE

SHADE_TYPE
% Type of paint for Coulomb stress change <scalar> (color mapping)
%       SHADE_TYPE = else : colormap(jet)
%       SHADE_TYPE = 2    : my color like "Anatoria color scale"

SHEAR
% Shear stress change (1,:)

SIZE
% Graphic size control parameters taken from Mac version of Coulomb
% (3x1)
%       SIZE(1,1) plot size (multiplier)
%       SIZE(2,1) color saturation parameter
%       SIZE(3,1) exaggeration for displacement vectors

STRAIN_SWITCH


STRESS_TYPE
% Number to identify the type of Coulomb stress calculations <scalar>
%       1: optimally oriented faults
%       2: optimally oriented strike-slip faults
%       3: optimally oriented thrust faults
%       4: optimally oriented normal faults
%       5: specified faults

STRIKE

S_ELEMENT

YOUNG
% Young modulus (e.g.,800000 bar) <scalar>

XYCOORD
% x, y position information in a given map view (study area coordinate) for
% all deformation & stress calcs. They are directly used in the Okada's
% halfspace codes.
% (n x 2); n is number of all cell nodes (= N_CELL)
% (:, 1) : x elements
% (:, 2) : y elements
% For mapview calculation, each element is reserved as x, y position in a
% give mapview coordinate. For cross section, x, y positions along a cross
% section line selected by user are calculated as AX, AY. And then, they
% are put in XYCOORD.
% The sequence in the first column is like x1, x1, x1, x1, x2, x2, x2,...
% & y1, y2, y3, y4, y1, y2, y3, y4...
% e.g., (in Okada_halfspace.m)
% %     xx = xstart + double(k-1) * xinc;
% %     for m = 1:NYINC
% %         yy = ystart + double(m-1) * yinc;
% %         nn = m + (k - 1) * NYINC;
% %         if SEC_FLAG == 1
% %             XYCOORD(nn,1) = aax(nn,1);
% %             XYCOORD(nn,2) = aay(nn,1);
% %         else
% %             XYCOORD(nn,1) = xx;
% %             XYCOORD(nn,2) = yy;
% %         end
% %         ncount = ncount + 1;
% %     end

XGRID
YGRID
% vectors show x, y positions of the nodes in the cartesian coordinates.
% length(XGRID) & length(YGRID) withdraw numbers of node points

XY_RATIO


