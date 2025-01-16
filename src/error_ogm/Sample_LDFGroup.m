function v = Sample_LDFGroup(observ, meas, pr, Coord_phi)
% Summary of this function goes here
%   Detailed explanation goes here
% one sample of GBCS
% sampleRes: in {1,-1}^s, s<=m, is the measurement result.

global Belong
[m, Nq] = size(observ);
Nq = Nq - 1;

P_Index = SampleMeas_global(pr);
P = meas(:,P_Index);
%Sample_mu = SampleResult(P, Nq, phi);
Sample_mu = SampleResult_Ground(P, Nq, Coord_phi); %ground_state
%%compute variable v = sum_j alp_j f(P,Q^j, Beta) * mu(P, supp(Q^j)).

v = 0;
for j = 1 : m
   k = Belong(j);
   if k == P_Index
      f = 1/pr(k);
      mu = 1;
      for t = 1 : Nq
          if observ(j,t+1) ~= 0
              mu = mu * Sample_mu(t);
          end
      end
      if f ~= 0
        v = v + observ(j,1) * f * mu;
      end
   end
end


end
