%************************************
% written by Oleg Mytnyk, 2007
% last revision: 19.02.2007
%************************************

% Problem:
name = 'msh03';

eps = 0.2; U = 10;
fix = 2; % 1 - fixed configuration
uni = 0; % 1 - only univariate
t = 0.5;
conv = 0.1;
cfg=eye(2,2);
cfg(1,1)=1;
cfg(2,2)=1;
snae=0;
stdeg=1;
drawings=1;
% Set parameters
if strcmp(name,'ibss')
%---------
    inData = '../_data_/ibss.iom';
elseif strcmp(name,'msh03')
%--------- 
    inData = '../_data_/msh03.iom';
end

kernelident(inData,eps,U,stdeg,t,cfg,fix,uni,conv,[],snae,drawings);

