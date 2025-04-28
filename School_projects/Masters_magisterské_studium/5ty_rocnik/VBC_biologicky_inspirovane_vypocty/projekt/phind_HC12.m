clear; clc;


% Define problem parameters
problem = [1 1];  % Coefficient matrix for our objective function

% Run optimization
num_organisms = 100;
max_generations = 100;
[best_solution, best_fitness] = hc12_optimization(problem, num_organisms, max_generations);

fprintf('Best solution found: %s\n', mat2str(best_solution));
fprintf('Best fitness value: %.4f\n', best_fitness);


function fitness = objective_function(x)
    % Define your objective function here
    % For example:
    fitness = sum(x.^2);
end

function [best_solution, best_fitness] = hc12_optimization(problem, num_organisms, max_generations)
    % Initialize parameters
    population_size = num_organisms;
    max_iterations = max_generations;
    
    % Create initial population
    population = zeros(population_size, size(problem, 2));
    for i = 1:population_size
        population(i,:) = rand(size(problem, 2), 1);
    end
    
    % Evaluate initial population
    fitnesses = zeros(population_size, 1);
    parfor i = 1:population_size
        fitnesses(i) = objective_function(problem * population(i,:));
    end
    
    % Main loop
    for generation = 1:max_iterations
        % Select fittest organisms
        [sorted_indices, ~] = sort(fitnesses);
        fittest_organisms = sorted_indices(1:floor(population_size/2));
        
        % Reproduce selected organisms
        offspring = zeros(size(population, 1), size(problem, 2));
        for i = 1:size(population, 1)
            parent1 = population(fittest_organisms(i),:);
            parent2 = population(fittest_organisms(mod(i+1, size(fittest_organisms, 2)) + 1, :));
            
            % Simple crossover (average of parents)
            offspring(i,:) = (parent1 + parent2) / 2;
            
            % Mutation (small random perturbation)
            mutation_factor = 0.01;
            offspring(i,:) = offspring(i,:) + mutation_factor * (rand(size(offspring(i,:))) - 0.5);
        end
        
        % Replace least fit organisms with new offspring
        population(floor(population_size/2)+1:end,:) = offspring;
        
        % Evaluate new population
        parfor i = 1:population_size
            fitnesses(i) = objective_function(problem * population(i,:));
        end
    end
    
    % Find best solution
    [best_fitness, idx] = min(fitnesses);
    best_solution = population(idx,:);
end