function [ res ] = IsIdentity(Pauli)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% judge whether Pauli is equal to identity or not.

len = length(Pauli);
res = true;
for j = 1 : len
    if Pauli(j) ~= 0
       res =  false;
       return;
    end
end

end

