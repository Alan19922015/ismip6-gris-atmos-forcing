% Extract DST data

clear

% resolution of output files in km
res = 1;
secpyear = 31556926;

datapath = '/Volumes/ISMIP6/Data/Raw/SMB/MAR3.9';

gcm = 'MIROC5';
scen = 'rcp85';

%gcm = 'NorESM1';
%scen = 'rcp85';

% timer
time = 1950:2005; % needs histo srcscen below
%time = 1995:2005; % needs histo srcscen below


%time = 2006:2014;
%time = 2015:2100;
%time = 2006:2100;
nt = length(time);

% read days for time axis 
caldays = load('../Data/Grid/days_1900-2300.txt');

%%%%%%%
srcscen = 'histo';
scenpath = [ datapath '/' gcm '-' srcscen '_1950_2005'];
file_root = ['MARv3.9-yearly-' gcm '-' srcscen '-'];

%scenpath = [ datapath '/' gcm '-' scen '_2006_2100'];
%file_root = ['MARv3.9-yearly-' gcm '-' scen '-'];

outpath = ['../Data/dST/' gcm '-' scen ];
mkdir(outpath);
mkdir([outpath '/aST' ]);
mkdir([outpath '/dSTdz' ]);

outfile_root_a = [ 'aST_MARv3.9-yearly-' gcm '-' scen ];
outfile_root_d = [ 'dSTdz_MARv3.9-yearly-' gcm '-' scen ];

addpath('../toolbox')

% Load reference ST
d0 = ncload(['../Data/MAR/MARv3.9-yearly-' gcm '-' scen '-ltm1995-2014.nc']);

%% Time loop, scenario from 2015-2100, hist from 1950-2005, present 2006-2014
%for t = 1:5
for t = 1:nt 
    time(t)
    timestamp = caldays(time(t)-1900+1,3)
    time_bounds = [caldays(time(t)-1900+1,2), caldays(time(t)-1900+2,2)]
    %% Load forcing file
    d1 = ncload([scenpath '/' file_root num2str(time(t)) '.nc']);

    %% aST in [K] 
    aST = (d1.ST(1:res:end,1:res:end)-d0.ST(1:res:end,1:res:end));
    %% write out aST
    ancfile = [outpath '/aST/' outfile_root_a  '-' num2str(time(t)) '.nc'];
    ncwrite_GrIS_aST(ancfile, aST, 'aST', {'x','y','t'}, res, timestamp, time_bounds);

    %% dST/dz [K m-1]
    dSTdz = (d1.dST(1:res:end,1:res:end));
    %% write out dSTdz
    ancfile = [outpath '/dSTdz/' outfile_root_d  '-' num2str(time(t)) '.nc'];
    ncwrite_GrIS_dSTdz(ancfile, dSTdz, 'dSTdz', {'x','y','t'}, res, timestamp, time_bounds);
    
end
%% end time loop

