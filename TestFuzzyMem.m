%************************************
% written by Oleg Mytnyk, 2008
% testing fuzzy membership functions
%************************************
t = 0:0.01:1;

f = [];


for j=1:3

a0 = (j-1)/2-0.5;
a1 = (j-1)/2;
a2 = (j-1)/2+0.5;

for i=1:length(t) 
    x = t(i);
    if (x < a0)
        y = 0;
    else 
        if (x < a1)
            y = 2*(x-a0);
        else
            if (x < a2)
                y = 2*(a2-x);
            else
                y = 0;
            end
        end
    end
    f(j,i)=y;
end
end



hold on
plot(t,f(1,:));
plot(t,f(2,:));
plot(t,f(3,:));
hold off

Q0 = quad(@bspline_0_2,0,1)
Q1 = quad(@bspline_1_2,0,1)
Q2 = quad(@bspline_2_2,0,1)