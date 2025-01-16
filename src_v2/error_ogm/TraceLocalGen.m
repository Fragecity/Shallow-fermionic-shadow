function [ inner ] = TraceLocalGen(j,l, mat)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% LocalTrace = <j|mat|l>, note here j and l is in {1..2^Nq} and hence we
% need to minus 1.
% we need to call ToBinary to convert a number to a bitstring.

Nq = length(mat);
j = j - 1;
l = l - 1;

Vector_j = ToBinary(j,Nq);
Vector_l = ToBinary(l,Nq);
psi = [1 0; 0 1];
A(:,:,1) = [0 1; 1 0]; %X
A(:,:,2) = [0 -i;i 0]; %Y
A(:,:,3) = [1 0; 0 -1]; %Z
A(:,:,4) = eye(2); %I

inner = 1;

for k = 1 : Nq
    if mat(k) == 0
       mat(k) = 4; 
    end
    temp = abs(mat(k));
    inner = inner * psi(:, Vector_j(k)+1)' * mat(k)/temp * A(:,:,temp) * psi(:, Vector_l(k)+1); %%<j_k |mat_k|l_k>
    if inner == 0
        break;
    end
end


end

