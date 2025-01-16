function [ num ] = ToNum( vector )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

num = 0;
for k = 1 : length(vector)
    num = num + vector(k) * 2^(length(vector) - k);
end

% num = num + 1;
end
