function [ vector ] = ToBinary( j, Nq )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


for k = 1 : Nq
    vector(Nq - k + 1) = mod(j,2);
    j = floor(j/2);
end

end
