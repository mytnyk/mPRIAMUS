%************************************
% written by Oleg Mytnyk, 2005
% last revision: 16.11.2005
% Sinc problem generator
% 
%************************************

% create matrix of inputs 
clear;
N=40;
p=10;
%X=20*sort(rand(N,1))-10;

for i=1:N
    X(i)=(i-20+0.1)/2;
    Y(i)=sin(abs(X(i)))/abs(X(i))+normrnd(0,0.1);
end

plot(X,Y,'-rs','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',5);

S=[Y' X'];
save './_res_/sinc.dat' S -ascii;
