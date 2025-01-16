function [ phi ] = get_qstateGlobal(mole)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

file = 'ground_state/ground_state_';

% Open the file
file = strcat(file, mole);
file = strcat(file, '.txt');
%display(file);
%phi = load(file);

[fid, message] = fopen(file, 'rt');
if fid < 0
    error('Failed to open file "%s" because "%s"', filename, message); 
end
% Convert the cell array to a matrix of complex numbers
phi = cell2mat( textscan(fid, '%f') );

end

