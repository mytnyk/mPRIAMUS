%************************************
% written by Oleg Mytnyk, 2007
% last revision: 19.02.2007
%************************************

% Problem:
name = 'choppy';

eps = 0.1; U = 10;
fix = 2; % 1 - fixed configuration
uni = 0; % 1 - only univariate
t = 0;
conv = 0.1;
cfg=1*eye(2,2);
%cfg(1,1)=1;
%cfg(2,2)=1;
snae=0;
stdeg=1;
drawings=1;
% Set parameters
if strcmp(name,'choppy')
    t = 0.9;
    cfg=1*eye(3,3);
    inData = '../_data_/choppy.iom';
end

kernelident(inData,eps,U,stdeg,t,cfg,fix,uni,conv,[],snae,drawings);

