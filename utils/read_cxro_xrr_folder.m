%function data=read_cxro_xrr_folder(foldername)
%  INPUT
%   foldername = full path name for the folder containing target scan folders
%
%  OUTPUT
%     data = structure array containing the data, field names are:
%           'wav','grating','maskX','maskY','maskZ','maskT','detX','detT','filterY','iZero','iDet','date','time'
%         each element of the array contains the data from one scan folder
%         also includes 'filename' field holding the source scan filename

function data=read_cxro_xrr_folder(foldername)

if nargin<1
    error('Must pass a folder pathname');
end;

f=dir([foldername,'\scan*']);
tmp=pwd;
cd(foldername);

for i=1:length(f)
    cd(f(i).name);
    fn=dir('*.csv');
    [data(i).wav,data(i).grating,data(i).maskX,data(i).maskY,data(i).maskZ,data(i).maskT,data(i).detX,data(i).detT,data(i).filterY,data(i).iZero,data(i).iDet,data(i).date,data(i).time]=textread(fn.name,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%s %s','headerlines',1);
    data(i).filename=fn.name;
    cd ..
end;

cd(tmp);