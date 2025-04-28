clear; clc;


x = '000010101010010101010100110101101001011010100010100110101101011110011001011100110101011010010010001010110'

mess_len = length(x);

mess_start = '0 0 0';

output = zeros(1, 35+3);


x_arr = zeros(mess_len+3, 1);
for i = 4:mess_len+3
    x_arr(i) = str2num(x(i-3));
end

gen1 = [1,1,0,1];
gen2 = [1,0,1,0];
gen3 = [0,1,1,0];

gens = [gen1;gen2;gen3];

g1 = strings(1,35);
g2 = strings(1,35);
g3 = strings(1,35);


mess_matrix = strings(35,3);

for i = 1:35

    g1_idx = i*3 + mod(i*3, 3)-2;
    g2_idx = i*3 + mod(i*3, 3)-1;
    g3_idx = i*3 + mod(i*3, 3)-0;

    mess_matrix(i,1) = x(g1_idx);
    mess_matrix(i,2) = x(g2_idx);
    mess_matrix(i,3) = x(g3_idx);
end

for i = 1+3:35+3
    for j = 1:3
        code_block = output(1,i-3:i);
        poss_output = zeros(1,3);
        for k = 1:2
            code_block(end) = k;
            ids = find(gens(1,:) == 1);
            checksum = 0;
            for id = ids
                id;
                if code_block(id) == 1
                    checksum = checksum + code_block(id);
                end
            end
            if mod(checksum, 2) == 0
                poss_output(j) = 0;
            else
                poss_output(j) = 1;
            end
        end

    end

    if sum(poss_output) ~= 1 %&& sum(poss_output) ~= 0
        output(1,i) = 1;
    % break
    else%if sum(poss_output) == 0
        output(1,i) = 0;
    end

end


output = output';

output_correct = string;
output_wrong = string;
original_message = string;

for i = 1+3:35+3
    output_correct = char(join([output_correct,string(output(i,1))]));
    % output_wrong = char(join([output_correct,string(output(i,2))]));
    original_message = char(join([original_message,string(output(i,1))]));
end

original_message
output_correct;
% output_wrong


%% Translate

% alphabet
letters = [
    'A';
    'B';
    'C';
    'D';
    'E';
    'F';
    'G';
    'H';
    'I';
    'J';
    'K';
    'L';
    'M';
    'N';
    'O';
    'P';
    'Q';
    'R';
    'S';
    'T';
    'U';
    'V';
    'W';
    'X';
    'Y';
    'Z'];

% letter binary representation
let_bin = [
    '0 0 0 0 1';
    '0 0 0 1 0';
    '0 0 0 1 1';
    '0 0 1 0 0';
    '0 0 1 0 1';
    '0 0 1 1 0';
    '0 0 1 1 1';
    '0 1 0 0 0';
    '0 1 0 0 1';
    '0 1 0 1 0';
    '0 1 0 1 1';
    '0 1 1 0 0';
    '0 1 1 0 1';
    '0 1 1 1 0';
    '0 1 1 1 1';
    '1 0 0 0 0';
    '1 0 0 0 1';
    '1 0 0 1 0';
    '1 0 0 1 1';
    '1 0 1 0 0';
    '1 0 1 0 1';
    '1 0 1 1 0';
    '1 0 1 1 1';
    '1 1 0 0 0';
    '1 1 0 0 1';
    '1 1 0 1 0'];

%

LT = strings(length(letters), 2);

LT(:,1) = letters;
LT(:,2) = let_bin;

% translator
translated_msg = strings(0,0);
for i = 3+5:5:35+3
    bin = strjoin(string(output(i-4:i)));

    letter_ind = find(LT(:,2) == bin,1);
    letter = LT(letter_ind,1);
    % translated_msg
    translated_msg(end+1) = letter;
end

translated_msg = char(join(translated_msg))