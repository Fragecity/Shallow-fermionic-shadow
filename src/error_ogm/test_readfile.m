% Read the data from the text file
filename = 'ground_state/ground_state_SlaterHa_8.txt';

% Convert the data to complex numbers
%[filename, pathname] = uigetfile;

[fid, message] = fopen(filename, 'rt');
if fid < 0
    error('Failed to open file "%s" because "%s"', filename, message); 
end

complex_data = cell2mat( textscan(fid, '%f') );

fclose(fid);

% Display the complex data
disp(length(complex_data));
