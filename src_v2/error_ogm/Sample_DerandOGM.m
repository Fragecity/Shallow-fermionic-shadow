function [v] = Sample_DerandOGM(observ, Nq, m_new, measure, T, Coord_phi)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   derandomize GBCS alg by choosing #P = T * pr.
%   At the start, we have observables observ, meaurements meas, the number
%   of qubits Nq, the number of observables m, the number of observables
%   len, and probability for each measurements
%   pr. Here we need to transpose measure to let it in coincidence with the
%   measure of Sample_Derandom.m
%   Output: estimate v after performing T times of sampling.

%global Nq observ
global phi

v=0;

if T <1
    display('Please input a iteration which is larger than 0.');
    return;
end


   
for t = 1 : T
%   Sample_mu(t,:) = SampleResult(measure(t,:), Nq, phi); 
   Sample_mu(t,:) = SampleResult_Ground(measure(t,:), Nq, Coord_phi); 
end


% T_minus = 0;
% acc = 0;
v = 0;
for j = 1 : m_new
   mu_sum = 0;
    count = 0;  
    for t = 1 : T
        P = measure(t,:);
        if IfCommute(observ(j,2:Nq+1), P)
            count = count + 1; % record the number of commuted observables.
            mu = 1;
            for k = 1 : Nq
                if observ(j,k+1) ~= 0
                    mu = mu * Sample_mu(t,k);
                end
            end
            mu_sum = mu_sum + mu;
        end
    end
    if count ~= 0
       v = v+ mu_sum * 1/count * observ(j,1);
    end
end

end

