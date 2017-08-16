
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = cDirThis;

% Dependencies
% github/cnanders/mic
addpath(genpath(fullfile(cDirApp, 'vendor', 'github', 'cnanders', 'mic')));
%{
% fileexchange/struct2csv
addpath(genpath(fullfile(cDirApp, 'vendor', 'fileexchange', 'struct2csv')));
%}

% Add sins package (by adding its parent dir)
addpath(genpath(fullfile(cDirApp, 'pkg', 'sins')));

% Add jar
cPathJar = fullfile(...
    cDirApp, ...
    'jar', ...
    'jdk7', ...
    'Sins2Instruments.jar' ...
);
javaaddpath(cPathJar);

% Add EUV dll files to path

cPathMonoLibs = fullfile(...
    cDirApp, ...
    'dll', ...
    'NUS_Mono' ...
);

% Hack to load the DLLs.  CD into the directory, call the load script, then
% CD back out


cd(cPathMonoLibs);
EUV_LV_load_demo2
cd(cDirThis);




%{
% Load EUV_LV DLL
cPathMonoDll = fullfile(...
    cDirApp, ...
    'dll', ...
    'NUS_Mono', ...
    'EUV_LV.dll' ...
)

cPathMonoHeader = fullfile(...
    cDirApp, ...
    'dll', ...
    'NUS_Mono', ...
    'EUV_LV_matlab.h' ...
)


loadlibrary(cPathMonoDll, cPathMonoHeader);
libfunctions('EUV_LV','-full'); %  checking to make sure functions go loaded properly

% test things by calling CheckEnergyOK, should return 0 and 5xx
% use testpro.exe to see what exact 5xx value should eb returned
p=int32(0); % explicitly initi variable out of an abundence of caution
b=int32(0);
[a,b]=calllib('EUV_LV','CheckEnergyOK',p)
%}


purge;

main = sins.main.Main();
main.build();


