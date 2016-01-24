function [RM]=bbernregr2d(X,cfg)
%*********************************************************************
% written by Oleg Mytnyk, (c) 2005 - 2006
% last revision: 25.03.2006
% output: RM  - regression matrix
% input:  X   - matrix of observations, data should be normilized!
%         cfg - model configuration uppertriangular matrix: 
%               diagonal elements stand for univariate poly degree
%               upper non-diagonal elements stand for bivariate poly degree
%*********************************************************************

[N, p]=size(X); % p - number of input parameters, N - number of samples

if p~=length(cfg)
    error('Different size of vectors!');
end

% baryc. preparations:
b_0d0=[2; -0.5];
b_d00=[0.5; 2.5];
b_00d=[-1; -0.5];  
BD=inv([b_0d0-b_00d b_d00-b_00d]);

RM = [];
for i=1:p % look for pairs (i,j)
    % look at current univariate:
    d = cfg(i,i); % read the required poly degree for this input parameter
    if d~=0
        New = bernpoly1d(X(:,i),d);
        RM = [RM New];
    end
    %look for existing bivariates:
    for j=i+1:p 
        d=cfg(i,j);
        if d~=0
            Xi=X(:,i);
            Xj=X(:,j);
            % find baricentric: U,V
            for t=1:N
                x=[Xi(t); Xj(t)];
                uv=BD*(x-b_00d);
                U(t)=uv(1);V(t)=uv(2);
            end
            New = bernpoly2d(U,V,d);
            RM = [RM New];
        end
    end
end

return;
%*********************************************************************