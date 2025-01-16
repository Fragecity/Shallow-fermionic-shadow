function v = Sample_GBCS(observ, meas, pr, phi)
% Summary of this function goes here
%   Detailed explanation goes here
% one sample of GBCS
% sampleRes: in {1,-1}^s, s<=m, is the measurement result.

%%global meas Nq m observ len pr

[m, Nq] = size(observ);
Nq = Nq - 1;
len = size(meas, 2);

P_Index = SampleMeas_global(pr);

P = meas(:,P_Index);
Sample_mu = SampleResult(P, Nq, phi);

% display(P_Index);
% display(P);
% display(Sample_mu);
%%compute variable v = sum_j alp_j f(P,Q^j, Beta) * mu(P, supp(Q^j)).

v = 0;
for j = 1 : m
    if IfCommute(observ(j,2:Nq+1), P)
        Beta = 0;
        for k = 1 : len %%compute Beta(Q^j)
            if IfCommute(observ(j, 2:Nq+1), meas(:,k))
               Beta = Beta + pr(k);
            end
        end%for
        if Beta == 0 %avoid an observable which does not come up.
            continue;
        end
        mu = 1;
        for k = 1 : Nq
           if observ(j,k+1) ~= 0
               mu = mu * Sample_mu(k);
           end
        end
        v = v + observ(j,1) * 1/Beta * mu;
    end
end

%display(v);
end
