function [ini_error] = Error_Inialize(x, file)
% addpath(genpath('./'));

global Nq m observ meas len phi pr beta

T = 1000;
Repeat = 20;

%prompt = 'Please input a number between 0 and 6 to represent the program you wish to execute.\n(0: GBCS; 1: LBCS; 2: grouping; 3: Derandomized alg for Huang et al; 4: Derandomized alg for GBCS;):\n';
str = 'Hamiltonian/';
str_LBCS = 'Set/LBCS_'; %%beta information
str_GBCS = 'CutSet/GBCS_'; %% CutSet/GBCSV2_ or CutSet/GBCSV3_
str_KLBCS_f = 'measurement/';
str_KLBCS2 = 'measurement/H2O_14jw/7-local/[1,1,1,1,1,1,1,2,2,2,2,2,2,2]/matlab.mat';
%x = input(prompt); %%x in {0,1,2,3,4,5} 5: Under construction

%file = input('Please input the file you want to sample.(e.g.: H2_4jw)\n','s');
mole = file;
str_KLBCS_e = strcat(file,'.mat');
file = strcat(file,'.txt');
strF = strcat(str, file);

observ = load(strF);
[m,Nq] = size(observ);
Nq = Nq - 1;
format = 'The number of photons: %d, the number of observables: %d';
fprintf(format, Nq, m);
display(strF);

%%mole = input('Please input the molecule you want to use (the same as file name, e.g.:LiH_12jw)','s');
%% phi is obtained in get_qstateGlobal(mole)
phi = get_qstateGlobal(mole); %%mole = file (e.g.: LiH_12jw)
% phi = get_HarTree(mole);
d = length(phi);

%expect = energy(phi, observ); replace computing to read from file
str_energy = 'energy/ground_state_';
str_energy = strcat(str_energy, mole);
str_energy = strcat(str_energy, '.txt');
f_energy = fopen(str_energy,'r');
temp = fgetl(f_energy);
[energy_mole]= sscanf(temp,'%s %f');
%expect = -28.3565
long_energy= length(energy_mole);
expect = energy_mole(long_energy);
fprintf('Expectation is %f\n',expect);

v_temp = 0;
 tic
 
if x == 0 %GBCS
   str_GBCS = strcat(str_GBCS, file);
   display(str_GBCS);
   measAndP = load(str_GBCS); 
    [len] = size(measAndP,2);
    meas = measAndP(1:Nq,:);
    pr = measAndP(Nq + 1, :);
    sum_err = 0;
    for k = 1 : Repeat
        v_temp = 0;
        for j = 1 : T
            v_temp = v_temp + Sample_GBCS(observ, meas, pr, phi);
        end
        v = v_temp/T;
        display(k);
        display(v);
        sum_err = sum_err + (v - expect)^2;
    end
    error = sqrt(sum_err/Repeat);
elseif x == 1 %%LBCS
    %     main_LBCS(file, mole);
    k  = 0;
    dimension = length(phi);
    for j = 1 : dimension
        if phi(j) ~= 0
            k = k + 1;
            Coord_phi(k,1) = j-1; %%s: contains all of elements with non-zero values, start from 0-->0...0
            Coord_phi(k,2) = phi(j);
        end
    end
    str_LBCS = strcat(str_LBCS, file);
    beta = load(str_LBCS);
    %display(beta);
    sum_err = 0;
    for k = 1 : Repeat
        v_temp = 0;
        for j = 1 : T
            v_temp = v_temp + Sample_LBCS(observ, beta, Coord_phi);
        end
        v = v_temp/T;
        sum_err = sum_err + (v - expect)^2;
    end
    error = sqrt(sum_err/Repeat);
elseif x==2 %%Grouping
    LDFGroup(file); %%get meas and pr here
    k  = 0;
    dimension = length(phi);
    for j = 1 : dimension
        if phi(j) ~= 0
            k = k + 1;
            Coord_phi(k,1) = j-1; %%s: contains all of elements with non-zero values, start from 0-->0...0
            Coord_phi(k,2) = phi(j);
        end
    end
    sum_err = 0;
    for k = 1 : Repeat
        v_temp = 0;
        for j = 1 : T
            v_temp = v_temp + Sample_LDFGroup(observ, meas, pr, Coord_phi);
        end
        v = v_temp/T;
%         display(v);
        sum_err = sum_err + (v - expect)^2;
    end
    error = sqrt(sum_err/Repeat);
elseif x==3 %%Derandomized_Huang.
    str_meas = 'HuangObservable/';
%     phi = zeros(1,2^4);
%     phi(1) = 1/sqrt(2);
%     phi(16) = 1/sqrt(2);
%     display(phi);
%     expect = energy(phi, observ);
%     display(expect);
    str_f = strcat(str_meas, file);
    measure = load(str_f);
    k  = 0;
    dimension = length(phi);
    for j = 1 : dimension
        if phi(j) ~= 0
            k = k + 1;
            Coord_phi(k,1) = j-1; %%s: contains all of elements with non-zero values, start from 0-->0...0
            Coord_phi(k,2) = phi(j);
        end
    end
    sum_err = 0;
    for k = 1 : Repeat
        v = Sample_Derandom(observ, measure, T, Coord_phi);
        fprintf('%d-th round, with estimation %f\n',k,v);
        sum_err = sum_err + (v - expect)^2;
    end
    error = sqrt(sum_err/Repeat);
elseif x == 4 %%for derandomized alg of GBCS.
    str_GBCS = strcat(str_GBCS, file);
    display(str_GBCS);
    measAndP = load(str_GBCS); 
    
    %%% convert phi to s, where Coord_phi_t = j represents the j-th coordinate equals 1.
    k  = 0;
    dimension = length(phi);
    for j = 1 : dimension
        if phi(j) ~= 0
            k = k + 1;
            Coord_phi(k,1) = j-1; %%s: contains all of elements with non-zero values, start from 0-->0...0
            Coord_phi(k,2) = phi(j);
        end
    end
    %%Sorting the meas and pr.
    measAndP = sort_meas(measAndP);
    len = size(measAndP,2);
    meas = measAndP(1:Nq,:);
    pr = measAndP(Nq + 1,:);
    j = 0;
    s = 0; 
    while j < T
        if s == len
            break; 
        end
        s = s + 1;
       % NumMeas = ceil(T * pr(s));
        x = rand();
        amount = T * pr(s);
        if amount > 1
            NumMeas = floor(amount);
            if x < mod(amount, NumMeas)
                NumMeas = NumMeas + 1;
            end
        else
            NumMeas = 1;
        end
        for k = 1 : NumMeas
            j = j + 1;
            measure(j,:) = meas(:,s).';
            if j>= T
                break;
            end
        end
    end
    len = s;
    display(len);
    meas = meas(:,1:len);

    ini_error = Initial_error(observ, meas, len, phi);
    display(ini_error);
    
%     T = size(measure,1);
%     display(T);
%     sum_err = 0;
%     for k = 1 : Repeat
%         v = Sample_DerandGBCS(observ, Nq, m, measure, T, Coord_phi);
%         fprintf('%d-th round, with estimation %f\n',k,v);
%         sum_err = sum_err + (v - expect)^2;
%     end
%     error = sqrt(sum_err/Repeat);
%     for Repeat_ite = 51 : 60
%         sum_err = 0;
%         Repeat = Repeat_ite * 2;
%         for k = 1 : Repeat
%             v = Sample_DerandGBCS(observ, Nq, m, measure, T, Coord_phi);
%             %  fprintf('%d-th round, with estimation %f\n',k,v);
%             sum_err = sum_err + (v - expect)^2;
%         end
%         error(Repeat_ite) = sqrt(sum_err/Repeat);
%         fprintf('%d: %f\n',Repeat, error(Repeat_ite));
%     end

elseif x == 5 %%klbcs: using derandomized-GBCS method to sample.
end


timeElapsed = toc

end
