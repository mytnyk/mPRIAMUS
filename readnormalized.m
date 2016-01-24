function [X,minX,maxX,Y,minY,maxY]=readnormalized(inData)
%**************************************************
% written by Oleg Mytnyk, 2006
% last revision: 28.01.2006
% read and normalize data
% output: Y - observed output,  X - input variabes
%**************************************************

[Y, X] = readIOM(inData);

[n, p]=size(X);
% data normalization:
minX=min(X);
maxX=max(X);
diffX=maxX-minX;
minY=min(Y);
maxY=max(Y);
diffY=maxY-minY;
for i=1:n
    Y(i) = (Y(i) - minY)/diffY;
    for j=1:p
        X(i,j) = (X(i,j) - minX(j))/diffX(j);
    end
end
