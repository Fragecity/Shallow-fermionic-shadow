function [ Sample_mu ] =SampleResult_Complex (P, Nq, Coord_phi)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%% return a vector with dimension Nq, which represents the choice of measurements of each qubit.

I = eye(2);
X = [0 1; 1 0];
Y = [0 -i; i 0];
Z = [1 0; 0 -1];

H = [1 1; 1 -1]/sqrt(2);
S = [1 0; 0 i];

UY = S'* H;

for k = 1 :Nq
    

for k = 1 : Nq
   % fprintf('-------------Now we are in the %d-th qubit.----------\n',k);

    x = rand();
    if x <= pro_meas(1)
        Sample_mu(k) = 1; % measurement is 1.
    else
        Sample_mu(k) = -1;% measurement is -1.
    end

end

end

