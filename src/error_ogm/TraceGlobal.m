function [trace] = TraceGlobal(phi, Q)
%% TRACEGLOBAL calculate tr(|phi><phi|Q) = <phi|Q|phi>
% For an 2^Nq-dim'l |phi>, we first extract the nonzero entries in
% computational basis, and then compute the inner products.
% to compute <phi|Q|phi>, we need to call 'TraceLocalGen' to calculate <j|Q|l>

dimension = length(phi);

Nq = floor(log2(dimension));

if Nq ~= length(Q)
   disp('The qubits of the input state does not match the dimension of Q.\n');
   return;
end


coeff = 1; % to extract the overall coefficient
reQ = zeros(1,Nq); % to extract the plain
for qubit = 1:Nq
    if abs(Q(qubit)) > 0
        reQ(qubit) = floor(abs(Q(qubit)));
        coeff = coeff * Q(qubit) / reQ(qubit);
    end
end


k = 0;
for j = 1 : dimension
    if phi(j) ~= 0
        k = k + 1;
        s(k) = j; %%s: contains all of elements with non-zero values.
    end
end

X = reQ==1;
Y = reQ==2;
filter = X+Y;% if reQ(i) = 0 or 3, filter(i) = 0; if reQ(i) = 1 or 2, filter(i) = 1

if sum(filter) > 0 % only the off-diagonal terms
    trace = 0;
    for j = 1 : k
        target = ToNum(mod(filter + ToBinary(s(j)-1,Nq), 2)) + 1;
        if ~isempty(find(s==target))
            trace = trace + real(phi(s(j))' * phi(target) * TraceLocalGen(s(j),target,Q));
        end
    end

else % only the diagonal terms
    trace = 0;
    for j = 1 : k
        trace = trace + phi(s(j))' * phi(s(j)) * TraceLocalGen(s(j),s(j),Q); %<j|Q|l>
    end
end

end

