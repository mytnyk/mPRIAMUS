function y = bspline_0_2(x) 

a0 = -0.5;
a1 = 0;
a2 = 0.5;

for i=1:length(x)
    xi = x(i);
    if (xi < a0)
        yi = 0;
    else 
        if (xi < a1)
            yi = 2*(xi-a0);
        else
            if (xi < a2)
                yi = 2*(a2-xi);
            else
                yi = 0;
            end
        end
    end
    y(i)=yi;
end
