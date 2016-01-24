% Noise model

U = 15;
eps = 0.06;

for i=1:200
    x(i) = (i-100)/200;
    p(i) = U/(2*(1+eps*U))*exp(-U*epsins(x(i),eps));
end

hold on;
pbaspect([2 1 1]);
plot(x,p,'Color','blue','LineWidth',2);

sigman = 2/(U*U)+eps*eps*(eps*U+3)/(3*(eps*U+1));


%for i=1:100
%    y(i) = 1/(sqrt(2*pi*sigman))*exp(-x(i)*x(i)/(2*sigman));
%end

y = normpdf(x,0,sqrt(sigman));

ci = 2*sqrt(sigman);

plot(x,y,'Color','green','LineWidth',2);
% line([ci ci],[0 2],'Color','red','LineWidth',2);
set(gca,'FontSize',16);
legend('BSVR','Gaussian');