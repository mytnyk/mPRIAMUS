
clear;


OLEa = load('./_res_/choppy_bec.dat');
MSEa = load('./_res_/choppy_mse.dat');
Xa = load('./_res_/choppy_eps.dat');
Ya = load('./_res_/choppy_bet.dat');

BECS = [-60 -50 -40 -20 0 20 50 70];
MSES = [0.026 0.028 0.030 0.032 0.034];

figure;
[C,h] = contour(Xa,Ya,OLEa, BECS);
colormap bone;

clabel(C,'manual');
%delete lines:
delete(findobj(gca,'Type','line'));
% set optimal point
%line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt-0.6 beta_opt+0.6],'Color','red','LineWidth',4);
%line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt+0.6 beta_opt-0.6],'Color','red','LineWidth',4);
% set good properties:
set(findobj('LineWidth',0.5),'LineWidth',2);
set(findobj('FontSize',10),'FontSize',24);
%set(gca,'FontSize',24,'XLim',[0.01 0.01+14*eps_step]);

figure;
[C,h] = contour(Xa,Ya,MSEa);%,MSES);
colormap bone;

clabel(C,'manual');
%delete lines:
delete(findobj(gca,'Type','line'));
% set optimal point
%line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt-0.6 beta_opt+0.6],'Color','red','LineWidth',4);
%line([eps_opt-0.3*eps_step eps_opt+0.3*eps_step],[beta_opt+0.6 beta_opt-0.6],'Color','red','LineWidth',4);
% set good properties:
set(findobj('LineWidth',0.5),'LineWidth',2);
set(findobj('FontSize',10),'FontSize',24);
%set(gca,'FontSize',24,'XLim',[0.01 0.01+14*eps_step]);

return;