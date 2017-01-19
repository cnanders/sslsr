
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = cDirThis;

% Add tests
addpath(genpath(fullfile(cDirApp, 'tests')));

% Add mic
addpath(genpath(fullfile(cDirApp, 'lib', 'mic')));

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

purge;

main = sins.main.Main();
main.build();


