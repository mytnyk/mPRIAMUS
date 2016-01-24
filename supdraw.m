function []=supdraw(alpha,Y,Yest,eps,nt,Confid,compData)
%************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 2.01.2007
% draw results
% input: nt - number of the test samples
%        compData - alernative results
%************************************

N=length(alpha)/2;
% create the image:
Twithout_supp = [];
Ywithout_supp = [];
DeltaYwithout_supp = [];
Twith_supp = [];
Ywith_supp = [];
DeltaYwith_supp = [];

nos = 0;
nons = 0;
for i=1:N
    alpha1=alpha(i);
    alpha2=alpha(i+N);    
    if ((alpha1>0.000001) | (alpha2>0.000001)) % green squares
        nos=nos+1;
        Twith_supp(nos)=i;
        Ywith_supp(nos) = Y(i);
        DeltaYwith_supp(nos) = Y(i)-Yest(i);        
    else % yellow circles
        nons=nons+1;
        Twithout_supp(nons) = i;
        Ywithout_supp(nons) = Y(i);
        DeltaYwithout_supp(nons) = Y(i)-Yest(i);
    end;
end


figure;    % begin new graphic object
hold on;   % all items on hold on the same figure
pbaspect([2 1 1]);

n=length(Yest);

T=1:n;
T_SPL = 1:0.1:n;

%-------------confidence area------------------
Confid_SPL = spline(T,Confid,T_SPL);
Yest_SPL = spline(T,Yest,T_SPL);
n_spl = length(T_SPL);

for i=1:n_spl
    XX(i) = T_SPL(i);
    YY(i) = Yest_SPL(i)+Confid_SPL(i);
end
for i=1:n_spl
    XX(i+n_spl) = T_SPL(n_spl+1 - i);
    YY(i+n_spl) = Yest_SPL(n_spl+1 - i)-Confid_SPL(n_spl+1 - i);
end

fill(XX,YY,[0.80,0.80,0.80],'EdgeColor', 'none');

%-------------epsilon tube------------------
gray = 0;

Yest_SPL = spline(T,Yest,T_SPL);
if (gray == 1) % draw in gray
%    plot(T,Yest+eps,'o', T_SPL,Yest_SPL+eps,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);
%    plot(T,Yest-eps,'o', T_SPL,Yest_SPL-eps,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);%[0.46,0.39,0.04]
else
%     plot(T,Yest+eps,'o', T_SPL,Yest_SPL+eps,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);
%     plot(T,Yest-eps,'o', T_SPL,Yest_SPL-eps,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);%[0.46,0.39,0.04]
end

%-------------original picture------------------
Y_SPL = spline(T,Y,T_SPL);

if (gray == 1) % draw in gray
    plot(T,Y,'o',T_SPL,Y_SPL,'LineWidth', 1,'Color', [0.00,0.00,0.00],'MarkerSize',1);
    plot(Twith_supp,Ywith_supp,'ks', 'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor',[0.80,0.80,0.80]);
%    plot(Twithout_supp,Ywithout_supp,'ko', 'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor',[0.26,0.89,0.98]);
else
    plot(T,Y,'o',T_SPL,Y_SPL,'LineWidth', 1,'Color', [0.00,0.50,0.50],'MarkerSize',1);
    plot(Twith_supp,Ywith_supp,'ks', 'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor','g');
    plot(Twithout_supp,Ywithout_supp,'ko', 'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor',[0.26,0.89,0.98]);
end

%-------------estimated picture------------------
YestL=Yest(1:n-nt);
if (gray == 1) % draw in gray
    plot(T,Yest,'o',T_SPL,Yest_SPL,'LineWidth', 1,'Color',[0.00,0.00,0.00],'MarkerSize',1);
    plot(Yest,'ko', 'MarkerSize',5,'MarkerEdgeColor',[0.00,0.00,0.00],'MarkerFaceColor','w');
%    plot(YestL,'o', 'MarkerSize',5,'MarkerEdgeColor',[0.20,0.20,0.20],'MarkerFaceColor','w');
else
    plot(T,Yest,'o',T_SPL,Yest_SPL,'LineWidth', 1,'Color',[0.73,0.00,0.00],'MarkerSize',1);
    plot(Yest,'o', 'MarkerSize',4,'MarkerEdgeColor',[0.50,0.00,1.00],'MarkerFaceColor','w');%[1.00,0.02,0.02];[0.50,0.00,1.00]
    plot(YestL,'o', 'MarkerSize',4,'MarkerEdgeColor',[0.73,0.00,0.00],'MarkerFaceColor','y');%[1.00,0.50,0.00]
end

hold off;


%-------------residual picture------------------

figure;    % begin new graphic object
hold on;   % all items on hold on the same figure
pbaspect([2 1 1]);

% epsilon insensative lines:
EPS = eps*ones(n,1);
EPS_SPL = spline(T,EPS,T_SPL);
plot(T,EPS,'o',T_SPL,EPS_SPL,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);
plot(T,-EPS,'o',T_SPL,-EPS_SPL,'Color',[0.75,0.75,0.75],'LineWidth', 1,'MarkerSize',1);%[0.46,0.39,0.04]

% alternative result:
if compData
    Yalter = load(compData);
    colors=[[1.00 0.00 0.50]; [0.00 0.00 1.00]; [0.00 0.00 0.00]];
    [n,ma] = size(Yalter);
    for i=1:ma
        YalterCurr = Yalter(:,i);
        for j=1:n
            if YalterCurr(j)~=0
                break;
            end
        end
        Tc=j:n;
        Tc_SPL = j:0.1:n;
        Yorig = Y(j:n);    
        Yorig_SPL = spline(Tc,Yorig,Tc_SPL);
        YalterCurr = YalterCurr(j:n);
        Yalter_SPL = spline(Tc,YalterCurr,Tc_SPL);
        plot(Tc,Yorig-YalterCurr,'o',Tc_SPL,Yorig_SPL-Yalter_SPL,'LineWidth', 1,'Color', colors(i,:),'MarkerSize',1);
    end
end

% TISMA result:
plot(T,Y-Yest,'o',T_SPL,Y_SPL-Yest_SPL,'LineWidth', 1,'Color', [0.00,0.50,0.50],'MarkerSize',1);
plot(Twith_supp,DeltaYwith_supp,'ks', 'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor','g');
plot(Twithout_supp,DeltaYwithout_supp,'ko', 'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor',[0.26,0.89,0.98]);



hold off;