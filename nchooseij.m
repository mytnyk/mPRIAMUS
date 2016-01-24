function [b]=nchooseij(n,i,j)
%***************************************
% written by Oleg Mytnyk, 2005
% last revision: 10.11.2005
%***************************************
b = factorial(n)/(factorial(n-i-j)*factorial(j)*factorial(i));