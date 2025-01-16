function [ P ] = normalization( P )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% normalization of P.

len = length(P);
sum = 0;
for j = 1 : len
    sum = sum + P(j);
end

for j = 1 : len
   P(j) = P(j)/sum; 
end


end

