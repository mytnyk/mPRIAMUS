%**********************************************************
% written by Oleg Mytnyk, (c) 2007
% computing exact integral of evidence

% clear
name = 'rcon';
cfg=[];
ts=0;

if strcmp(name,'rcon')
%--------- rcon test data
    cfg=eye(2,2);
    cfg(2,2)=2;
    ts=0.4;
    U=29.8;
    eps_step = 0.02;
    eps_opt=0.2;
    BEC_opt=-10.2927;    
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

n=100000;
q=length(RMl(1,:));
WN = randn(q,n);

OLEexact = zeros(1, 15);
OLEestimate = zeros(1, 15);
x_eps = zeros(1, 15);
if 1==1
for i=1:15
    epsi=0.01+eps_step*(i-1);
    % build on hypervalues epsi&ui:
    [W,b,alpha,Yestl,OLEi,Nsv,Remp,MSEi]=svr(RMl,Yl,RMt,Yt,epsi,U);
    %
   
    Rreg = U*nl*Remp+0.5*W'*W;

    % compute main int
    integ=0;
    for j=1:n
        wj=WN(:,j);
        UNRemp=U*epsins(Yl-RMl*wj-b,epsi);
        integ=integ+exp(-UNRemp);
    end
    
    integ=integ/n;
    OLEexact(i)=-nl*log(U/(2*(1+epsi*U)))-log(integ);
    OLEestimate(i)=OLEi;
    x_eps(i)=epsi;
end
end

hold on;
plot(x_eps,OLEexact,'Color','blue','LineWidth',3);
plot(x_eps,OLEestimate,'Color','green','LineWidth',3);
set(gca,'FontSize',24);
legend('MCMC','BEC');
set(gca,'FontSize',24,'XLim',[0.01 0.01+14*eps_step]);

% set optimal point
line([eps_opt-0.5*eps_step eps_opt+0.5*eps_step],[BEC_opt-1 BEC_opt+1],'Color','red','LineWidth',5);
line([eps_opt-0.5*eps_step eps_opt+0.5*eps_step],[BEC_opt+1 BEC_opt-1],'Color','red','LineWidth',5);


return;