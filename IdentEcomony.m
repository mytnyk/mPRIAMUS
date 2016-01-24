%************************************
% written by Oleg Mytnyk, 2006
% last revision: 25.03.2006
% cpi equation from simplified model economy of Ukraine 99-98
%************************************

% Problem:
name = 'rcon';

fix = 1; % 1 - fixed configuration
uni = 1; % 1 - only univariate
cfg = [];
conv = 3;
snae = 0;
% Set parameters
if strcmp(name,'cpi')
%--------- cpi test data
    eps = 0.05;
    U = 20;
    stdeg = 1;
    inData = '../_data_/cpi.iom';
    compData = './_res_/cpi.alter';
%--------- end params
elseif strcmp(name,'rcon')
%--------- rcon test data
    eps = 0.2;
    U = 20;
    stdeg = 1;
    fix = 1;
    uni = 0;
    conv = 0.7;
    cfg=eye(2,2);
    cfg(2,2)=2;
    inData = '../_data_/rcon.iom';
    compData = './_res_/rcon.alter';
%--------- end params
end

kernelident(inData,eps,U,stdeg,0.4,cfg,fix,uni,conv,compData,snae,1);

