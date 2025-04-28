clc;
clear;
clf;

kulicka = load("kulicka.mat");

figure(1)
% plot(kulicka.t, kulicka.simout.signals.values)

N = 1:length(kulicka.t);
% figure(2)
plot(N, kulicka.simout.signals.values);

position = kulicka.simout.signals.values(:,2);
position = position(392:445);

position = position./300;
position = -position;
position = position - min(position);

plot([1:length(position)], position)