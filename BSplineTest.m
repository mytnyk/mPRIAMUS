
t = -1:0.01:2;
f = [];
%a = [-1 -0.5 0 0.5 1 1.5];
a = [-0.25 0 0.25 0.5 0.75 1 1.25];
order = 1;
j = 1;

hold on
for j=1:(length(a)-2)
    for i=1:length(t) 
        x = t(i);
        f(j,i) = bspline(order, j, a, x);
    end
    plot(t,f(j,:));
end

hold off