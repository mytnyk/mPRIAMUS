function [cfg]=findbestmodel(Xl,Yl,Xt,Yt,cfg,uni,eps,U,conv,snae)
%**************************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 1.01.2007
% SEARCHES FOR THE BEST CONFIGURATION OF FEATURE SPACE
% input:  Xl  - learning input model variables,
%         Yl  - learning output model variable,
%         Xt,Yt - test dataset,
%         cfg - initial configuration,
%         uni - (1 - use only univariate),
%         eps - initial guess of epsilon,
%         U   - initial guess of regularizer,
%         conv- convergence level,
%         snae- whether to solve SNAE,
% output: cfg - best configuration found;
%**************************************************

[N,p]=size(Xl);

% start first with current configuration:
disp('Initial model configuration:');
disp(cfg);
[W,b,alpha,Yest,curr_value]=bsvr(Xl,Yl,Xt,Yt,cfg,eps,U,snae);

cfg_storage(:,1) = cfg(:);

stop = 0; % stop criteria
while stop == 0
    cand_value = curr_value;
    cand_cfg = cfg;
    for q=1:2
        step=2*q-3; % that is -1 ,and +1 
        for i=1:p
            for j=i:p 
                if (uni == 1) && (j > i)
                    continue; % restrict bivariate change
                end
                cfg_try = cfg;
                if (cfg_try(i, j)==0) && (step < 0)
                    continue;
                end
                cfg_try(i, j)=cfg_try(i, j)+step;
                
                if (norm(cfg_try,inf) == 0)
                    continue;
                end
                
                % check whether we had already such a configuration 
                [fake len]=size(cfg_storage);
                exflag=0;
                for l=1:len
                    if cfg_storage(:,l)==cfg_try(:)
                        exflag=1;
                        break;
                    end
                end
                if exflag==1
                    continue;
                end
                cfg_storage(:,len+1)=cfg_try(:);
                
                disp('Try model configuration:');
                disp(cfg_try);
                [W,b,alpha,Yest,OLE]=bsvr(Xl,Yl,Xt,Yt,cfg_try,eps,U,snae);
                disp(sprintf('Configuration risk (OLE) = %g;', OLE));
                
                if OLE < cand_value % if good step
                    cand_cfg = cfg_try; % remember as best configuration
                    cand_value = OLE;
                end
            end
        end
    end % for

    if (cand_value + conv < curr_value )
        curr_value = cand_value;
        cfg = cand_cfg;
    else
        stop = 1;
    end
    
end

%**************************************************