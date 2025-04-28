clear;clc;
load cv_05.mat;
states = P.states; trans = P.transition_table;
nr_states = length(states);
msg_size = length(trans{1,3}{1});
code = '000010101010010101010100110101101001011010100010100110101101011110011001011100110101011010010010001010110';
N = round(length(code)/msg_size);
x0 = states{1};
