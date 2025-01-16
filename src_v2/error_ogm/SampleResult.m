function [ Sample_mu ] = SampleResult( P, Nq, phi)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Given distribution P, output a Nq string Sample_mu in {1,-1}^Nq, to represent the outcomes of the measurement P.
%%global Nq phi
%% return a vector with dimension Nq, which represents the choice of measurements of each qubit.

Sample_mu = zeros(1,Nq);
for j = 1 : Nq
   if P(j) == 0
       continue;
   end
  %% sample_mu(j) = 2 * random([1,2])-3;  %% the results only holds for classical input.
  if P(j) == 3 %Z-basis
     	Sample_mu(j) = 1 - 2 * phi(j);
  else %X, or Y basis
        Sample_mu(j) = 1 - 2 * randi([0,1],1,1);
   end
end

end

