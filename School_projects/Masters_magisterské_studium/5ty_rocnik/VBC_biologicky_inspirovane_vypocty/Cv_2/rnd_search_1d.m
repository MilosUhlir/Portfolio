function output = rnd_search_1d(cost_function, start_point, max_step, max_iter)

    visited_points = zeros(max_iter, 1);
    visited_points(1) = start_point;

    best_point = start_point;
    best_CF = cost_function(start_point);
    
    for i=2:max_iter

        random_reach = rand()*max_step*2 - max_step;
        % random_reach = rand(-max_step, max_step)

        next_point = best_point + random_reach;
        next_point_CF = cost_function(next_point);

        if next_point_CF < best_CF
            best_CF = next_point_CF;
            best_point = next_point;
        end

        visited_points(i) = next_point;
    end

    disp('[min_point, min_value]')
    disp(best_point)
    disp(best_CF)

    output = visited_points;

end