%*********************************************************************
% written by Oleg Mytnyk, (c) 2008
% last revision: 24.01.2008
%               Plots Bernstein polynomials
%*********************************************************************


t = 0:0.01:1;
d = 4;
bp = bernpoly1d(t,d);

plot(t, bp, 'k', 'LineWidth', 2);



