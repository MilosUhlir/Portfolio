clc; clear all;


%% Fibonachiho sekvence

F = [0; 1];
for i = 2:20
    F(end+1) = F(i-1) + F(i);
end
F


%% prvocisla

