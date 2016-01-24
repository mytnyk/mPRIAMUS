function [B]=bernpoly2d(U,V,d)
%**************************************************************
% written by Oleg Mytnyk, 2005
% last revision: 10.11.2005
% output: B   - matrix of values of the bivariate Bernstein poly
% input:  U,V - vector variables, each within [0, 1]
%         d   - poly degree
%**************************************************************

n=length(U); % the length of the input data vector
if n~=length(V)
    warning('Different size of vectors!');
end

nop=(d+1)*(d+2)/2; % total number of polynomials
B=zeros(n,nop);
for t=1:n
    c=0;
    for i=0:d
        for j=0:d
            for k=0:d            
                if i+j+k==d
                    c=c+1;
                    B(t,c) = nchooseij(d, i, j)*U(t)^i*V(t)^j*(1-V(t)-U(t))^(d-i-j);
                end
            end
        end
    end
end

return;
%**************************************************************