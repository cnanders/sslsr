
[cDir, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = fullfile(cDir, '..', '..', '..');

% Add mic
addpath(genpath(fullfile(cDirApp, 'lib', 'mic')));

% Add sins package (by adding its parent dir)
addpath(genpath(fullfile(cDirApp, 'pkg-sins')));

purge

clock = Clock('master');       
sins = sins.sins.SinsVirtual(...
    'cName', 'test', ...
    'clock', clock ...
);



