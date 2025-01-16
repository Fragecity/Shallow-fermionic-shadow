function [] = LDFGroup(file, mole)

MAX = 100000;

global Nq m observ Belong len phi pr meas

%%Belong: Belong(j) = cur means observable j is in set cur.

%%str = '/Users/wubujiao/Documents/MATLAB/ShadowTomography/Hamiltonian/';
% str = 'Hamiltonian/';
% strF = strcat(str, file);
% display(strF);
% observ = load(strF);
% [m,Nq] = size(observ);
str = 'Hamiltonian/';
str_set = 'Set/LDFGroup_';
strF = strcat(str, file);
strS = strcat(str_set, file);
display(strF);
observ = load(strF);
[m,Nq] = size(observ);
Nq = Nq - 1;
format = 'The number of photons: %d, the number of observables: %d';
fprintf(format, Nq, m);

%%phi = [1;1;1;0]; %%jw [1;0;1;0], bk[1;1;1;0], parity[1;1;0;0]
phi = get_qstateGlobal(mole);

%% construct the graph.
degree = zeros(m,1);
for  j = 1 : m
    for k = 1 : m
        if ~IfCommute(observ(j, 2 : Nq+1), observ(k, 2 : Nq + 1))
            degree(j) = degree(j) + 1;
        end
    end
end


%% sort to a descending order with degrees.
sort_seq = sort(degree,'descend');

format = 'Maximum degree: %d\n';
fprintf(format,sort_seq(1));%%print maximum degree
ori_seq = degree;
for j = 1 : m
    for k = 1 : m
       if  sort_seq(j) == ori_seq(k)
           ori_seq(k) = MAX;
           SeqNum(j) = k;
           break;
       end
    end
end

for j = 1 : m
   SortNum(SeqNum(j)) = j;
end

ori_seq = observ(:,1);
sort_seq = zeros(m,1);


for j = 1 : m
    if sort_seq(j) == 0
        temp_observ = observ(j, :);
        observ(j, :) = observ(SeqNum(j), :);
        observ(SeqNum(j), :) = temp_observ;
        sort_seq(j) = 1;
        SeqNum(SortNum(j)) = SeqNum(j);%seq(x) = y
        SortNum(SeqNum(j)) = SortNum(j);%sort(y) = x
    end

end


 
 %% grouping.
cur = 0; %% current set number
added = zeros(1,m);
while 1
    j = 1;
    while j <= m && added(j) > 0
       j = j + 1; 
    end
    if j > m 
       break; 
    end
    cur = cur + 1;
  %  ele_cur(cur) = 1; %% current element in the current set
    meas(:,cur)=observ(j,2:Nq+1);
   % set(ele_cur(cur),cur)=j; %set(i,j)=k, the i-th elements in set j is the k-th elements in observ.
    pr(cur) = abs(observ(j,1));
    added(j) = 1;
    Belong(j) = cur;
    j = j + 1; %% current observable
    %% initialize the set elements 
    while j <= m 
        if IfCommute(meas(:,cur),observ(j,2:Nq+1)) && added(j) == 0
     %       ele_cur(cur) = ele_cur(cur) + 1;
     %       set(ele_cur(cur), cur) = j;
            meas(:,cur) = update_meas(meas(:,cur),observ(j,2:Nq+1));
            added(j) = 1;
            pr(cur) = pr(cur) + abs(observ(j,1));
            Belong(j) = cur;
        end
        j = j + 1;
    end
     
end

% %the number of sets.
len = cur;
format = 'The number of sets: %d';
fprintf(format, len);

sum = 0;
for j = 1 : len
    sum = sum + pr(j);
end
for j = 1 : len
   pr(j) = pr(j)/sum; 
end




end