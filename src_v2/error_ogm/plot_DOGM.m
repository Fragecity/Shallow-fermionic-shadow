clear all;

lbcs_f = 'BeH2_14jw4_VAll_f.txt';
 
 lbcs_data = load(lbcs_f);
 x_lbcs = lbcs_data(:,1);
y_lbcs = lbcs_data(:,2);
y_lbcs = y_lbcs.^2 .* x_lbcs;


 dOGM_f = 'BeH2_14jw4_VAll_gitR1.txt';
 dOGM_data = load(dOGM_f);
 x_dOGM = dOGM_data(:,1);
y_dOGM = dOGM_data(:,2);

y_dOGM = y_dOGM.^2 .* x_dOGM;


marker = ['o','s','d','v','+','*','x','>','<','p','h',...
    'o','+','*','x','s','d','v','>','<','p','h',...
    'o','+','*','x','s','d','v','>','<','p','h'];
colors = [	20/256,150/256,155/256;0.9290, 0.6940, 0.1250;0.9,0.1,143/255;
    0.35,0.45,0.65;0.2,0.8,0.8];

box on
cur = 1;
mar = strcat('-.',marker(cur));
 loglog(x_lbcs, y_lbcs,mar,'LineWidth',2.5,'Color',colors(cur,:));
hold on
 cur = 2;
 mar = strcat('-.',marker(cur));

 loglog(x_dOGM(1:length(x_dOGM)), y_dOGM(1:length(x_dOGM)),mar,'LineWidth',2.5,'Color',colors(cur,:));
 
 
  legend('OGM','OGM_git','location','southoutside','Orientation','horizontal');
 legend boxoff
 xlabel('T','fontsize',20);
 ylabel('$$\varepsilon^2T$$','Interpreter','latex','fontsize',20);
 set(gca, 'LineWidth', 1.6, 'FontSize',18);