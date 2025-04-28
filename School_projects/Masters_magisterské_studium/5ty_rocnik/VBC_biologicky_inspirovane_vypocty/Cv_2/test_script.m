clc; clear all


cost_function = @(x) sum(x-5).^2;

start_point = [1,1];

max_step = 0.2;

max_iter = 100;


output = rnd_search_2d(cost_function, start_point, max_step, max_iter)

plot(output(:,1), output(:,2), '*')