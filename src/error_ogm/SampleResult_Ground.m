function [ Sample_mu ] =SampleResult_Ground (P, Nq, Coord_phi)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%% return a vector with dimension Nq, which represents the choice of measurements of each qubit.


for k = 1 : Nq
   % fprintf('-------------Now we are in the %d-th qubit.----------\n',k);
    pro_meas(1) = pro_perMeas(P(k), Coord_phi, Nq-k + 1); %%+1
    pro_meas(2) = 1 - pro_meas(1); %%-1
    x = rand();
    if x <= pro_meas(1)
        Sample_mu(k) = 1; % measurement is 1.
    else
        Sample_mu(k) = -1;% measurement is -1.
    end
    if k == Nq
        break; % we do not need to update the last qubit.
    end
    Coord_phi = update_gstate(Sample_mu(k), P(k), Coord_phi, Nq - k + 1);
    temp = floor((-1 *Sample_mu(k) + 3)/2); %f(1) = 1;f(-1) = 2.
    Coord_phi(:,2) = Coord_phi(:,2)/sqrt(pro_meas(temp)); %phi_new = M * phi/sqrt(pr(M));
end

end

