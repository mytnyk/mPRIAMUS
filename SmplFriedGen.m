%************************************
% written by Oleg Mytnyk, 2005
% last revision: 16.11.2005
% Simplified friedman problem generator
% 
%************************************

% create matrix of inputs 
clear;
N=30;
p=2;
X=rand(N,p);

noise=normrnd(0,1.0,N,1);

for i=1:N
    Y(i)=10*sin(pi*X(i,1)*X(i,2))+noise(i);
end

S=[Y' X];
save './_res_/smplfriedman.dat' S -ascii;
