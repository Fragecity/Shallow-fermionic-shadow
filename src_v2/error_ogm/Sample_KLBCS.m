function [ v ] = Sample_KLBCS( observ,meas_buff, pr_mat, qNumper_set, phi )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% generate v = sum_j alpha_j f(P, Q^{(j)}, beta) mu(P, supp(Q^{(j)})), here
% f is a KLBCS. here qNumper_set is the number of the last qubits in this
% set, e.g. 111222333-->{3,6,9}

[K, Nq, len] = size(meas_buff);

m = size(observ, 1);

NumSet = length(qNumper_set); 

%%sample a measurement
for j = 1 : NumSet 
    P_Index(j) = SampleMeas_global(pr_mat(j,:)); %% indicate the label of the measurement.
    P = meas_buff(j, :,P_Index(j));
    if j == 1
        len_set_j = qNumper_set(j);
    else
        len_set_j = qNumper_set(j) - qNumper_set(j-1);
    end
    Sample_mu(j, :) = SampleResult(P, len_set_j, phi);
end

v = 0;
for t = 1 : m %observables
    f = 1;
    mu_final = 1;
    for j = 1 : NumSet %% NumSet blocks of qubits
        if j == 1
            start_index = 1;
        else
            start_index = qNumper_set(j-1)+1;
        end
        end_index = qNumper_set(j);
        Pauli = observ(t,start_index + 1: end_index + 1);
        if IsIdentity(Pauli)
            continue;
        elseif IfCommute(Pauli, meas_buff(j, :,P_Index(j))) %if the observ Q is agree with P
            Beta = 0; % compute beta(observ)
%             display(Pauli);
            for k = 1 : len
                if ~IsIdentity(meas_buff(j,:, k)) && IfCommute(Pauli, meas_buff(j,:, k))
                    Beta = Beta + pr_mat(j,k);
                end
            end
            if Beta == 0
                display(Pauli);
                break;
            end
            mu = 1;
            for k = start_index : end_index
                if observ(t,k+1) ~= 0
                    mu = mu * Sample_mu(j, k-start_index + 1);
                end
            end
            f = f * 1/Beta;
            mu_final = mu_final * mu;
        else
            f = 0;
            break;
        end
    end
    v = v + observ(t,1) * f * mu_final;
end

end

