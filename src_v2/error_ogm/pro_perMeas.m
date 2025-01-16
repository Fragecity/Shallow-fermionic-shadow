function [ pro_plus ] = pro_perMeas( measure, Coord_phi , Nq)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% output the probability of plus basis when measure phi with measure.
% Coord_phi(i,j) = [c1,c2], the coefficient of basis c1 is c2.
% measure in {0,1,2,3} represents {I,X,Y,Z}.

%%step1: get u_plus.
if measure == 1
    u_plus = 1/sqrt(2)*[1;1];
elseif measure == 2
    u_plus = 1/sqrt(2)*[1;1i];
else
    u_plus = [1;0];
% if measure = 0 , we let it be measured by Z basis.
%     pro_plus=1; %can be anything, it is useless.
%     return;
end

Coord_len = size(Coord_phi,1); %%number of non-zero baisis
%%calcuate |sum_{j} alpha_j <u_plus|j>|^2.
identity = eye(2,2);
pro_plus = 0;

for j = 1 : Coord_len
    CoordAfirst = floor(Coord_phi(j,1)/2^(Nq-1));
    CoordArest = mod(Coord_phi(j,1), 2^(Nq-1)); %%have revised***
    sum_a = Coord_phi(j,2)';
    sum_a = sum_a * identity(:,CoordAfirst+1)' * u_plus;
    sum_b = 0;
   for k = 1 : Coord_len
      CoordBfirst = floor(Coord_phi(k,1)/2^(Nq-1));
      CoordBrest = mod(Coord_phi(k,1), 2^(Nq -1));
      if CoordBrest == CoordArest
           sum_b = sum_b + Coord_phi(k,2)* u_plus' * identity(:,CoordBfirst + 1);
      end
   end
   pro_plus = pro_plus + sum_a * sum_b;
end

%display(pro_plus);
end

