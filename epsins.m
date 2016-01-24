function [fval]=epsins(Y,eps)
%**************************************
% written by Oleg Mytnyk, 2005
% last revision: 10.11.2005
% epsilon insensitive norm of vector Y
%**************************************
fval = 0;
n = length(Y);
for i=1:n
    fcurr=abs(Y(i));
    if (fcurr>eps)
        fcurr = fcurr-eps;
    else
        fcurr = 0;
    end
    fval = fval+fcurr;
end
