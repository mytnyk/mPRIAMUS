function [cfg]=kernelident(inData,eps,U,stdeg,ts,cfg,fixed,uni,conv,compData,snae,drawings)
%**********************************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 2.01.2007
% MAIN TISMA FUNCTIONALITY
% input:  inData - input data file,
%         eps    - initial epsilon tube size,
%         U      - initial regularizing constant,
%         stdeg  - starting degree value,
%         ts     - percent for test data set,
%         cfg    - initial configuration,
%         fixed  - shows whether configuration is fixed,
%         uni    - (1 - use only univariate), 
%         conv   - convergence level,
%         compData - results of other algorithms
%         snae   - parameter for bstr solver, whether to solve SNAE
%         drawings - enable drawings
% so we have: [learning set...validation set...test set]
% output: cfg    - best configuration we found
%**********************************************************

% clear command window
clc;
% read data and normalize it:
[X,minX,maxX,Y,minY,maxY]=readnormalized(inData);
[n, p]=size(X);

% set initial model if it is empty
if cfg
else
    cfg=eye(p,p)*stdeg;
    if (stdeg==0)
       cfg(1,1)=1;
    end
end

nt=round(n*ts); % test set size
nl=n-nt;        % learning set size
disp('STARTING BAYESAIN SUPPORT VECTOR REGRESSION');
disp(sprintf('learning = %d; test = %d;', nl, nt));
Xl=X(1:nl,:);
Yl=Y(1:nl);
Xt=X(nl+1:n,:);
Yt=Y(nl+1:n);

% find the best model:
if (fixed == 0)
    cfg=findbestmodel(Xl,Yl,Xt,Yt,cfg,uni,eps,U,conv,snae);
end

% final construction on learning set and calculate on test set:
if (fixed == 2) % strong fixing - limiting to ordinal svr
    RMl=bbernregr(Xl,cfg);
    RMt=bbernregr(Xt,cfg);
    [W,b,alpha,Yestl,OLE,Nsv,Remp]=svr(RMl,Yl,RMt,Yt,eps,U);
else
    [W,b,alpha,Yestl,OLE,eps,U,Nsv,Remp]=bsvr(Xl,Yl,Xt,Yt,cfg,eps,U,snae);
end


RM=bbernregr(X,cfg);
Yest=RM*W+b;

disp('************Model configuration*************');
dof=length(W); % Degrees of freedom of the model
disp(sprintf('dof = %d; model configuration:', dof));
disp(cfg);

disp('************Bayesian inference*************');
disp(sprintf('Opposite log evidence = %g; Empirical risk = %g;', OLE, Remp));
Nsv_wait = round(nl/(1+eps*U));
disp(sprintf('SV wait = %d; SV real = %d;', Nsv_wait, Nsv));
disp(sprintf('U wait = %g; U real = %g;', Nsv/(Remp*nl), U));
rseps = eps*(maxY-minY);
disp(sprintf('real scale epsilon = %g; new epsilon = %g;', rseps, eps*Nsv/Nsv_wait));
disp('************Generalization test*************');

% scale back Y:
Y=Y*(maxY-minY)+minY;
Yest=Yest*(maxY-minY)+minY;
% scale back X:
for j=1:p
    X(:,j)=X(:,j)*(maxX(j)-minX(j))+minX(j);
end

% calculate confidence intervals...
alp1 = alpha(1:nl);
alp2 = alpha(nl+1:2*nl);

% support vector expansion coef.:
expansion=(alp1-alp2)
W
b
%

M = [];
ZERO = 0.000001;
for i=1:nl % marginal
    if (((alp1(i)>ZERO) && (alp1(i)<U-ZERO)) || ((alp2(i)>ZERO) && (alp2(i)<U-ZERO)))
        M = [M i];
    end
end

Mm = length(M);
KM = zeros(Mm, dof);
for i=1:Mm
    KM(i,:) = RM(M(i),:); 
end;

sigma2n = 2/(U*U)+eps*eps*(eps*U+3)/(3*(eps*U+1));

Kinv=inv(KM*KM'+eye(Mm)*sigma2n);

sigma = zeros(1, n);
for i=1:n
    t = (RM(i,:))';
    Kl = KM*t;
    sigma(i) = sqrt(t'*t - Kl'*Kinv*Kl+sigma2n);    
end

% scale back sigma:
sigma = sigma*(maxY-minY);

% output results as picture:
if drawings==1
supdraw(alpha,Y,Yest,rseps,nt,2*sigma,compData);
end

% output partial dependencies:
if drawings==1
weightind = 1;
for i=1:p
    % output curves:    
    if cfg(i,i)>0
        vol = cfg(i,i) + 1;
        w_part = W(weightind:weightind+vol-1);
        supdrawcurve(i,alpha,X,minX,maxX,Y,minY,maxY,Yest,nt,cfg,w_part,b);
        weightind = weightind + vol;
    end
    % output surfaces:
    for j=i+1:p
        if cfg(i,j)>0
            vol = (cfg(i,j)+1)*(cfg(i,j)+2)/2;
            w_part = W(weightind:weightind+vol-1);
            supdrawsurf(i,j,alpha,X,minX,maxX,Y,minY,maxY,Yest,nt,cfg,w_part,b);
            weightind = weightind + vol;
        end
    end
end
end

fid = fopen('./_res_/last_results.dat','w');% save some results
fprintf(fid,'&%6.1f\t',alpha(1:nl));
fprintf(fid,'\n');
fprintf(fid,'&%6.1f\t',alpha(nl+1:2*nl));
fprintf(fid,'\n%6.2f',b);
fclose(fid);

% calculate the generalization error on test data set (or learning)
if  (nt == 0)
    Yt=Y(1:nl);
    Yestt=Yest(1:nl);
else
    Yt=Y(nl+1:n);
    Yestt=Yest(nl+1:n);
end
nerr = length(Yt);
MSE = (Yt-Yestt)'*(Yt-Yestt)/nerr; % Mean Square Error
MAE = mean(abs(Yt-Yestt)); % Mean Absolute Error
disp(sprintf('MSE = %g; MAE = %g', MSE, MAE));

disp('************Table entry*************');
disp(sprintf('%g (%g) & %g & %g & %g & %g & %g', rseps, eps, U, Nsv_wait, Nsv, MSE, MAE));

% Durbin-Watson statistics:

e=Yl-Yestl;
DW = 0;
for i=2:nl
    DW = DW + (e(i)-e(i-1))^2;
end
DW = DW/(e'*e);
disp(sprintf('Durbin-Watson: %g', DW));


% Theil accuracy coefficient:
Th = sqrt(MSE)/(sqrt(Yt'*Yt/nerr)+sqrt(Yestt'*Yestt/nerr));
disp(sprintf('Theil accuracy: %g', Th));

minY
maxY
%(maxY-minY)*(maxY-minY)