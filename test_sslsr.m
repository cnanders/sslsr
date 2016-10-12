

[cPath, cName, cExt] = fileparts(mfilename('fullpath'));

% Add mic
addpath(genpath(fullfile(cPath, '..', 'lib', 'mic')));

purge;

sslsr = Sslsr();
sslsr.build();


