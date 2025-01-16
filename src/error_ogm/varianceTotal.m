function var = varianceTotal()

global Nq observ meas len m pr phi expect
%global phi

var = 0; % initialization

for j = 1 : m-1 % only calculate the upper triangle, namely k > j, the k=j terms are included in variance(pr)
    for k = j+1 : m
        if abs(cal_decide(j,k)) > 0.5 % if we need to calculate at all
            temp_j = 0;
            temp_k = 0;
            temp_n = 0; %numerator
            temp_d = 0; %denominator
            for i = 1 : len % the number of measurements
                flag_1 = 0;
                flag_2 = 0;
                if IfCommute(observ(j, 2:Nq+1), meas(:,i))
                    temp_j = temp_j + pr(i);
                    flag_1 = 1;
                end
                if IfCommute(observ(k, 2:Nq+1), meas(:,i))
                    temp_k = temp_k + pr(i);
                    flag_2 = 1;
                end
                if flag_1 == 1 && flag_2 == 1
                    temp_n = temp_n + pr(i);
                end
            end
            temp_d = temp_j * temp_k;
            %    var = var + observ(j,1)*observ(k,1)*temp_n/temp_d * phi' * MulMatRep(observ(j,2:Nq+1),observ(k,2:Nq+1)) * phi;
            mul = MulVector(observ(j,2:Nq+1), observ(k,2:Nq+1));
            %  trace = TraceLocal(mul); %trace for Hartree fork state
            %  trace = TraceGHZ(mul);

            if temp_d == 0
                %fprintf('The %d-th is %f, the %d-th is %f\n', j,temp_j, k, temp_k);
            else
              trace = TraceGlobal(phi, mul); 
              var = var + observ(j,1) * observ(k,1) * temp_n/temp_d * trace;
            end
        end
    end
    fprintf('\nRound %d of %d', j,m-1);
end

%var = 2*var;
%var = var + variance(pr);
diag_var = variance(pr);
var = 2 * var +  diag_var;
fprintf('diag_var is %d', diag_var);


%trace = 0;
%for j = 1 : m
  %  trace = trace + observ(j,1) * TraceGHZ(observ(j, 2: Nq+1)); %% for ghz state
 % trace = trace + observ(j,1) * TraceLocal(observ(j, 2: Nq+1)); %trace for local
  %trace = trace + observ(j,1) * TraceGlobal(phi, observ(j, 2: Nq+1)); 
%end
% change trace into energy.(Read from file.)

var = var - expect^2;
end