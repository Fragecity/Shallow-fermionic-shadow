function [ v ] = Sample_Derandom(observ, measure, T_Final, Coord_phi)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here
% fixed P

%%global Nq observ m
[m, Nq] = size(observ);
Nq = Nq - 1;

T=size(measure,1);
% display(T);
if T <T_Final
    fprintf('Error, less than %d times.', T_Final);
    return;
end

T = T_Final;

for t = 1 : T
  % Sample_mu(t,:) = SampleResult(measure(t,:), Nq, phi); 
  Sample_mu(t,:) = SampleResult_Ground(measure(t,:), Nq, Coord_phi); 
end

v = 0;
for j = 1 : m
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
       v = v + mu_sum * 1/count * observ(j,1);
    end

end

end

