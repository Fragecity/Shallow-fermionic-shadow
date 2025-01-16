function [ expect ] = expectation_HarTree(observ)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
[m, Nq] = size(observ);
Nq = Nq - 1;

expect = 0;
for j = 1 : m
   tr = TraceLocal(observ(j,2:Nq+1));
   expect = expect + tr * observ(j, 1);
end

end

