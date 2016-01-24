%************************************
% written by Oleg Mytnyk, (c) 2007
% last revision: 2.01.2007
% benchmark tests
%************************************

clear;
% Kind of problem:
name = 'longley';
cfg=[];
compData=[];
ts=0;
conv=5;
fix = 1; % fixed configuration
uni = 1;
snae = 1;
% Set parameters
if strcmp(name,'longley')
%--------- Longley test data
    eps = 0.03;
    stdeg = 1;
    U = 20;
    ts=0.3;
    cfg=eye(6,6);
    cfg(1,1)=0;
    compData = './_res_/Longley.alter';
    inData = '../_data_/Longley.iom';
%--------- end params
elseif strcmp(name,'filip')
    eps = 0.05;
    U = 20;
    stdeg = 9;
    fix=1;
    ts=0.6;
    compData = './_res_/filip.alter';
    inData = '../_data_/Filip.iom';
%--------- end params
elseif strcmp(name,'friedman')
%--------- Friedman test data
    eps = 0.1;
    stdeg = 1;
    U = 10;
    compData = './_res_/friedman.alter';
    inData = '../_data_/friedman.iom';
    cfg=eye(10,10);
    cfg(1,1)=2;
    cfg(3,3)=2;
    cfg(6,6)=0;
    cfg(7,7)=0;
    cfg(8,8)=0;
    cfg(9,9)=0;
    cfg(10,10)=0;
    ts=2/3;
    conv=2;
%--------- end params
elseif strcmp(name,'smplfriedman')
    eps = 0.08;
    stdeg = 1;
    U = 6.6;
    cfg=eye(2,2);
    cfg=2*eye(2,2);
    cfg(1,2)=2;
    ts=2/3;
    compData = './_res_/smplfriedman.alter';
    inData = '../_data_/smplfriedman.iom';
%--------- end params
elseif strcmp(name,'ampg')
%--------- Miles per gallon test data
    eps = 0.1;
    stdeg = 1;
    U = 5;
    cfg=eye(4,4);
    cfg(2,2)=3;
    ts=2/3;
    conv=1;    
    compData = './_res_/ampg.alter';
    inData = '../_data_/ampg-4c-80_82.iom';
end

kernelident(inData,eps,U,stdeg,ts,cfg,fix,uni,conv,compData,snae,1);

