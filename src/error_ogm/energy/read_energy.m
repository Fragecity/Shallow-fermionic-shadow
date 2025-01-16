clear all
fp = fopen('ground_state_NH3_16jw.txt','r');
temp = fgetl(fp);
[energy]= sscanf(temp,'%s %f');
fprintf('Energy is: %f\n', energy(11));
