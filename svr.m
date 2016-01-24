function [W,b,alpha,Yestl,OLE,Nsv,Remp,MSEn]=svr(Xl,Yl,Xt,Yt,eps,U)
%**********************************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 31.12.2006
% SIMPLE SUPPORT VECTOR REGRESSION SOLVER
% input:  Xl,Yl - learning input/output data,
%         Xt,Yt - test dataset,
%         eps   - epsilon tube for SVR,
%         U     - regularization parameter;
% output: W, b  - model coefficients,
%         alpha - model support helper,
%         Yestl - estimated output vector, as Yestl=Xl*W+b,
%         OLE   - Opposite log evidence,
%         Nsv   - number of support vectors 
%         Remp  - empiric risk,
%         MSEn  - mean square error on normalized test data set
%**********************************************************

% zero
ZERO = 0.000001;

% construct dual SVR problem:
[N,p]=size(Xl);
% construct hessian H:
D=Xl*Xl';
H=[D -D; -D D];
% construct linear term:
f=zeros(1,2*N);
for i=1:N
    f(i)=eps-Yl(i);
    f(i+N)=eps+Yl(i);
end
% construct restrictions:
lb= zeros(2*N,1);
ub= ones(2*N,1);
ub= U*ub;
on= ones(1,N);
Aeq=[on -on]; % could be [-on on] as well
beq=0;

% set parameters for optimization
% active set method
options = optimset('Display','off','LargeScale','off','Diagnostics','off','MaxIter',1000);
% solve dual SVR problem using quadratic programming:
[alpha,opt_value_dual,exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);

it = 0;
while (exitflag == 0) && (it < 10)
    it = it + 1;
    [alpha,opt_value_dual,exitflag] = linprog(f,[],[],Aeq,beq,lb,ub,alpha,options);    
    [alpha,opt_value_dual,exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,ub,alpha,options);
end
if (it == 10)
    disp('<using nonlinear optimization instead of QP>');%,
    options = optimset('TolFun',0.01,'TolX',0.01,'Display','off','LargeScale','off','Diagnostics','off','MaxIter',100);
    [alpha,opt_value_dual,exitflag] = fmincon(@qpvalue,alpha,[],[],Aeq,beq,lb,ub,[],options,H,f);
end

if (exitflag <= 0)
    disp('Failed to solve quadratic programming problem!')
end

W=[Xl' -Xl']*alpha;
% find the bias b according to Muller's method:
deviup = Yl-Xl*W-eps;
devilo = Yl-Xl*W+eps;
mrgb = [];
for i=1:N
    if (alpha(i) > ZERO) && (alpha(i) < U-ZERO)
        % upper margin point
        mrgb = [ mrgb deviup(i)];
    else
        if (alpha(i+N) > ZERO) && (alpha(i+N) < U-ZERO)
            % lower margin point
            mrgb = [ mrgb devilo(i)];
        end
    end
end

if (isempty(mrgb))
    error('Failed to solve quadratic programming problem!')
end

b = mean(mrgb);

% final model:
Yestl=Xl*W+b;

% empiric risk:
Remp = epsins(Yl-Yestl, eps)/N;

% optimal value of the primal problem (regularized risk):
Rreg = U*N*Remp+0.5*W'*W;

% calculate a number of support vectors:
Nsv = 0;
for i=1:N
    if (alpha(i) > ZERO) || (alpha(i+N) > ZERO)
        Nsv=Nsv+1;
    end
end

% Opposite log evidence equals:
OLE = Rreg - N*log(U/(2*(1+eps*U)));

% calculate variance and mean of the error on test data set
Nt = length(Yt);
Yestt = Xt*W+b;
MSEn = (Yt-Yestt)'*(Yt-Yestt)/Nt; % Mean Square Error on Normalized Data
MAEn = mean(abs(Yt-Yestt)); % Mean Absolute Error on Normalized Data

disp(sprintf(' & %.2f & %.3f & %.1f & %d & %.4f & %.4f & %.4f & %.4f', OLE, eps, U, Nsv, Remp, Rreg, MSEn, MAEn));

return;
%**********************************************************