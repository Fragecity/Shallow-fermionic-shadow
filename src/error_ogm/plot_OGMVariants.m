%plot the error of all of methods with the increasing of T


clear all;


derand_f = 'BeH2_14jw3_VAll_f.txt';
dOGM_f = 'BeH2_14jw4_VAll_f.txt';
MOGM_f = 'BeH2_14jw4_MultiPoints.txt';


derand_data = load(derand_f);
dOGM_data = load(dOGM_f);
MOGM_data = load(MOGM_f);

x_derand = derand_data(:,1);
y_derand = derand_data(:,2);

x_dOGM = dOGM_data(:,1);
y_dOGM = dOGM_data(:,2);


x_MOGM = MOGM_data(:,1);
y_MOGM = MOGM_data(:,2);

marker = ['o','s','d','v','+','*','x','>','<','p','h',...
    'o','+','*','x','s','d','v','>','<','p','h',...
    'o','+','*','x','s','d','v','>','<','p','h'];
colors = [	20/256,150/256,155/256;0.9290, 0.6940, 0.1250;0.9,0.1,143/255;
    0.35,0.45,0.65;0.2,0.8,0.8];

box on




 cur = 3;
 mar = strcat('-.',marker(cur));
 loglog(x_derand, y_derand,mar,'LineWidth',2.5,'Color',colors(cur,:));
 hold on 
 
 cur = 4;
 mar = strcat('-.',marker(cur));
 loglog(x_dOGM, y_dOGM,mar,'LineWidth',2.5,'Color',colors(cur,:));

 cur = 5;
 mar = strcat('-.',marker(cur));
 loglog(x_MOGM, y_MOGM,mar,'LineWidth',2.5,'Color',colors(cur,:));
 
% legend('LBCS','LDFGroup','DerandHuang','OGM','location','southoutside','Orientation','horizontal');
  legend('Derand','OGM','MulOGM','location','southoutside','Orientation','horizontal');
 
 legend boxoff
 xlabel('T','fontsize',20);
 %ylabel('$$\varepsilon^2T$$','Interpreter','latex','fontsize',20);
 set(gca, 'LineWidth', 1.6, 'FontSize',18);
ylabel('$$|\bar{v}-tr(\rho \mathbf{O})|$$','Interpreter','latex','fontsize',20);
 
%legend('LBCS','OGM');