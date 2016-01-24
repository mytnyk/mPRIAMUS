function [B]=bernpoly1d(U,d)
%**************************************************************
% written by Oleg Mytnyk, 2005
% last revision: 10.11.2005
% output: B - matrix of values of the univariate Bernstein poly
% input:  U - vector variable within [0, 1]
%         d - poly degree
%**************************************************************

n=length(U); % the length of the input data vector
B=zeros(n,d+1); % totally we have d+1 univariate polynomials
for k=1:n
    for j=0:d
        B(k,j+1) = nchoosek(d, j)*U(k)^j*(1-U(k))^(d-j);
    end
end

return;
%**************************************************************