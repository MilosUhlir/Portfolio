function output = rnd_search_2d(cost_function, start_point, max_step, max_iter)

    visited_points = zeros(max_iter, 2);
    visited_points(1,1) = start_point(1);
    visited_points(1,2) = start_point(2);

    best_point = start_point;
    best_CF = cost_function(start_point);
    
    random_reach = [0, 0];

    for i=2:max_iter

        random_reach(1) = rand()*max_step*2 - max_step;
        random_reach(2) = rand()*max_step*2 - max_step;
        random_reach;
        % random_reach = rand(-max_step, max_step)

        next_point = best_point + random_reach;
        next_point_CF = cost_function(next_point);

        if next_point_CF < best_CF
            best_CF = next_point_CF;
            best_point = next_point;
        end

        visited_points(i,1) = next_point(1);
        visited_points(i,2) = next_point(2);
    end

    disp('[min_point, min_value]')
    disp(best_point)
    disp(best_CF)

    output = visited_points

end