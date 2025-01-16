function [ P_Index ] = SampleMeas_global(pr)
%Summary of this function goes here
%   Detailed explanation goes here
% sample a P from measurements {P} with probability p

%%global len pr

len = length(pr);

x = rand();
P_Index = 0;
sum = 0;
for j = 1 : len
    sum = sum + pr(j);
    if sum >= x
        P_Index = j;
        return;
    end
end
end