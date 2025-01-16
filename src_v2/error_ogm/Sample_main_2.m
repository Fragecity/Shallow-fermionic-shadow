function [error] = Sample_main_2(x, mole, indice, T, Repeat)

global Nq m observ meas len phi pr



%prompt = 'Please input a number between 0 and 6 to represent the program you wish to execute.\n(0: GBCS; 1: LBCS; 2: grouping; 3: Derandomized alg for Huang et al; 4: Derandomized alg for GBCS;):\n';
str = 'Hamiltonian/';


file = strcat(mole,'.txt');
strF = strcat(str, file);


observ = load(strF);
[m,Nq] = size(observ);
Nq = Nq - 1;
%format = 'The number of photons: %d, the number of observables: %d';
%fprintf(format, Nq, m);


%%mole = input('Please input the molecule you want to use (the same as file name, e.g.:LiH_12jw)','s');
%% phi is obtained in get_qstateGlobal(mole)
phi = get_qstateGlobal(mole); %%mole = file (e.g.: LiH_12jw)
% phi = get_HarTree(mole);

%expect = energy(phi, observ); replace computing to read from file
str_energy = 'energy/ground_state_';
str_energy = strcat(str_energy, mole);
str_energy = strcat(str_energy, '.txt');
f_energy = fopen(str_energy,'r');
temp = fgetl(f_energy);
[energy_mole]= sscanf(temp,'%s %f');

str_LBCS = 'Set/LBCS_'; %%beta information

%expect = -28.3565
long_energy= length(energy_mole);
expect = energy_mole(long_energy);

str_GBCS = 'CutSet/OGM_';
if x == 4 %%for derandomized alg of GBCS.
    str_GBCS = 'CutSet/OGM_'; %% CutSet/GBCSV2_ or CutSet/GBCSV3_
    str_GBCS = strcat(str_GBCS, num2str(indice)); %%num2str(indice)
elseif x== 5
    str_GBCS = 'CutSet/OGMV2_'; 
    str_GBCS = strcat(str_GBCS, num2str(indice));
end





% if x == 3
%     NewFile_measP = 'Set_new/GBCSV1T_';
% elseif x == 4
%     NewFile_measP = 'Set_new/GBCSV1_';
% elseif x == 5
%     NewFile_measP = 'Set_new/GBCSV2_';
% end




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

if x == 1 %%LBCS
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
    return;
elseif x==2 %%Grouping
    LDFGroup(file,mole); %%get meas and pr here
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
    return;
elseif x==3 %%Derandomized_Huang.
    str_meas = 'Huang/Huang_';
    str_meas = strcat(str_meas, num2str(indice));
    str_meas = strcat(str_meas, '_');
    str_f = strcat(str_meas, file);
    
    measure = load(str_f);
    Ts=size(measure,1);
    re_meas = measure(:,1);
    measure = measure(:,2:Nq+1);
    meas_decom = zeros(T, Nq);
    k = 0;
    for t = 1 : Ts
        % Sample_mu(t,:) = SampleResult(measure(t,:), Nq, phi);
        for j = 1 : re_meas(t)
            k = k + 1;
            Sample_mu(k,:) = SampleResult_Ground(measure(t,:), Nq, Coord_phi);
            meas_decom(k,:) = measure(t,:);
        end
    end
    if k ~= T
       fprintf('Error where %d ne %d!\n',k,T); 
    end
    
    sum_err = 0;
    for k = 1 : Repeat
        v = Sample_Derandom(observ, meas_decom, T, Coord_phi);
        sum_err = sum_err + (v - expect)^2;
    end
    error = sqrt(sum_err/Repeat);
    return;
end


str_GBCS = strcat(str_GBCS, file);

measAndP = load(str_GBCS);


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
    rx = rand();
    amount = T * pr(s);
    if amount > 1
        NumMeas = floor(amount);
        if rx < mod(amount, NumMeas)
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
meas = meas(:,1:len);
pr = pr(1:len);
%%upadate pr
sum = 0;
for j = 1 : len
    sum = sum + pr(j);
end
for j = 1 : len
    pr(j) = pr(j)/sum;
end

%%save new meas to compute variance.

%NewFile_measP = strcat(NewFile_measP, file);

% save(NewFile_measP,'meas','pr','-ascii');
% ini_error = Initial_error(observ, meas, len, phi);
% fprintf('Molecule: %s, and ini_error: %f\n', mole, ini_error);

T = size(measure,1);
sum_err = 0;
for k = 1 : Repeat
    v = Sample_DerandGBCS(observ, Nq, m, measure, T, Coord_phi);
    % fprintf('%d-th round, with estimation %f.\n',k,v);
    %     fprintf('%d ',k);
    sum_err = sum_err + (v - expect)^2;
end
error = sqrt(sum_err/Repeat);
% fprintf(file_output, 'error: %f\n', error);
%timeElapsed = toc;

%fprintf('mole: %s, error %f, ini_error: %f\n', mole, error, ini_error);
%fprintf('\nmole: %s, error %f\n', mole, error);
%fprintf('indice = %d, T = %d, total run time: %f\n',indice, T, timeElapsed);

end

