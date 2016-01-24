function [Y,X]=readIOM(filename)
%**********************************************************
% written by Oleg Mytnyk, (c) 2009
% last revision: 23.03.2009
% Read IOM file format
% input:  filename - input data file,
% output: Y, X     - input and output matrices for input-output model
%**********************************************************
fid = fopen(filename, 'r');
% read first line with information about sizes
inputsize = fscanf(fid, '%g %g', [2 1]);
N = inputsize(1);
n = inputsize(2);
% read input
input = fscanf(fid, '%g %g', [n N]);
% read output sizes
outputsize = fscanf(fid, '%g %g', [2 1]);
if (N ~= outputsize(1)) || ( 1 ~= outputsize(2))
    error('Invalid input file');
end
% read output
output = fscanf(fid, '%g %g', [1 N]);
fclose(fid);

Y = output';
X = input';