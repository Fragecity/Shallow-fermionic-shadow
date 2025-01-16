function [error] = Initial_error(observ, meas, len, phi)


 [m, Nq] = size(observ); 
 Nq = Nq - 1;
 
%% diagonal variance %% if there exists an observable Q, which has no rela
error = 0;
for j = 1 : m % observ(j)
    temp = 0;
    for k = 1 : len % meas(k)
        if IfCommute(observ(j,2:Nq+1),meas(:,k))
            temp = 1;
            break;
        end
    end
    if temp == 0
        error = error + observ(j,1) * TraceGlobal(phi, observ(j,2:Nq+1));
    end
end

end
