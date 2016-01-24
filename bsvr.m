function [W,b,alpha,Yestl,OLE,eps,U,Nsv,Remp]=bsvr(Xl,Yl,Xt,Yt,cfg,eps,U,snae)
%***********************************************************
% written by Oleg Mytnyk, (c) 2005-2006
% last revision: 26.10.2006
% BSVR BUILT ON LEARNING SET
% input:  Xl,Yl - learning input/output data, 
%         Xt,Yt - test dataset,
%         cfg   - configuration of the feature space,
%         eps   - initial epsilon tube for SVR; 
%         U     - initial regularization parameter
% output: W, b  - model coefficients
%         alpha - model support helper  (Lagrange multipliers) 
%         Yestv - estimated output vector, as Yestv=X*W+b
%                 !!! or Yestv(x)=sum (alpha1-alpha2)*<Fi(xj), Fi(x)>+b
%         OLE   - Opposite Log Evidence on validation set
%         eps,U - returns optimal hypervalues
%***********************************************************

% construct regressors, i.e. Bezier-Bernstein polynomial functions
% which span feature space defined by configuration cfg
RMl=bbernregr(Xl,cfg);
RMt=bbernregr(Xt,cfg);

% BAYESIAN OPTIMIZATION:   
epsu = [eps; U]; % Make a starting guess at the solution

if snae==1
    % Set the options:
    % interior-reflective Newton method (trust region)
    options=optimset('Display','off','TolFun',0.0001,'TolX',0.001,'MaxFunEvals', 100);
    % Gauss-Newton method with line-search
    %options=optimset('Display','iter','LargeScale','off','TolFun',0.1,'TolX',0.1,'MaxFunEvals', 100);
    % LevenbergMarquardt algorithm
    %options=optimset('Display','iter', 'LevenbergMarquardt', 'on', 'LargeScale','off','TolFun',0.1,'TolX',0.1,'MaxFunEvals', 100);
    F = fsolve(@bsvrsolversys,epsu,options,RMl,Yl,RMt,Yt);  % Call optimizer
else
    % Nelder-Mead simplex search method
    options=optimset('Display','off','TolFun',0.1,'TolX',0.1,'MaxFunEvals', 100);
    F = fminsearch(@bsvrsolvercri,epsu,options,RMl,Yl,RMt,Yt);  % Call optimizer
    % Trust-region
    % options=optimset('Display','iter','Diagnostics','on','TolFun',0.1,'TolX',0.1,'MaxFunEvals', 100,'GradObj','on','Hessian','off');
    % F = fminunc(@bsvrsolvercri,epsu,options,RMl,Yl,RMt,Yt);  % Call optimizer
end

% read the optimal hyperparameter values if valid
if (F(1) > 0) && (F(2) > 0)
    eps = F(1);
    U   = F(2);
end

% build on optimal hypervalues:
[W,b,alpha,Yestl,OLE,Nsv,Remp]=svr(RMl,Yl,RMt,Yt,eps,U);

return;
%***********************************************************