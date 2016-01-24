function []=supdrawsurf(comp,alpha,X,minX,maxX,Y,minY,maxY,Yest,nt,cfg,W,b)
%************************************
% written by Oleg Mytnyk, 2006
% last revision: 28.01.2006
% draw results
% input: nt - number of the test samples
%          cfg - full input configuration
%          X - full input
%          comp - component of X to display
%************************************

N=length(alpha)/2;
% create the image:

Ywithout_supp = [];
Ywith_supp = [];
Xwith_supp = [];
Xwithout_supp = [];

nos = 0;
nons = 0;
for i=1:N
    alpha1=alpha(i);
    alpha2=alpha(i+N);    
    if ((alpha1>0.000001) || (alpha2>0.000001)) % green squares
        nos=nos+1;
        Ywith_supp(nos) = Y(i);
        Xwith_supp(nos) = X(i,comp);
    else % yellow circles
        nons=nons+1;
        Ywithout_supp(nons) = Y(i);
        Xwithout_supp(nons) = X(i,comp);
    end;
end

%-------------surface picture------------------

n=20; % grid size
for i=1:n
    Xplain(i,1)=i/n;
end

cfg_reduction = zeros(1);
cfg_reduction(1,1)=cfg(comp,comp);

RMplain = bbernregr(Xplain,cfg_reduction);
Yplain=RMplain*W+b;


for j=1:n % scale back
    Xplain(j)=Xplain(j)*(maxX(comp)-minX(comp))+minX(comp);
end

Yplain =Yplain*(maxY-minY)+minY;

figure;    % begin new graphic object
hold on;   % all items on hold on the same figure

T_SPL = minX(comp):(maxX(comp)-minX(comp))/100:maxX(comp);
Y_SPL = spline(Xplain,Yplain,T_SPL);
plot(Xplain,Yplain,'o',T_SPL,Y_SPL,'LineWidth', 2,'Color', [0.00,0.50,0.50],'MarkerSize',1);

plot(Xwith_supp, Ywith_supp,'ks','MarkerSize',12,'MarkerEdgeColor','b','MarkerFaceColor','g');
plot(Xwithout_supp, Ywithout_supp,'ko','MarkerSize',12,'MarkerEdgeColor','b','MarkerFaceColor',[0.26,0.89,0.98]);
set(gca,'FontSize',20);
hold off;