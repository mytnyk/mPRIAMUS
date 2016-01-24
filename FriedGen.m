%************************************
% written by Oleg Mytnyk, 2005
% last revision: 16.11.2005
% Friedman problem generator
% 
%************************************

% create matrix of inputs 
clear;
N=1000;%40
p=10;
X=rand(N,p);

noise=normrnd(0,1.0,N,1);

Y = zeros(1,N);
for i=1:N
    Y(i)=10*sin(pi*X(i,1)*X(i,2))+20*(X(i,3)-0.5)^2+10*X(i,4)+5*X(i,5)+noise(i);
end

S=[Y' X];
save './_res_/friedman-long.dat' S -ascii;
