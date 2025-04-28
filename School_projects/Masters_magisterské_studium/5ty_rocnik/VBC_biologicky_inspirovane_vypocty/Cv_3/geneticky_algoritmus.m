%% genetický algoritmus 1D

clear; clc;

%% init
% params
nInds = 50;
generations = 50;
mutProb = 1/nInds;
bounds = [-5.12, 5.12];
nBits = 16;
turnament_size = 5;

%% random init populace

bounds_piece = (abs(bounds(1)) + abs(bounds(2))) / 2^(nBits);

[pop,pop_bin] = pop_init(nInds, nBits, bounds, bounds_piece);

best_results = zeros(generations, 2);

%% GA run

for i = 1:generations

    %% eval pop
    

    %% selection
    [next_gen, next_gen_bin] = selection(pop, pop_bin, turnament_size, nInds, bounds_piece);

    %% crossover
    for j = 1:5%size(next_gen)
        offsprings = char(zeros(2,17));
        [offspirng1, offspirng2] = crossover(pop_bin, nInds);
        offsprings(1,:) = offspirng1;
        offsprings(2,:) = offspirng2;
    end

    next_gen_bin(end+1,:) = offsprings(1,:);
    next_gen_bin(end+1,:) = offsprings(2,:);

    %% mutation
    mutated = mutation(pop_bin, nInds);
    if ~isnan(mutated)
        next_gen_bin(end+1,:) = mutated;
    end

    [fill_pop, fill_pop_bin] = pop_init(nInds-height(next_gen_bin), nBits, bounds, bounds_piece);

    for k = 1:height(fill_pop_bin)
        next_gen_bin(end+1,:) = fill_pop_bin(k,:);
    end

    pop = bin_pop_to_dec(next_gen_bin, bounds_piece);
    
    [best_results(i,1), best_results(i,2)] = best_result(pop, bounds_piece);

    
end

final_value = best_results(end,:)
minimal_value = min(best_results)


%% %%%%% pomocné funkce %%%%%


%% bin to dec
function real_pop = bin_pop_to_dec(bin_pop, bounds_piece)

    real_pop = zeros(height(bin_pop), 1);

    for i = 1:height(bin_pop)

        negative = bin_pop(i, 17);
        bin = bin_pop(i, 1:16);

        if negative == '1'
            real_pop(i) = -bin2dec(bin);
        else
            real_pop(i) = bin2dec(bin);
        end
    end



end


function [bin_data, bounds_piece] = bin_calc(nInds, nBits, bounds)

    bin_array = zeros(1,nBits);
    bounds_piece = (abs(bounds(1)) + abs(bounds(2))) / 2^(nBits);

    bin_array(1) = -bounds_piece * (2^(nBits) / 2);

    for i = 2:nBits

        bin_array(i) = bin_array(i-1) + bounds_piece;

    end

    bin_data = bin_array;
end


%% pop_init
function [pop_real, pop_bin] = pop_init(pop_size, nBits, bounds, bounds_piece)

    pop_rnd = bounds(1) + (bounds(2) - bounds(1)) .* rand(pop_size, 1);
    pop_rounded = (round(pop_rnd./bounds_piece).*bounds_piece)/bounds_piece;
    pop_real = zeros(pop_size, 2);
    pop_real = pop_rounded;
    pop_bin = char(zeros(pop_size, nBits+1));

    for idx = 1:pop_size
        if pop_real(idx) < 0
            pop_bin(idx, 1:16) = char(dec2bin(abs(pop_real(idx)), 16));
            pop_bin(idx,17) = char('1');
        else
            pop_bin(idx, 1:16) = char(dec2bin(abs(pop_real(idx)), 16));
            pop_bin(idx,17) = char('0');
        end
    end

end


%% realPop ---- bin to real numbers
function realPop = realPop(bin_pop)
    % bin_str = '';
    realPop = zeros(height(bin_pop), 1);
    for i = 1:height(bin_pop)
        for j = 1:width(bin_pop)
            % bin_str = strjoin(string(bin_pop(i,:)))
            p1 = bin_pop(i,:);
            bin_str = char(join(string(bin_pop(i,:))));
            
            

        end
    
        real_member = typecast(int16(bin2dec(bin_str)), 'int16');


        realPop(i) = real_member;

    end

end


%% selection
function [next_gen, next_gen_bin] = selection(pop, pop_bin, turnament_size, pop_size, bounds_piece)

    next_gen = zeros(pop_size/turnament_size, 1);
    next_gen_bin = char(zeros(pop_size/turnament_size,17));

    for round = 1:turnament_size:pop_size
        contestants = pop(round:round+4).*bounds_piece;
        contestants_bin = pop_bin(round:round+4,:);

        cont_res = zeros(5, 1);

        for i = 1:turnament_size
            cont_res(i) = rastr(contestants(i));
        end



        [winner, idx] = min(cont_res);

        new_idx = round/turnament_size + 0.8;

        next_gen(new_idx, 1) = contestants(idx);
        % next_gen(new_idx, 2) = winner;
        next_gen_bin(new_idx,:) = contestants_bin(idx,:);

        
    end



end


%% cross
function [offspirng1, offspirng2] = crossover(pop, pop_size)

    parent1 = pop(randi([1,pop_size]),:);
    parent2 = pop(randi([1,pop_size]),:);

    rand_idx = randi([1,17]);

    offspirng1 = parent1;
    offspirng1(rand_idx) = parent2(rand_idx);

    offspirng2 = parent2;
    offspirng2(rand_idx) = parent1(rand_idx);

end


%% mut
function mutated = mutation(pop, nInds, mutProb)

    if randi([1, 50]) == 25

        rand_idx = randi([1,17]);

        rand_pop = randi([1, nInds]);

        mutate = pop(rand_pop,:);
        mutated = mutate;

        if mutate(rand_idx) == '1'
            mutated(rand_idx) = '0';
        else
            mutated(rand_idx) = '1';
        end
    else
        mutated = NaN;
    end

    

end


%% best_result
function [best, best_pop] = best_result(pop, bounds_piece)
    
    pop = pop.*bounds_piece;
    results = zeros(height(pop), 1);

    for i = 1:height(pop)
        results(i) = rastr(pop(i));
    end

    [best, idx] = min(results);
    best_pop = pop(idx);
end


%% cost_f
function [y] = rastr(xx)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % RASTRIGIN FUNCTION
    %
    % Authors: Sonja Surjanovic, Simon Fraser University
    %          Derek Bingham, Simon Fraser University
    % Questions/Comments: Please email Derek Bingham at dbingham@stat.sfu.ca.
    %
    % Copyright 2013. Derek Bingham, Simon Fraser University.
    %
    % THERE IS NO WARRANTY, EXPRESS OR IMPLIED. WE DO NOT ASSUME ANY LIABILITY
    % FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
    % derivative works, such modified software should be clearly marked.
    % Additionally, this program is free software; you can redistribute it 
    % and/or modify it under the terms of the GNU General Public License as 
    % published by the Free Software Foundation; version 2.0 of the License. 
    % Accordingly, this program is distributed in the hope that it will be 
    % useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
    % of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
    % General Public License for more details.
    %
    % For function details and reference information, see:
    % http://www.sfu.ca/~ssurjano/
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % INPUT:
    %
    % xx = [x1, x2, ..., xd]
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    d = length(xx);
    sum = 0;
    for ii = 1:d
        xi = xx(ii);
        sum = sum + (xi^2 - 10*cos(2*pi*xi));
    end
    
    y = 10*d + sum;
    
    end