function [ P ] = SampleMeas_LBCS(beta, Nq)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

%%global beta Nq

for j = 1 : Nq
    x = rand();
    sum = 0;
    for k = 1 : 3
       sum = sum + beta(j,k);
       if sum >= x
           P(j) = k;
           break;
       end
    end
end
end

