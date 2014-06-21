clc
clear all
close all

% define variables

n = 3; % number of inflow links
m = 3; % number of outflow links
Cij = nan(n,m); % oriented capacity
Rtkj = nan(1,m); % supply constraint
Ukj = cell(1,m); % set of index i such that sij>0
Jk = nan(1,m);  % set of index j such that sj>0
akj = nan(1,m); % level of reduction at link j
qij = nan(n,m); % flow from i to j
idxiTemp = [];
idxiiTemp = [];
conditionB = [];

% initialization
Si = [500,600,800]'; % demand of input link i
Ci = [1000,1100,1200]'; % capacity of input link i
fij = [0.1 0.7 0.2;
      0.3 0.2 0.6;
      0.4 0.5 0.1]; % turing fraction (split ratio)
Sij = fij.*(Si*ones(1,m)); % partial demand
Rj = [800,600,500]; % supply of output link j
Sj = [10,1000,10]; % demand of output link j

for i=1:n
    for j = 1:m
        if (Sij(i,j)>0)
            Ukj{j} = [Ukj{j},i];
        end
        if (Sj(j)>0)
            Jk(j) = j;
        end
        Rtkj(j) = Rj(j);
    end
end
Jk = Jk(~isnan(Jk));

% Determine oriented capacities
for i = find(Si>0)'
    for j = 1:m
        if (Si(i)>0)
            Cij(i,j) = (Sij(i,j)/Si(i))*Ci(i);
        end
    end
end

for k = 1:n % iteration loop, max.Iter is n
    % Determine the most restrictive constraint
    for j = Jk
        akj(j) = Rtkj(j)/(sum(Cij(Ukj{j},j))); % can akj be negative ?
    end
    akjhat = min(akj);
    jhat = find(akj == min(akj)); % if jhat is not unique, which output link is most constraint?
    % jhat = min(jhat); % this is to prevent jhat is not unique
    % Determine the flows of corresponding set Ukj and Rtj
    % check (a)
    for i = Ukj{jhat}
        if(Si(i)<=akjhat*Ci(i))
            idxiTemp = [idxiTemp,i]; % check this overwrite bug
        end
    end
    
    % check (b)
    for i = Ukj{jhat}
        if (Si(i)>akjhat*Ci(i))
            idxiiTemp = [idxiiTemp,i]; % check this overwrite bug
        end
    end
    if length(idxiiTemp) == m
        conditionB = true;
    end
    if (~isempty(idxiTemp))
        for i = idxiTemp
            for j = 1:m
                qij(i,j) = Sij(i,j);
            end
            for j = Jk
                Rtkj(:,j) = Rtkj(:,j)-Sij(i,j);
                Ukj{j} = setdiff(Ukj{j},i);
                if (isempty(Ukj{j}))
                    akj(j) = 1;
                    Ukj{j} = [];
                    Jk = setdiff(Jk,j);
                end
            end
        end
        
    elseif conditionB
        for i = Ukj{jhat} % think about here
            for j = 1:m
                qij(i,j) = akjhat*Cij(i,j);
            end
            for j = Jk
                Rtkj(:,j) = Rtkj(:,j)-akjhat*sum(Cij(Ukj{j},j));
                if j~=jhat
                    Ukj{j} = setdiff(Ukj{j},Ukj{jhat});
                    if (isempty(Ukj{j}))
                        akj(j) = 1;
                        Ukj{j} = [];
                        Jk = setdiff(Jk,j);
                    elseif j==jhat
                        akj(j) = akjhat;
                        Ukj{j} = Ukj{jhat};
                        Jk = setdiff(Jk,j);
                    end
                end
            end
        end
    end
    if isempty(Jk)
        n
        qij
        break;
    end
end