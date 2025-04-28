clear;clc;clf;
K = 3; G = [1,1,1;1,0,1];
%K = 4; G = [1,1,0,1;1,0,1,0;0,1,1,0];
[m,n] = size(G);
nr_states = 2^(K-1);
states = cell(nr_states,1);
for i=1:nr_states
    states{i} = dec2bin(i-1,K-1);
end

hold on; axis off;set(gca, 'YDir','reverse');
state_from = cell(1); state_to = {}; trans_msg = {}; iter = 0;
for i=1:nr_states   
    cur_state = states{i};
    next_state0 = ['0',cur_state(1:K-2)];
    next_state0_id = find(contains(states,next_state0));
    vec0 = zeros(K,1);
    for j=2:K
       if cur_state(j-1) == '1'
          vec0(j) = 1; 
       end
    end
    msg_0 = '';
    for j=1:m
        msg_0 = [msg_0, num2str(mod(G(j,:)*vec0,2))];
    end
    iter = iter + 1;
    state_from{iter,1} = cur_state;
    state_to{iter,1} = next_state0;
    trans_msg{iter,1} = msg_0;
    
    next_state1 = ['1',cur_state(1:K-2)];
    next_state1_id = find(contains(states,next_state1));
    vec1 = zeros(K,1); vec1(1) = 1;
    for j=2:K
       if cur_state(j-1) == '1'
          vec1(j) = 1; 
       end
    end
    msg_1 = '';
    for j=1:m
        msg_1 = [msg_1, num2str(mod(G(j,:)*vec1,2))];
    end
    iter = iter + 1;
    state_from{iter,1} = cur_state;
    state_to{iter,1} = next_state1;
    trans_msg{iter,1} = msg_1;
    
    
    plot([0,1],[i,next_state0_id],'k-'); randval = 0.1+0.8*rand(1); 
    text(randval, i+randval*(next_state0_id-i),['0 | ',msg_0],'BackgroundColor','w');
    plot([0,1],[i,next_state1_id],'k-');
    text(randval, i+randval*(next_state1_id-i),['1 | ',msg_1],'BackgroundColor','w');
end
plot(zeros(nr_states,1),1:nr_states,'ko','Markersize',25,'markerfacecolor','w'); 
text(zeros(nr_states,1),1:nr_states,states,'horizontalalignment','center')
plot(ones(nr_states,1),1:nr_states,'ko','Markersize',25,'markerfacecolor','w'); 
text(ones(nr_states,1),1:nr_states,states,'horizontalalignment','center')

transition_table = table(state_from,state_to,trans_msg)

P.states = states;
P.transition_table = transition_table;