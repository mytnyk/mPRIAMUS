%************************************
% written by Oleg Mytnyk, 2006
% last revision: 24.10.2006
% investigation of confidence intervals
%************************************

clear;
% Kind of problem:
name = 'longley';
cfg=[];
ts=0;

% Set parameters
if strcmp(name,'ampg')
%--------- Miles per gallon test data
    U = [5 7 9 11 13 15];
    cfg=eye(4,4);
    cfg(2,2)=3;
    ts=2/3;
    inData = '../_data_/ampg-4c-80_82.iom';
    upp = 0;
%--------- end params
elseif strcmp(name,'smplfriedman')
%--------- Miles per gallon test data
    U = [5 10 15 20 25 30];
    cfg=2*eye(2,2);
    cfg(1,2)=2;
    ts=2/3;
    inData = '../_data_/smplfriedman.iom';
    upp = 0;
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
    upp = 0;
%--------- end params
elseif strcmp(name,'longley')
%--------- Longley test data
    cfg=eye(6,6);
    cfg(1,1)=0;
    U = [10 20 30 40 50 60];
    ts=0.3;
    inData = '../_data_/Longley.iom';
    upp = 0;
%--------- end params
elseif strcmp(name,'filip')
    cfg=eye(1,1);
    cfg(1,1)=9;
    U = [10 20 30 40 50 60];
    ts=0.6;
    inData = '../_data_/Filip.iom';
    upp = 0;    
%--------- end params
elseif strcmp(name,'cpi')
%--------- cpi test data
    cfg=eye(4,4);
    cfg(1,1)=2;
    cfg(4,4)=2;
    ts=0.4;
    U = [5 10 15 20 25 30];
    inData = '../_data_/cpi.iom';
    upp = 0;
%--------- end params
elseif strcmp(name,'rcon')
%--------- rcon test data
    cfg=eye(2,2);
    cfg(2,2)=2;
    ts=0.4;
    U = [5 8 12 13.5 14.5 22];    
    inData = '../_data_/rcon.iom';
    upp = 0;    
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
% RMl=bbernregr(Xl,cfg);
% RMt=bbernregr(Xt,cfg);
% RMl = RMl(1:6,:);
% t = (RMt(3,:))';
% K = t'*t;
% Kl =RMl*t;
% sigma = K - Kl'*inv(RMl*RMl')*Kl;
% sigma


%x = [-3 -2.1 -1.1, 0.1 0.3 0.4 0.7 1.1, 4.1];
x = [-3 -2.1 0.1 0.4 0.7 4.1];
m = length(x);

for i=1:m
    yx(i) = sin(x(i))/x(i);
end

for i=1:m
    for j=1:m
        K(i,j)=testkernel(x(i),x(j));
    end
end
sigman = 0.0001;
Kinv = inv(K+eye(m)*sigman);

for i=1:100
    % z in (-5 +5)
    z(i) = -5.01 + 0.1*i;
    y(i) = sin(z(i))/z(i);    

    for j=1:m
        Kz(j)=testkernel(x(j),z(i));
    end

    sigma(i) = sqrt(testkernel(z(i),z(i)) - Kz*Kinv*Kz');
%     sigma(i) = sqrt(testkernel(z(i),z(i)));    

end

hold on;

%plot(z,y+sigma,'Color','red');
%plot(z,y-sigma,'Color','red');
for i=1:100
    XX(i) = z(i);
    YY(i) = y(i)+sigma(i);
end

for i=1:100
    XX(i+100) = z(101 - i);
    YY(i+100) = y(101 - i)-sigma(101 - i);
end

fill(XX,YY,[0.90,0.90,0.90],'EdgeColor', 'none');

plot(z,y,'kx', 'MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','g');

hold off;