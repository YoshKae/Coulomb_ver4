function coulomb_init
%   This function initializes some of the global variable when Coulomb is
%   launched. It also put some initial default values to several variables.

global HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global FCOMMENT GRID SIZE SECTION
global FIXX FIXY FIXFLAG
global SHADE_TYPE STRESS_TYPE
global SEC_FLAG
global S_ELEMENT
global DEPTH_RANGE_TYPE
global LON_GRID LAT_GRID
global FLAG_PR_AXES
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global GPS_FLAG GPS_SEQN_FLAG
global IIRET IRAKE
global VIEW_AZ VIEW_EL
global OVERLAY_MARGIN
global IND_RAKE
global IMAXSHEAR

% to detect a singular point (if IIRET > 0, singular)
IIRET = 0;
% to clarify input file format
IRAKE = 0;

% initialization for input parameters from an input file
HEAD       = [];
NUM        = [];
POIS       = [];
CALC_DEPTH = [];
YOUNG      = [];
FRIC       = [];
R_STRESS   = [];
ID         = [];
KODE       = [];
ELEMENT    = [];
IND_RAKE   = [];
FCOMMENT   = struct('ref',[]);
GRID       = [];
SIZE       = [];
SECTION    = [];
S_ELEMENT  = [];
% flag for horizontal displ calc (0: no fixed point, 1: a fixed)
FIXFLAG    = repmat(uint8(0),1,1);
% default fixed point
FIXX       = 0;
FIXY       = 0;

STRESS_TYPE = repmat(uint8(5),1,1);
SHADE_TYPE  = repmat(uint8(1),1,1);
SEC_FLAG    = repmat(uint8(0),1,1);
LON_GRID    = [];
LAT_GRID    = [];

% flag to speed up EC calc to skip the max. shear calc routine
IMAXSHEAR = 2; % 1: search, 2: skip

% initialization for overlay functions
COAST_DATA  = [];
AFAULT_DATA = [];
EQ_DATA     = [];
GPS_DATA    = [];
GPS_FLAG      = 'horizontal';
GPS_SEQN_FLAG = 'off';

% 3D viewpoint specification (azimuth and vertical elevation, degree)
VIEW_AZ = 15;
VIEW_EL = 40;

% overlay function check item off
set(findobj('Tag','menu_gridlines'),'Checked','off');
set(findobj('Tag','menu_coastlines'),'Checked','off');
set(findobj('Tag','menu_activefaults'),'Checked','off');
set(findobj('Tag','menu_earthquakes'),'Checked','off');

DEPTH_RANGE_TYPE = repmat(uint8(0),1,1);
FLAG_PR_AXES = repmat(uint8(0),1,1);
OVERLAY_MARGIN = 5;
