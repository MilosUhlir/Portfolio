clear all;
% close all;
clc;
clf;

%% %%% genetický algoritmus %%%

%% init
% params
nInds = 50;
generations = 100;
mutProb = 1/nInds;
bounds = [-5.12, 5.12];
nBits = 16;
turnament_size = 5;

width = bounds(2) - bounds(1);

x = linspace(bounds(1), bounds(2), 1000);
y = arrayfun(@CF, x);


%% random init pop
pop = initPopulation(nInds, nBits);


%% GA run
for gen = 1:generations
    % disp(gen)
    clf
    hold on
    plot(x,y)

    %% eval pop
    popR = realPop(pop, width, nBits);
    CFvalues = arrayfun(@CF, popR);
    plot(popR, CFvalues, '*');

    %% selection
    parents = cell(1, nInds/2);
    for i = 1:nInds/2
        parents{i} = selection(pop, CFvalues, turnament_size, nBits);
    end

    %% crossover
    newPop = [];
    for i = 1:nInds/2
        [r1, r2] = GAcrossover(parents{i});
        newPop = [newPop; r1; r2];
    end

    %% mutation


    %% --------
    pop = newPop;
    % pause(1)

end


%% cost function
function value = CF(x)
    value = x.^2;
    value = 10 + sum(x.^2 - 10*cos(2*pi*x));
end


%% pop init
function pop = initPopulation(nInds, nBits)
    pop = dec2bin(round(rand(1, nInds)*(2^nBits -1)), nBits);
end


%% realPop (prevod z bin hodnot na realna cisla)
function rp = realPop(pop, width, nBits)
    rp = bin2dec(pop)/(2^nBits-1)*width - width/2;
end


%% selekce
function parents = selection(pop, CFvalues, turnament_size, nBits)
    popR = bin2dec(pop);
    i = randsample(1:length(popR), turnament_size);
    result = sortrows([popR(i), CFvalues(i)], 2);
    parents = dec2bin(result(1:2, 1), nBits);
end


%% křížení
function [c1, c2] = GAcrossover(parents)
    p1 = parents(1,:);
    p2 = parents(2,:);
    n = length(p1);
    c1 = strcat(p1(1:n/2), p2(n/2+1:end));
    c2 = strcat(p2(1:n/2), p1(n/2+1:end));
end


%% mutace



