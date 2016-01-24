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
    U = 3:1:17;
    eps_step=0.02;    
    cfg=eye(4,4);
    cfg(2,2)=3;
    ts=2/3;
    eps_opt=0.021;
    beta_opt=7.6;
    BECS = [-2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12];
    inData = '../_data_/ampg-4c-80_82.iom';
%--------- end params
elseif strcmp(name,'smplfriedman')
%--------- simple Friedman test data
    U = 3:2:29;
    eps_step=0.02;    
    cfg=2*eye(2,2);
    cfg(1,2)=2;
    ts=2/3;
    eps_opt=0.022;
    beta_opt=9.7;
    BECS = [1 -1 -3 -5 -7 -9 -11 -13 -15 -17];
    inData = '../_data_/smplfriedman.iom';
%--------- end params
elseif strcmp(name,'choppy')
%--------- choppy test data
    U = [5 10 15 20 25 30];
    %U = 3:2:29;
    eps_step=0.01;    
    cfg=eye(3,3);
    ts=130/166;
    eps_opt=0.02;
    beta_opt=10;
    BECS = [1 -1 -3 -5 -7 -9 -11 -13 -15 -17];
    inData = '../_data_/choppy.iom';
%--------- end params
elseif strcmp(name,'friedman')
%--------- Friedman test data
    U = 3:2:29;
    eps_step=0.02;
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
    eps_opt=0.02;
    beta_opt=8.5;
    BECS = [1 -1 -3 -5 -7 -9 -11 -13 -15 -17];
%--------- end params
elseif strcmp(name,'longley')
%--------- Longley test data
    cfg=eye(6,6);
    cfg(1,1)=0;
    U = 13:3:53;
    ts=0.3;
    eps_step=0.02;
    BECS = [-3 -6 -9 -12 -15 -18 -21 -24 -27 -30];
    eps_opt=0.021;
    beta_opt=48.8;      
    inData = '../_data_/Longley.iom';
%--------- end params
elseif strcmp(name,'filip')
    cfg=eye(1,1);
    cfg(1,1)=9;
    U = 13:3:53;
    ts=0.6;
    eps_opt=0.033;
    beta_opt=50;     
    eps_step=0.01;
    BECS = [-10 -20 -30 -40 -50 -60 -65 -70 -75 -80];    
    inData = '../_data_/Filip.iom';
%--------- end params
elseif strcmp(name,'cpi')
%--------- cpi test data
    cfg=eye(4,4);
    ts=0.4;
    U = [];
    eps_step=0.01;    
    inData = '../_data_/cpi.iom';
    eps_opt=0.027;
    beta_opt=27.7;    
    BECS = [-10 -12 -14 -16 -18 -20 -22 -24 -26 -28];
%--------- end params
elseif strcmp(name,'rcon')
%--------- rcon test data
    cfg=eye(2,2);
    cfg(2,2)=2;
    ts=0.4;
    U = 7:2:33;
    eps_step=0.02;
    inData = '../_data_/rcon.iom';
    eps_opt=0.2;
    beta_opt=29.8;
    BECS = [0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10];
%--------- end params
elseif strcmp(name,'ibss')
%--------- ibss test data
    cfg=eye(2,2);
    ts=0.5;
    U = 6:1:18;
    eps_step=0.015;
    inData = '../_data_/ibss.iom';
    eps_opt=0.2;
    beta_opt=29.8;
    BECS = [-5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15];
%--------- end params
elseif strcmp(name,'msh03')
%--------- msh03 test data
    cfg=eye(2,2);
    ts=0.5;
    U = 6:1:18;
    eps_step=0.015;
    inData = '../_data_/msh03.iom';
    eps_opt=0.2;
    beta_opt=29.8;
    BECS = [-5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15];
%--------- end params
end


% clear command window
clc;
% read data and normalize it:
[X,minX,maxX,Y,minY,maxY]=readnormalized(inData);
[n, p]=size(X);


nt=round(n*ts); % test set size
nl=n-nt;        % learning set size
disp('STARTING SUPPORT VECTOR REGRESSION');
disp(sprintf('learning = %d; test = %d;', nl, nt));
Xl=X(1:nl,:);
Yl=Y(1:nl);
Xt=X(nl+1:n,:);
Yt=Y(nl+1:n);


% construct regressors, i.e. Bezier-Bernstein polynomial functions
% which span feature space defined by configuration cfg
RMl=bbernregr(Xl,cfg);
RMt=bbernregr(Xt,cfg);

if U
else
    U = 7:2:32;
end

if 1==1
for ui=1:length(U) 

    disp(sprintf('U = %.2f', U(ui)));
    
    for i=1:15
        epsi=0.01+eps_step*(i-1);
        % build on hypervalues epsi&ui:
        [W,b,alpha,Yestl,OLEi,Nsv,Remp,MSEi]=svr(RMl,Yl,RMt,Yt,epsi,U(ui));
    
        Xa(ui,i) = epsi*(maxY-minY); % real scale epsilon
        Ya(ui,i) = U(ui);
        OLEa(ui,i) = OLEi;
        MSEa(ui,i) = MSEi;        
    end

end
end

% scale back epsilon:
eps_opt = eps_opt*(maxY-minY);
eps_step = eps_step*(maxY-minY);

figure;
[C,h] = contour(Xa,Ya,OLEa, BECS);
colormap bone;

clabel(C,'manual');
%delete lines:
delete(findobj(gca,'Type','line'));
% set optimal point
line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt-0.6 beta_opt+0.6],'Color','red','LineWidth',4);
line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt+0.6 beta_opt-0.6],'Color','red','LineWidth',4);
% set good properties:
set(findobj('LineWidth',0.5),'LineWidth',2);
set(findobj('FontSize',10),'FontSize',24);
%set(gca,'FontSize',24,'XLim',[0.01 0.01+14*eps_step]);

figure;
[C,h] = contour(Xa,Ya,MSEa);
colormap bone;

clabel(C,'manual');
%delete lines:
delete(findobj(gca,'Type','line'));
% set optimal point
line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt-0.6 beta_opt+0.6],'Color','red','LineWidth',4);
line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt+0.6 beta_opt-0.6],'Color','red','LineWidth',4);
% set good properties:
set(findobj('LineWidth',0.5),'LineWidth',2);
set(findobj('FontSize',10),'FontSize',24);
%set(gca,'FontSize',24,'XLim',[0.01 0.01+14*eps_step]);

return;