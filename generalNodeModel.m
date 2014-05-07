clc
clear all
close all

% define variables
T = 10; % simulation time
n = 3; % number of inflow links
m = 3; % number of outflow links
si = nan(1,n); % demand of input link i
ci = nan(1,n); % capacity of input link i
cij = nan(n,m); % oriented capacity
sij = nan(n,m); % partial demand from link i to link j
sj = nan(1,m); % demand of output link j
Rtj = nan(1,m); % supply constraint
Ukj = nan(n,m); % set of index i such that sij>0
Jk = nan(1,m);  % set of index j such that sj>0
akj = nan(1,m); % level of reduction at link j
qij = nan(n,m); % flow from i to j
qij_his = nan(n,m,T);
Rtj_his = nan(1,m,T);

% initialization
si = [ 1000,1000,1000];
sij = [1000,1000,1000; 1000 ,1000,1000;1000,1000,1000];
sj = [1000,1000,1000];
Rtj = [2000,2000,2000];
ci = [1000,1000,1000];
for i=1:n
    for j = 1:m
        if (sij(i,j)>0)
            Ukj(i,j)=i;
        end
    end
end
for j = 1:m
    if (sj(j)>0)
        Jk(j) = j;
    end
end

% Determine oriented capacities
for i = 1:n
    for j = 1:m
        if (si(i)>0)
            cij(i,j) = (sij(i,j)/si(i))*ci(i);
        end
    end
end

for k = 1:T % loop over time
    % Determine most restrictive constraint
    for j = Jk
        for i = Ukj(:,j)'
            sumCij = 0;
            sumCij = sumCij + cij(i,j);
        end
        akj(j) = Rtj(j)/(sumCij);
    end
    akjhat = min(akj);
    jhat = find(akj == min(akj));
    
    % Determine the flows of corresponding set Ukj and Rtj
    for j = Jk
        for i = Ukj(:,j)';
            if si(i)<=akjhat*ci(i)
                qij(i,j) = sij(i,j);
                Rtj(j) = Rtj(j) - sij(i,j);
            else si(i)>akjhat*ci(i);
                qij(i,j) = akjhat*cij(i,j);
                Rtj(j) = Rtj(j) - akjhat*cij(i,j);
            end
            qij_his(i,j,k) = qij(i,j);
            Rtj_his(1,j,k) = Rtj(j);
        end
    end
    
end

% figure
% subplot(1,2,1)
% plot(1:T,squeeze(qij_his(1,1,:)),'-*')
% hold on
% plot(1:T,squeeze(qij_his(1,2,:)),'-o')
% subplot(1,2,2)
% plot(1:T,squeeze(qij_his(2,1,:)),'-*')
% hold on
% plot(1:T,squeeze(qij_his(2,2,:)),'-o')
% 

