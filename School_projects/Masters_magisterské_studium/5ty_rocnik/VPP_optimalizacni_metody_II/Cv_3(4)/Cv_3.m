clear all; clc;


c1 = @(x) sqrt(0.9 * x);
c2 = @(u) (u>0) * 0.3 + u;
c3 = @(x,w) -3*min(x,w);

% cenove funkce
g_k = @(x,u,w) c1(x) + c2(u) + c3(x,w);
g_N = @(x) c1(x);

M=4; U=3; N=15;
xs=[0:M]'; us=[0:U]'; ss = us;
ws=[0:3]'; ps = [0.1;0.3;0.5;0.1]';
nr_states = (M+1)*(U+1); % počet různých stavů

states = zeros(nr_states,2);

iter=0;
for k=1:length(xs)

    for x = 1:length(ss)
        iter = iter+1;
        states(iter,:) = [xs(k), ss(x)];

    end

end

J = zeros(nr_states, N+1);
mu = zeros(nr_states, N);

for k = 1:nr_states % J_N = g_N(x)
    x_cur = states(k,1);
    J(k, end) = g_N(x_cur);
end


for k = N:-1:1  % k = i

    for x = 1:nr_states % x = ii
        J_temp = zeros(length(us),1);

        for u = 1:length(us)    % u = iii

            for w = 1:length(ws)    % w = iiii
                x_cur = states(x, 1);
                s_cur = states(x, 2);
                u_cur = us(u);
                w_cur = ws(w);

                x_next = min(max(x_cur - w_cur, 0) + s_cur, M);
                s_next = u_cur;

                state_row = find(x_next==states(:,1) & s_next==states(:,2));

                J_temp(u) = J_temp(u) + ps(w)*(g_k(x_cur,u_cur,w_cur) + J(state_row,k+1));

            end

        end

        [minval, minpos] = min(J_temp);
        J(x,k) = minval;
        mu(x,k) = minpos;

    end

end

J









