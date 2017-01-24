[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = cDirThis;

% Add EUV dll files to path
cPathMonoLibs = fullfile(...
    cDirApp, ...
    'dll', ...
    'NUS_Mono' ...
);
addpath(genpath(cPathMonoLibs));

% Load EUV_LV DLL
cPathMonoDll = fullfile(...
    cPathMonoLibs, ...
    'EUV_LV.dll' ...
);

cPathMonoHeader = fullfile(...
    cPathMonoLibs, ...
    'EUV_LV_matlab.h' ...
);

return

loadlibrary(cPathMonoDll, cPathMonoHeader);
libfunctions('EUV_LV','-full'); %  checking to make sure functions go loaded properly

% test things by calling CheckEnergyOK, should return 0 and 5xx
% use testpro.exe to see what exact 5xx value should eb returned
p=int32(0); % explicitly initi variable out of an abundence of caution
b=int32(0);
[a,b]=calllib('EUV_LV','CheckEnergyOK',p)




