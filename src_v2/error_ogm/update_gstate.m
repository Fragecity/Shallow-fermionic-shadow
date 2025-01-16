function [ Coord_new ] = update_gstate( mu,measure, Coord_phi, Nq )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
%   here if measure = 0, we use pauli-z to replace identity.
%   truncation of Coord_phi by reduce Nq--> Nq-1.

%%step1: get u_sample, an 1-qubit vector.
identity = eye(2,2);
if measure == 1
    u_sample = 1/sqrt(2)*[1;mu];
elseif measure == 2
    u_sample = 1/sqrt(2)*[1;1i * mu];
else
    u_sample = identity(:,floor(-1* mu/2+3/2)); %%f(1)=1,f(-1)=2.
% if measure = 0 , we let it be measured by Z basis.
%     pro_plus=1; %can be anything, it is useless.
%     return;
end

Coord_len = size(Coord_phi,1); %%number of non-zero baisis
%%calcuate |sum_{j} alpha_j <u_plus|j>|^2.
cur = 0;

for j = 1 : Coord_len
    alp_j = Coord_phi(j,2);
    firstQ = floor(Coord_phi(j,1)/2^(Nq-1));
    amplitude = alp_j * u_sample' * identity(:,firstQ+1);
 %   fprintf('%d: alp_%d = %f%+fj, firstQ is %d\n', j, Coord_phi(j,1), real(alp_j),imag(alp_j), firstQ);
    if amplitude ~= 0
        cur = cur + 1;
        basis_new = mod(Coord_phi(j,1),2^(Nq-1));
        Coord_new(cur,1) = basis_new;
        Coord_new(cur,2) = amplitude;
    end
end

len_new = cur;
cur = 0;
for j = 1 : len_new
    if Coord_new(j,1) == -1
        continue;
    end
    cur = cur + 1;
    Coord_phi(cur,1) = Coord_new(j,1);
    Coord_phi(cur,2) = Coord_new(j,2);
    for k = j+1 : len_new   
        if Coord_new(k, 1) == Coord_new(j,1)
            Coord_new(k, 1) = -1; %lable this basis has been visited.
            Coord_phi(cur, 2) = Coord_phi(cur,2) + Coord_new(k,2);
        end
    end
end
Coord_new = Coord_phi(1:cur,:);
%display(Coord_new);
end

