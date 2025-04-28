% hladový - greedy; amoeba; lokální vyhledávání - local search

max_iter = 100000;

D = 7;

x = zeros([1,D]);

y = objective_f(x);

max_dx = 2;

no_improve_i = 0;

n_points = 5;
% opakovat
for iter = 1:max_iter
    no_improve_i = no_improve_i + 1;

    % udrzuj nejlepsi jedno reseni


    % generuj okoli
    X = repmat(x, n_points,  1);
    for i = 1:n_points
        for j = 1:randi(4)
            k = randi(D);
            X(i,k) = ~ X(i,k);
        end
    end

    Y = objective_f(X);

    % beru lepsi reseni - minimize
    [max_Y, idx] = max(Y);
    if max_Y > y
        x = X(idx, :);
        y = max_Y;
        no_improve_i = 0;
    end
    fprintf('iter=%d, y=%.e\n', iter, y)

    % ukoncovaci podminka - eps = 10^-6
    if no_improve_i > 5
        break
    end

end

x
y






function C = objective_f(X)

% nezname derivaci/diferenci
% Y = sum((X+2).^2-3.2, 2);


% problem batohu (knapsack)
    limit_y = 145;
    w = [10, 200, 40, 90, 5, 8, 15];
    c = [800, 100, 567, 40, 9, 15, 91];
    
    W = sum(w.*X, 2);
    C = sum(c.*X, 2);
    C(W>limit_y) = 0;


end

















