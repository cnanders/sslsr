
[cDir, cName, cExt] = fileparts(mfilename('fullpath'));

% App root
cDirApp = fullfile(cDir, '..', '..', '..');

% Add mic
addpath(genpath(fullfile(cDirApp, 'lib', 'mic')));

% Add sins package (by adding its parent dir)
addpath(genpath(fullfile(cDirApp, 'pkg-sins')));

purge

clock = Clock('master');       
axis = sins.axis.AxisVirtual(...
    'cName', 'test', ...
    'clock', clock ...
);

f = axis.moveAbsolute(200);
f.isDone()
f.isDone()
f.get()


