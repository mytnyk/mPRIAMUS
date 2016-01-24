function [y] = bspline(order, i, a, x)
%*************************************
% BSpline 'i' of of order 'order' based on knots 'a'
%*************************************

if (order == 0)
    if ((x >= a(i)) && (x < a(i+1)))
        y = 1;
    else
        y = 0;
    end
else
    y = (x-a(i))/(a(i+order)-a(i))*bspline(order-1, i, a, x) + (1-(x-a(i+1))/(a(i+1+order)-a(i+1)))*bspline(order-1, i+1, a, x);
end