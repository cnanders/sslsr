%function data=read_cxro_xrr_csv(filename,[fields])
%  INPUT
%   filename = full path name of the csv file to be read
%
%  OUTPUT
%     data = structure containing the data, field names are:
%           'wav','grating','maskX','maskY','maskZ','maskT','detX','detT','filterY','iZero','iDet','date','time'
%         also includes 'filename' field holding the source scan filename

function data=read_cxro_xrr_csv(filename)

if nargin<1
    error('Must pass a filename');
end;

[data.wav,data.grating,data.maskX,data.maskY,data.maskZ,data.maskT,data.detX,data.detT,data.filterY,data.iZero,data.iDet,data.date,data.time]=textread(filename,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%s %s','headerlines',1);
data.filenane=filename;