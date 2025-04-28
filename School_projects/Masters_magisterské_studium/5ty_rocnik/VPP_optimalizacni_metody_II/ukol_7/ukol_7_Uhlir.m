clear all; clc;

N = 10;
W = 12;
w = [2; 3; 7; 1; 5; 4; 3; 5; 6; 2];
c = [5; 6; 11; 3; 7; 7; 6; 7; 8; 5];
p = [0.95; 0.93; 0.7; 0.96; 0.94; 0.96; 0.95; 0.91; 0.9; 0.95];

g1_k = @(c, u) - c * u;
g1_N = 0;

g2_k = @(u, p) u*p + (1 - u);
g2_N = @(x) 1-0.15 * ( (W-x) / W );

xs = [1:N];
us = [0, 1];

J = zeros(N, W+1);
mu = zeros(N, W);

J(:, W+1) = g1_N;

for k = W:-1:1

    for x = 1:N

        x_cur = xs(x);
        J_temp = zeros(2,1);

        for u = 1:2

            u_cur = us(u);

            row = max(x_cur - w(x_cur)*u_cur-1, 1);

            S1 = g1_k(c(x_cur), u_cur-1) + J(row, k+1);

            S2 = -log(g2_N(x_cur));
            S2_sum = 0;
            for kk = 1:N
                S2_sum = S2_sum + log(g2_k(u_cur-1, p(xs(kk))));
            end
            S2 = S2 - S2_sum + J(row, k+1);

            J_temp(u) = max([S1, S2]);
            

        end
        J_temp;
        [maxval, maxpos] = max(J_temp);
        if w(x) <= k-1
            J(x, k) = maxval;
            mu(x, k) = maxpos;
        else
            J(x, k) = J(x, k+1);
            mu(x, k) = 1;
        end
        % pause(1)
    end

end

J
mu
disp('mu = 1 - nevzít')
disp('mu = 2 - vzít')