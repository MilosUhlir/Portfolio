%% Global Optimalization Toolbox test
clear; clc; close all;

% odmocnina = @(x) x.^(1/2);
% 
% odmocnina(9)


ras = @(x,y) 20 + x.^2 + y.^2 - 10*(cos(2*pi*x) + cos(2*pi*y));
ras3d = @(x,y) ras(x/10, y/10);
fsurf(ras3d, [-30, 30], 'MeshDensity', 50)
title('rastrigin([x/10,y/10])')
xlabel('x'), ylabel('y')

x = optimvar("x");
y = optimvar("y");

prob = optimproblem("Objective", ras3d(x,y)); % optimalizační problém
show(prob);
hold on

x0.x = 20;
x0.y = 30;


%% Default
rng('default');
[solf, fvalf, eflagf, outputf] = solve(prob, x0); % default solver => quasi-newton
figure(2)
plot3(solf.x, solf.y, fvalf)


%% Pattern search
rng('default');
[solp, fvalp, eflagp, outputp] = solve(prob, x0, "Solver","patternsearch"); % patern search
plot3(solp.x, solp.y, fvalp)


%% GA
rng('default');
% x0.x = 10*randn(20) + 20;
% x0.y = 10*randn(20) + 30;
[solg, fvalg, eflagg, outputg] = solve(prob, x0, 'Solver', 'ga'); % GA
plot3(solg.x, solg.y, fvalg)


%% PSO
rng('default');
[solpso, fvalpso, eflagpso, outputpso] = solve(prob, x0, 'Solver','particleswarm');


%% Simulated aneeling (simulované žíhání)
rng('default');
[solsim, fvalsim, eflagsim, outputsim] = solve(prob, x0, 'Solver', 'simulannealbnd');


%% surrogate
rng('default');
x = optimvar('x', 'LowerBound', -70, "UpperBound", 130);
y = optimvar('y', 'LowerBound', -70, "UpperBound", 130);
prob = optimproblem('Objective', ras3d(x,y));
options = optimoptions("surrogateopt", "PlotFcn", []);
[solsur, fvalsur, eflagsur, outputsur] = solve(prob, "Solver", "surrogateopt", "Options", options);



%% vysledky
sols = [solf.x, solf.y;
        solp.x, solp.y;
        solg.x, solg.y;
        solpso.x, solpso.y;
        solsim.x, solsim.y;
        solsur.x, solsur.y];

fvals = [fvalf;
         fvalp;
         fvalg;
         fvalpso;
         fvalsim;
         fvalsur];

fevals = [outputf.funcCount;
          outputp.funccount;
          outputg.funccount;
          outputpso.funccount;
          outputsim.funccount;
          outputsur.funccount];

stats = table(sols, fvals, fevals);
stats.Properties.RowNames = ["fminunc", "patternsearch", "GA", "PSO", "simul anneal", "surrogateopt"];
stats.Properties.VariableNames = ["Solution", "Objective", "# Fevals"];
disp(stats)



