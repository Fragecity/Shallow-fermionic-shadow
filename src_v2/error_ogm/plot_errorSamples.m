%plot the error of all of methods with the increasing of T


clear all;

% lbcs_f = 'LiH_12jw1_VAll_f.txt';
% ldfg_f = 'LiH_12jw2_VAll_f.txt';
% dHuang_f = 'LiH_12jw3_VAll_f.txt';
% dOGM_f = 'LiH_12jw4_VAll_f.txt';
% MOGM_f = 'LiH_12jw4_VAll_MultiPoints.txt';

% lbcs_f = 'LiH_12jw1_VAll_f.txt';
% ldfg_f = 'LiH_12jw2_VAll_f.txt';
% dHuang_f = 'LiH_12jw3_VAll_f.txt';
% dOGM_f = 'LiH_12jw4_VAll_f.txt';
% MOGM_f = 'LiH_12jw4_MultiPoints.txt';

lbcs_f = 'LiH_12jw1_VAll_f.txt';
ldfg_f = 'LiH_12jw2_VAll_f.txt';
dHuang_f = 'LiH_12jw3_VAll_f.txt';
dOGM_f = 'LiH_12jw4_VAll_f.txt';
MOGM_f = 'LiH_12jw4_MultiPoints.txt';

lbcs_data = load(lbcs_f);
ldfg_data = load(ldfg_f);
dHuang_data = load(dHuang_f);
dOGM_data = load(dOGM_f);
MOGM_data = load(MOGM_f);
%dOGM_sd = load(dOGM_s);

x_lbcs = lbcs_data(:,1);
y_lbcs = lbcs_data(:,2);


x_ldfg = ldfg_data(:,1);
y_ldfg = ldfg_data(:,2);

x_dHuang = dHuang_data(:,1);
y_dHuang = dHuang_data(:,2);

x_dOGM = dOGM_data(:,1);
y_dOGM = dOGM_data(:,2);

x_MOGM = MOGM_data(:,1);
y_MOGM = MOGM_data(:,2);

% y_lbcs = y_lbcs.^2 .* x_lbcs;
% y_ldfg = y_ldfg.^2 .* x_ldfg;
% y_dHuang = y_dHuang.^2 .* x_dHuang;
% y_dOGM = y_dOGM.^2 .* x_dOGM;



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
mar = strcat('--',marker(cur));
 loglog(x_ldfg, y_ldfg,mar,'LineWidth',2.5,'Color',colors(cur,:));
 cur = 3;
 mar = strcat(':',marker(cur));
 loglog(x_dHuang, y_dHuang,mar,'LineWidth',2.5,'Color',colors(cur,:));
%  cur = 4;
%  mar = strcat('-.',marker(cur));
%  loglog(x_dOGM, y_dOGM,mar,'LineWidth',2.5,'Color',colors(cur,:));
 cur = 4;
 mar = strcat('-.',marker(cur));
 loglog(x_MOGM, y_MOGM,mar,'LineWidth',2.5,'Color',colors(cur,:));
 
 
 %   cur = 5;
%  mar = strcat('-.',marker(cur));
%  loglog(x_dOGM, y_dOGMs,mar,'LineWidth',2.5,'Color',colors(cur,:));
 
 legend('LBCS','LDFGroup','DerandCS','OGM','location','southoutside','Orientation','horizontal');
 legend boxoff
 xlabel('T','fontsize',20);
 %ylabel('$$\varepsilon^2T$$','Interpreter','latex','fontsize',20);
 set(gca, 'LineWidth', 1.6, 'FontSize',18);
ylabel('$$|\bar{v}-tr(\rho \mathbf{O})|$$','Interpreter','latex','fontsize',20);
 
%legend('LBCS','OGM');