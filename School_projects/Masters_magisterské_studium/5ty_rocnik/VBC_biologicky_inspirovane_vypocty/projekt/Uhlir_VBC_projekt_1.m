clear; clc; close all
% clf;

% parametry
max_gen = 1000; % Maximální počet generací pro GA
pop_size = 1000; % Velikost populace pro GA
mutation_rate = 0.1; % Míra mutace pro GA
crossover_rate = 0.8; % Míra křížení pro GA

% algorithms = [GA, SA];

% functions = {@dejong5, @rastr, @rosen}; % };%
functions = {@dejong5_2, @rastr_2, @rosen_2}; % };%
l_f = length(functions);

dims = 100;% [2,5,10,50,100];

nRUNs = 50;

%% 
sol_ga = 0;
fval_ga = 0;
sol_sa = 0;
fval_sa = 0;
solutions = zeros(nRUNs, dims + 1, length(functions), 2);

times = zeros(2,l_f);

for i = 1:2
    for f = 1:length(functions)
        tic;
        for r = 1:nRUNs
            clc
            fprintf('algorithm: %d | function: %d | run: %d\n', i,f,r)
            func = functions{f};
            d = dims;
            % for d = dims
                if f == 1 && d ~= 2
                    continue;
                else
                    rng("default")
                    if i == 1
                        disp('GA')
                        [sol_ga, fval_ga] = GA(func, d, max_gen, pop_size, mutation_rate, crossover_rate);
                        solutions(r,:,f,i) = [sol_ga, fval_ga]; 
                    else
                        disp('SA')
                        [sol_sa, fval_sa] = SA(func, d);
                        solutions(r,:,f,i) = [sol_sa, fval_sa];
                    end
                end
            % end
        end
        times(i,f) = toc;
    end
end
clc
% elapsed_time = toc

%% vizualizace dat
close all;
isequal(solutions(:,:,:,1), solutions(:,:,:,2))
sols = solutions;
S = size(sols);

figure;
f1.Name = 'Solutions for each function';
% hold on



subplot(2,l_f,1);
subplot(2,l_f,2);
subplot(2,l_f,3);
subplot(2,l_f,4);
subplot(2,l_f,5);
subplot(2,l_f,6);

% plot([1:S(1)], sols(:,:,2,1), 'r.')

for i = 1:2
    for f = 1:l_f
        for d = 1:S(2)%:-1:1
            if i == 1
                cur_subplot = subplot(2,l_f,f);
            elseif i == 2
                cur_subplot = subplot(2,l_f,3+f);
            end
            if d <= S(2)-1
                % disp('im here')
                if d == S(2)-2
                    plot([1:S(1)],sols(:,d,f,i)', 'r.', 'DisplayName', 'solutions');
                    hold on
                else
                    plot([1:S(1)],sols(:,d,f,i)', 'r.', 'HandleVisibility', 'off');
                    hold on
                end
                % pause(1)
            else
                % disp('im here too')
                plot([1:S(1)],sols(:,d,f,i)', 'b*', 'DisplayName', 'fvals');
                hold on
                % pause(1)
            end

            title([func2str(functions{f})]);
            legend('show')
        end
    end
end
 

%% průměry výsledků
avgs = zeros(dims,l_f,2);
avg_over_dims = zeros(1,l_f,2);
for i = 1:2
    for f = 1:l_f
        for d = 1:S(2)
            avgs(d,f,i) = mean(solutions(:,d,f,i));
        end
        avg_over_dims(1,f,i) = mean(avgs(1:end-1,f,i))
    end
end

avg_sols = avgs(1:end-1,:,:);
avg_sol_table = array2table(avg_sols(:,:,1), "VariableNames", {'dejong 5 (GA)', 'rastrigin (GA)', 'rosenbrock (GA)'})
avg_sol_table = array2table(avg_sols(:,:,2), "VariableNames", {'dejong 5 (SA)', 'rastrigin (SA)', 'rosenbrock (SA)'})

avg_over_all_dims = array2table(avg_over_dims(:,:,1), "VariableNames", {'dejong 5 (GA)', 'rastrigin (GA)', 'rosenbrock (GA)'})
avg_over_all_dims = array2table(avg_over_dims(:,:,2), "VariableNames", {'dejong 5 (SA)', 'rastrigin (SA)', 'rosenbrock (SA)'})

avg_fvals = avgs(end,:,:);
avg_fval_table = array2table(avg_fvals(:,:,1), "VariableNames", {'dejong 5', 'rastrigin', 'rosenbrock'})
avg_fval_table = array2table(avg_fvals(:,:,2), "VariableNames", {'dejong 5', 'rastrigin', 'rosenbrock'})

figure;

subplot(3,1,1)
plot(1:3, avg_fvals(:,1,1)*ones(1,3), 'r-', 'DisplayName', 'průměrný výsledek GA');
hold on
plot(1:3, avg_fvals(:,1,2)*ones(1,3), 'b-', 'DisplayName', 'průměrný výsledek SA');
title(sprintf('výsledky pro funkci Dejong No. 5 přes %d opakování', nRUNs))

subplot(3,1,2)
plot(1:3, avg_fvals(:,2,1)*ones(1,3), 'r-', 'DisplayName', 'průměrný výsledek GA');
hold on
plot(1:3, avg_fvals(:,2,2)*ones(1,3), 'b-', 'DisplayName', 'průměrný výsledek SA');
title(sprintf('výsledky pro Rastriginovu funkci přes %d opakování', nRUNs))

subplot(3,1,3)
plot(1:3, avg_fvals(:,3,1)*ones(1,3), 'r-', 'DisplayName', 'průměrný výsledek GA');
hold on
plot(1:3, avg_fvals(:,3,2)*ones(1,3), 'b-', 'DisplayName', 'průměrný výsledek SA');
title(sprintf('výsledky pro Rosenbrockovu funkci přes %d opakování', nRUNs))

%%
el_time_GA = duration(0,0,times(1,:))
el_time_SA = duration(0,0,times(2,:))

%% GA

function [sol_ga, fval_ga] = GA(func, dim, max_gen, pop_size, mutation_rate, crossover_rate)
    rng("default")
    x = optimvar('x', dim);
    prob = optimproblem("Objective",func(x));
    
    options = optimoptions('ga', 'MaxGenerations', max_gen, ...
        'PopulationSize',pop_size, 'CrossoverFraction',crossover_rate,...
        'MutationFcn', {@mutationuniform, mutation_rate});%,'Display','iter');

    % [sol_ga, fval_ga] = solve(prob, 'Solver', 'ga', 'Options', options);
    [sol_ga, fval_ga] = ga(func, dim, [], [], [], [], [], [], [], options);

    % Výsledky
    % fprintf('Optimální řešení (GA): %s\n', mat2str(sol_ga));
    % fprintf('Function value (GA): %f\n', fval_ga);
end


%% SA

function [sol_sa, fval_sa] = SA(func, dim)
    rng('default')
    x0 = rand(1, dim); % Náhodný počáteční bod pro d dimenzí
    
    x = optimvar('x', dim);
    prob = optimproblem("Objective",func(x));

    % [sol, fval] = solve(prob, 'Solver', 'simulannealbnd', 'InitialPoint', x0,'Options', options);
    [sol_sa, fval_sa] = simulannealbnd(func, x0, [], [], []);

    % Výsledky
    % fprintf('Optimal solution (SA): %s\n', mat2str(sol_sa));
    % fprintf('Function value (SA): %.5f\n', fval_sa);
end


%% -------------------------------

% De Jong Function No.5
function f = dejong5_2(x)
    f = 0.5 * ((x(1)^2 + x(2)^2)^2 - 2*x(1)^2 - 2*x(2)^2 + 1);
end

% Rastrigin's Function
function f = rastr_2(x)
    A = 10;
    D = length(x);
    f = A * D + sum(x.^2 - A * cos(2 * pi * x));
end

% Rosenbrock's Function
function f = rosen_2(x)
    a = 1;
    b = 100;
    f = (a - x(1))^2 + b * (x(2) - x(1)^2)^2;
end

