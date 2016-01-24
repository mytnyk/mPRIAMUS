function [y,g,h]=qpvalue(x,H,f)

y=0.5*x'*H*x+f*x;


if nargout > 1   % qpvalue called with two output arguments
    g = H*x+f';  % Gradient of the function evaluated at x
    if nargout > 2
        h = H;  % Hessian evaluated at x
    end
end


return;