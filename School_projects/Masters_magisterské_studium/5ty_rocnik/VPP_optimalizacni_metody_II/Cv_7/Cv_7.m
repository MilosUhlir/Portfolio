clear all; clc;

N = 10; W = 12;
w = [2; 3; 7; 1; 5; 4; 3; 5; 6; 2];
c = [5; 6; 11; 3; 7; 7; 6; 7; 8; 5];
p = [0.95; 0.93; 0.7; 0.96; 0.94; 0.96; 0.95; 0.91; 0.9; 0.95];

g2_N = @(x) 1-0.15*(W-x)/W;
xs = [0:W]'; F = cell(length(xs), N+1);
mu = cell(length(xs), N);

for i = 1:length(xs)
    F{i, N+1} = [0, -log(g2_N(xs(i)))];
end

for i = N:-1:1
    for ii = 1:length(xs)
        % u = 0
        F{ii, i} = F{ii, i+1};
        if i == N
            mu{ii, i} = 0;
        else
            [m,~] = size(F{ii,i});
            mu{ii,i} = [zeros(m,1), mu{ii, i+1}];
        end
        % u = 1
        if xs(ii) >= w(i)
            temp = F{ii-w(i), i+1} + [-c(i), -log(p(i))];
            F{ii, i} = [F{ii, i}; temp];
            if i == N
                mu{ii, i} = [mu{ii,i}; 1];
            else
                [m,~] = size(temp);
                mu{ii,i} = [mu{ii,i}; ones(m,1), mu{ii-w(i),i+1}];
            end
        end
        idxs = Cv_7_pareto(F{ii,i});
        F{ii,i} = F{ii,i}(idxs,:);
        mu{ii,i} = mu{ii,i}(idxs,:);
    end
end