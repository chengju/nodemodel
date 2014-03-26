clc
clear all
close all
m = 3; % number of input links
n = 3; % number of output links
K = 2; % number of vehicle types
T = 25; % total simulation time
rho = zeros(K,n,T); % density to each link
rhoT = zeros(n,T);
flowUpStream = zeros(n,T);
flowDownStream = zeros(m,T);
s = zeros(n,T);
dd = zeros((K-1)*m+m,T);
d = zeros(n,T);
delta = zeros((K-1)*m+m,1);
beta = zeros((K-1)*m+m,n);
temp=0;
% Assume beta is probability transition matrix
beta = rand((K-1)*m+m,n);
rowSums = sum(beta,2);
normalizingMatrix = repmat(rowSums,1,n);
beta  = beta ./normalizingMatrix;

for j=1:n
    rho(1,j,1) = 100; % assign initial density to each link
    rho(2,j,1) = 300; % assign initial density to each link
end

dt = 0.5; % delta t (mimutes)
dx = [1 1 1]; % link length (miles)

% Fundamentak diagram of each link
F = 2000*ones(n,1); % capacity(vehicle/dt)
v = [2 3 5]; %free flow speed
w = v/3; % congestion wave speed (link length/dt)
rhoJam = 160*ones(n,1); %jam density (vehicle/link)

for t = 1:T
    %% Compute supply for each output
    for j = 1:n
        s(j,t) = min(F(j),w(j)*(rhoJam(j)-rhoT(j,t)));
    end
    %% demand update
    % Compute input demands
    for k=1:K
        for i = 1:m
            dd((k-1)*m+i,t) = v(i)*rho(k,i,t)*min(1,F(i)/(v(i)*rhoT(i,t)));
        end
    end
    % Compute output demands
    for j =1:n
        for i = 1:m
            d(j,t) = d(j,t)+beta((k-1)*m+i,j)*dd((k-1)*m+i,t);
        end
    end
    
    %% Compute the scaling factors
    for k=1:K
        for i=1:m
            delta((k-1)*m+i,t) = 1;% Initialize the scaling factors
        end
    end
    for q = 1:n
        if beta(j,i) == 0
            delta((k-1)*m+i,t) = 1;
        else
            delta((k-1)*m+i,t) = min(delta((k-1)*m+i,t),s(q,t)/d(q,t));
        end
    end
    dd((k-1)*m+i,t) = dd((k-1)*m+i,t)*delta((k-1)*m+i,t);
    for j =1:n
        for i = 1:m
            d(j,t) = d(j,t)+beta((k-1)*m+i,j)*dd((k-1)*m+i,t);
        end
    end
    %% flow update
    % Vector of flows leaving the input link i
    for i =1:m
        for k=1:K
            flowDownStream(i,t) = dd((k-1)*m+i,t);
        end
    end
    % Vector of flows entering the output link j
    for j=1:n
        for i=1:m
            temp = temp + beta((k-1)*m+i,j)*dd((k-1)*m+i,t);
        end
        flowUpStream(j,t) = temp;
    end
    
    %% density update by conservation law
    for k=1:K
        for j = 1:n
            rho(k,j,t)= rho(k,j,t) + (dt/dx(i))*(flowUpStream(i,t)-flowDownStream(i,t)); % conservation law
            rhoT(n,T)=rhoT(n,T)+rho(k,j,T);
        end
    end
end

% plot flow in each link
figure
for i=1:m
    subplot(3,2,(2*i-1))
    plot([1:T],flowDownStream(i,:),'-*')
    title(sprintf('input link %d',i))
end
for j=1:m
    subplot(3,2,(2*j))
    plot([1:T],flowUpStream(j,:),'-*')
    title(sprintf('output link %d',j))
end

% plot density in each link

for k=1:K
    figure
    for i=1:m
        subplot(3,2,(2*i-1))
        plot([1:T],squeeze(rho(k,i,1:T)),'-*')
        title(sprintf('density of type %d in link %d',k,i))
    end
end