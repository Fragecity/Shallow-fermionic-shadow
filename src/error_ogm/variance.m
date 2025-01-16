function [var] = variance(pr)

global Nq observ meas len m 


%% diagonal variance
%  namely, only doing the diagonal sum
var = 0;
for j = 1 : m % observ(j)
    temp = 0;
    for k = 1 : len % meas(k)
        if IfCommute(observ(j,2:Nq+1),meas(:,k))
            temp = temp + pr(k);
        end
    end
    
    if temp == 0
        % do nothing, not included in the sum
    else
        var = var + observ(j,1)^2/temp;
    end
end
% temp = 1;
% for j = 1 : len
%    temp = temp + pr(j);
% end
% var = var - temp;

end
