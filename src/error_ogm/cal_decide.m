function res = cal_decide(j,k)

global Nq observ

sum = 0;

for buff = 2:Nq+1
    if abs(observ(j,buff) - observ(k,buff)) > 0 && observ(j,buff) > 0 && observ(k,buff) > 0
        sum = sum + 1;
    end
end

if mod(sum,2) > 0
    res = 0;
else
    if mod(sum/2,2) > 0
        res = -1;
    else
        res = 1;
    end
end

end