function []=supdrawsurf(fc,sc,alpha,X,minX,maxX,Y,minY,maxY,Yest,nt,cfg,W,b)
%************************************
% written by Oleg Mytnyk, 2006
% last revision: 28.01.2006
% draw results
% input: nt - number of the test samples
%          cfg - full input configuration
%          X - full input
%          fc, sc - first and second components of X to display
%************************************

N=length(alpha)/2;
% create the image:

Ywithout_supp = [];
Ywith_supp = [];
X1with_supp = [];
X1without_supp = [];
X2with_supp = [];
X2without_supp = [];

nos = 0;
nons = 0;
for i=1:N
    alpha1=alpha(i);
    alpha2=alpha(i+N);    
    if ((alpha1>0.000001) || (alpha2>0.000001)) % green squares
        nos=nos+1;
        Ywith_supp(nos) = Y(i);
        X1with_supp(nos) = X(i,fc);
        X2with_supp(nos) = X(i,sc);        
    else % yellow circles
        nons=nons+1;
        Ywithout_supp(nons) = Y(i);
        X1without_supp(nons) = X(i,fc);
        X2without_supp(nons) = X(i,sc);        
    end;
end

%-------------surface picture------------------

n=20; % grid size
for i=1:n
    X1(i)=i/n;
    X2(i)=i/n;    
end

for i=1:n
    for j=1:n
        Xplain(j+n*(i-1), 1) = X1(i);
        Xplain(j+n*(i-1), 2) = X2(j);
    end
end
cfg_reduction = zeros(2);
cfg_reduction(1,2)=cfg(fc,sc);

RMplain = bbernregr(Xplain,cfg_reduction);
Yplain=RMplain*W+b;
for i=1:n
    for j=1:n
        k = Yplain(j+n*(i-1));
        k =k*(maxY-minY)+minY;
        Z(j,i)=k;
    end
end

for j=1:n % scale back
    X1(j)=X1(j)*(maxX(fc)-minX(fc))+minX(fc);
    X2(j)=X2(j)*(maxX(sc)-minX(sc))+minX(sc);    
end

figure;    % begin new graphic object
hold on;   % all items on hold on the same figure
surfl(X1,X2,Z);%,'FaceAlpha',0.5);
%grid on;
%shading interp
%colormap(gray);
%colormap(copper)
%colormap(cool)
colormap(spring);
view(100,35);

plot3(X1with_supp, X2with_supp, Ywith_supp,'ks','Color', [0.70,0.00,0.00],'MarkerFaceColor','g');
plot3(X1without_supp, X2without_supp, Ywithout_supp,'ko','Color', [0.70,0.00,0.00],'MarkerFaceColor',[0.26,0.89,0.98]);
hold off;