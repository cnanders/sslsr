
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = fullfile(cDirThis, '..', '..', '..', '..');

% Add mic
addpath(genpath(fullfile(cDirApp, 'lib', 'mic')));

% Add sins package (by adding its parent dir)
addpath(genpath(fullfile(cDirApp, 'pkg', 'sins')));

% Add jar
cPathJar = fullfile(...
    cDirApp, ...
    'jar', ...
    'jdk7', ...
    'test', ...
    'Sins2Instruments.jar' ...
);
javaaddpath(cPathJar);

purge;

test = sins.sins.SinsTest();
test.build();





