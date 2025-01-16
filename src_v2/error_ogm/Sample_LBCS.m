function [ v ] = Sample_LBCS(observ, beta, Coord_phi)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
%global phi %it's for Hartreefork state.
%%global Nq m observ beta
[m, Nq] = size(observ);
Nq = Nq - 1;

P = SampleMeas_LBCS(beta, Nq);
%%Sample_mu = SampleResult(P, Nq, phi);
Sample_mu = SampleResult_Ground(P, Nq, Coord_phi);
% display(P);
% display(Sample_mu);
v = 0;
for j = 1 : m
    cost = 1;
    mu = 1;
    for k = 1 : Nq %%compute beta(Q^j)
        pauli = observ(j, k+1);
        if pauli == 0
            continue;
        elseif P(k) == pauli
            cost = cost * beta(k,pauli);
            mu = mu * Sample_mu(k);
        else
            mu = 0;
            break;
        end
    end%for
    v = v + observ(j,1) * 1/cost * mu;
%     display(j);
%     display(cost);
%     display(mu);
end

end

