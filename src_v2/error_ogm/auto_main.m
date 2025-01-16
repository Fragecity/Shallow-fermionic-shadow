
clear all;

global Nq m observ

errAll = zeros(1,10);

mole = 'BeH2_14bk';%'H2_8jw', 'H2O_14jw';
Repeat = 20;
x = 7; % x =1: LBCS, x=2:Grouping, x=3:Derandomized_Huang, x =4:for derandomized alg of OGM, x = 5: zijianAlg.
%%%x = 6 , 7 %%PanfenML
out_file = strcat(mole, num2str(x));
out_file = strcat(out_file, '_VAll.txt');
fq = fopen(out_file,'w+');

str = 'Hamiltonian/';


file = strcat(mole,'.txt');
strF = strcat(str, file);
observ = load(strF);
[m,Nq] = size(observ);
Nq = Nq - 1;

%phi = get_qstateGlobal(mole); %%mole = file (e.g.: LiH_12jw)
%expect = energy(phi, observ); 
%fprintf('Nq: %d, m:%d, energy: %f\n',Nq, m, expect);
indice = 2;
T = 1000;
%for indice = 2 : 9
%%%    T = floor( exp(1.27 * indice));
  % T = 1000;
    start = tic;
    errAll(indice-1) = Sample_main(x, mole, indice, T, Repeat);%'H2O_14jw'
    time = toc(start);
    fprintf(fq, '%d %f\n',T, errAll(indice-1)); 
    fprintf('（%d-%d) %d %f, time=%.2fh\n',x,indice, T, errAll(indice-1), time/3600);
%end




% Sample_main(4,'H2_4jw');
% clear all;
% Sample_main(4,'H2_4bk');
% clear all;
% Sample_main(4,'H2_4parity');
% clear all;
% Sample_main(4,'H2_8jw');
% clear all;
% Sample_main(4,'H2_8bk');
% clear all;
% Sample_main(4,'H2_8parity');
% clear all;
% Sample_main(4,'LiH_12jw');
% clear all;
% Sample_main(4,'LiH_12bk');
% clear all;
% Sample_main(4,'LiH_12parity');
% clear all;
% Sample_main(4,'BeH2_14jw');
% clear all;
% Sample_main(4,'BeH2_14bk');
% clear all;
% Sample_main(4,'BeH2_14parity');
% clear all;
% Sample_main(3,'H2O_14jw');
% clear all;
% Sample_main(4,'NH3_16bk');
% clear all;
% Sample_main(4,'NH3_16parity');
% clear all;
% Sample_main(4,'H2O_14parity');
% clear all;
% Sample_main(5,'H2O_14bk');
% clear all;
% Sample_main(5,'H2O_14parity');
