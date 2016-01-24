function [z]=testkernel(x,y)

sigma = 0.8;
sigma2 = sigma*sigma;
%z=1/(sqrt(2*pi)*sigma)*exp(-(0.5/sigma2)*(x-y)*(x-y));
z=exp(-(0.5/sigma2)*(x-y)*(x-y));
%z=exp(-(0.5/sigma2)*abs(x-y));
%z=(x*y+0.1)*(x*y+0.1);
z=x*y;