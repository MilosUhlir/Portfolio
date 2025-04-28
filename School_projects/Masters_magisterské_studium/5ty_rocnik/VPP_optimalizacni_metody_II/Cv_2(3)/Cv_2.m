clear; 
clc;

N = 10;

xs = [1:5]';
us = [1:3]';

W = zeros(5,5,3);

% u = 1
W(1,1,1) = .6; W(1,2,1) = .3; W(1,3,1) = .1;
W(2,2,1) = .7; W(2,3,1) = .2; W(2,4,1) = .1;
W(3,3,1) = .75; W(3,4,1) = .15; W(3,5,1) = .1;
W(4,4,1) = .8; W(4,5,1) = .2;
W(5,5,1) = 1;

% u = 2
W(2,1,2) = .9; W(2,2,2) = .1;
W(3,2,2) = .9; W(3,3,2) = .1;
W(4,3,2) = .9; W(4,4,2) = .1;
W(5,4,2) = .9; W(5,5,2) = .1;

% u = 3
W(2:5,1,3) = 1;

g_p = [1, .9, .6, .4, 0];
g_a = [0, -.4, -1];

J = zeros(5, N+1);
mu = zeros(5, N);

J(:, N+1) = g_p;

for k = N:-1:1

    for x = 1:5
    
        x_cur = xs(x);
        J_temp = zeros(3,1);
    
        for u = 1:3
    
            u_cur = us(u);
            w_cur = W(x_cur, :, u_cur);

            if sum(w_cur) > 0
    
                J_temp(u) = g_p(x) + g_a(u) + w_cur*J(:,k+1);
                % J_temp(u) = g_p(x) + g_a(u) + min(J(w_cur>0, k+1));

            else
    
                J_temp(u) = -Inf;

            end
        
        end

        [maxval, maxpos] = max(J_temp);
        J(x,k) = maxval;
        mu(x, k) = maxpos;

    end

end

J
mu


%% simulator

n = 1000;
x0 = 1;

J_sim = zeros(n, 1);
x_sim = zeros(n, N+1);
x_sim(:,1) = x0;

for iter = 1:n

    for i = 1:N
        % disp('----------------')
        x_cur = x_sim(iter, i);
        u_cur = mu(x_cur, i);

        J_sim(iter) = J_sim(iter) + g_p(x_cur) + g_a(u_cur);

        w = W(x_cur,:,u_cur);
        r = rand;
        idxs = find(r < cumsum(w));

        x_sim(iter, i+1) = idxs(1);
        % pause(1)
    end

    J_sim(iter) = J_sim(iter) + g_p(x_sim(iter, end));

end

[min(J_sim), mean(J_sim), J(1,1)]

