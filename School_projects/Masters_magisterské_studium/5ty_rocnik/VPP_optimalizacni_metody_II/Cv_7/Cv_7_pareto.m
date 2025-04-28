function [idxs] = Cv_7_pareto(points)
    % points - n * m matice, kde n je počet bodů, m je počet kriterií

    % idxs - ...

    [n, ~] = size(points);
    idxs = true(n,1);
    for i = 1:n
        for j = 1:n
            if all(points(i,:) >= points(j,:)) && any(points(i,:) > points(j,:))
                idxs(i) = false;
                break;
            end
        end
    end

end