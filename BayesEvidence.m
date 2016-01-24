%************************************
% written by Oleg Mytnyk, 2007
% last revision: 2.01.2007
% investigation of Bayesian evidence of hyperparameters
%************************************

clear;
% Kind of problem:
name = 'longley';
cfg=[];
ts=0;

% Set parameters
if strcmp(name,'ampg')
%--------- Miles per gallon test data
    U = [3 5 7 9 11 13];
    cfg=eye(4,4);
    cfg(2,2)=3;
    ts=2/3;
    inData = '../_data_/ampg-4c-80_82.iom';
%--------- end params
elseif strcmp(name,'smplfriedman')
%--------- Miles per gallon test data
    U = [5 10 15 20 25 30];
    cfg=eye(2,2);
    ts=2/3;
    inData = '../_data_/smplfriedman.iom';
%--------- end params
elseif strcmp(name,'friedman')
%--------- Friedman test data
    U = [3 7 9 13 18 23];
    inData = '../_data_/friedman.iom';
    cfg=eye(10,10);
    cfg(2,2)=2;
    cfg(3,3)=2;
    cfg(5,5)=2;
    cfg(6,6)=0;
    cfg(7,7)=0;
    cfg(8,8)=0;
    cfg(9,9)=0;
    cfg(10,10)=0;
    ts=2/3;
%--------- end params
elseif strcmp(name,'longley')
%--------- Longley test data
    cfg=eye(6,6);
    cfg(1,1)=0;
    U = [10 20 30 40 50 60];
    ts=0.3;
    inData = '../_data_/Longley.iom';
%--------- end params
elseif strcmp(name,'filip')
%--------- filip test data
    cfg=eye(1,1);
    cfg(1,1)=9;
    U = [10 20 30 40 50 60];
    ts=0.6;
    inData = '../_data_/Filip.iom';
%--------- end params
elseif strcmp(name,'cpi')
%--------- cpi test data
    cfg=eye(4,4);
%     cfg(1,1)=2;
%     cfg(4,4)=2;
    ts=0.4;
    U = [5 10 15 20 25 30];
    inData = '../_data_/cpi.iom';
%--------- end params
elseif strcmp(name,'rcon')
%--------- rcon test data
    cfg=eye(2,2);
    cfg(2,2)=2;
    ts=0.4;
    U = [5 10 15 20 25 30];    
    inData = '../_data_/rcon.iom';
%--------- end params
end



% clear command window
clc;
% read data and normalize it:
[X,minX,maxX,Y,minY,maxY]=readnormalized(inData);
[n, p]=size(X);


nt=round(n*ts); % test set size
nl=n-nt;        % learning set size
disp('STARTING BAYESAIN SUPPORT VECTOR REGRESSION');
disp(sprintf('learning = %d; test = %d;', nl, nt));
Xl=X(1:nl,:);
Yl=Y(1:nl);
Xt=X(nl+1:n,:);
Yt=Y(nl+1:n);


% construct regressors, i.e. Bezier-Bernstein polynomial functions
% which span feature space defined by configuration cfg
RMl=bbernregr(Xl,cfg);
RMt=bbernregr(Xt,cfg);

f1=figure;
hold on;
f2=figure;
hold on;

colors=[[1.0 0.0 0.0]; [1.0 1.0 0.0]; [0.0 1.0 0.0]; [0.0 1.0 1.0]; [0.0 0.0 1.0]; [1.0 0.0 1.0]];

for ui=1:length(U) 

    disp(sprintf('U = %.2f', U(ui)));
    
    for i=1:31
        epsi=0.01+0.01*(i-1);
        % build on hypervalues epsi&ui:
        [W,b,alpha,Yestl,OLEi,Nsv,Remp,MSEi]=svr(RMl,Yl,RMt,Yt,epsi,U(ui));
    
        eps(i)=epsi;
        OLE(i)=OLEi;
        MSE(i)=MSEi;
    end

    b = ones(1,5)/5;             % 5 point averaging filter
    OLE = filtfilt(b,1,OLE);
    MSE = filtfilt(b,1,MSE);

    figure(f1);
    plot(eps,OLE,'LineWidth',2,'Color',colors(ui,:));
    figure(f2);
    plot(eps,MSE,'LineWidth',2,'Color',colors(ui,:));
end

figure(f1);
set(gca,'FontSize',24,'XLim',[0.01 0.3]);

figure(f2);
set(gca,'FontSize',24,'XLim',[0.01 0.3]);

legend(num2str(U(1)),num2str(U(2)),num2str(U(3)),num2str(U(4)),num2str(U(5)),num2str(U(6)));
