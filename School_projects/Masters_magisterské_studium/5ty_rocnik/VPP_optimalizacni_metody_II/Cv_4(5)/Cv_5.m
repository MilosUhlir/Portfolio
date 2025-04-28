clear; clc;

load cv_05.mat;
states = P.states; trans = P.transition_table;
nr_states = length(states);
msg_size = length(trans{1,3}{1});

code = '000010101010010101010100110101101001011010100010100110101101011110011001011100110101011010010010001010110'

N = round(length(code)/msg_size);
x0 = states{1};

D = Inf*ones(nr_states, N+1);
D(1,1) = 0;
x_pred = zeros(nr_states, N);

msg_index = 1;

for i = 1:N
    
    curr_msg = code(msg_index:msg_index+2); %aktualni zprava z koderu
    
    for ii = 1:nr_states

        curr_state = states(ii);
        idxs = find(strcmp(trans{:,2}, curr_state));
        m = length(idxs);
        D_temp = zeros(m, 1);
        state_id = zeros(m, 1);

        for iii = 1:m

            state_from = trans{idxs(iii), 1};
            state_id(iii) = find(strcmp(states, state_from));
            msg_expected = trans{idxs(iii), 3}{:};
            ham_dist = sum(curr_msg~=msg_expected);
            D_temp(iii) = D(state_id(iii), i) + ham_dist;

        end

        [minval, minpos] = min(D_temp);
        D(ii, i+1) = minval;
        x_pred(ii, i) = state_id(minpos);

    end

    msg_index = msg_index+3;

end


%% dekodovani
[minval, minpos] = min(D(:,end));
states_decoded = cell(N+1, 1);
states_decoded(end) = states(minpos);
curr_pos = minpos;

for i = N:-1:1

    curr_pos = x_pred(curr_pos, i);
    states_decoded{i} = states{curr_pos};

end


msg_decoded = '';
for i = 2:N+1

    msg_decoded = strcat(msg_decoded, states_decoded{i}(1));

end
msg_decoded


decode_table = cell(26, 2);
for i = 1:26
    decode_table{i,1} = char(64+i);
    decode_table{i,2} = dec2bin(i,5);
end
decode_table;


msg = ''; msg_start = 1;
for i = 1:7
    cur__bin_char = msg_decoded(msg_start:msg_start+4);
    idxs = find(strcmp(decode_table(:,2), cur__bin_char));
    msg = strcat(msg, decode_table{idxs, 1});
    msg_start = msg_start + 5;
end
flip(msg)