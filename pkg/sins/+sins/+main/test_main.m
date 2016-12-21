
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = fullfile(cDirThis, '..', '..', '..');

% Add mic
addpath(genpath(fullfile(cDirApp, 'lib', 'mic')));

% Add sins package (by adding its parent dir)
addpath(genpath(fullfile(cDirApp, 'pkg', 'sins')));

purge;

main = sins.main.Main();
main.build();


