clear;clc;clf;
% load cv_06a.mat;
load cv_06b.mat;
problem.start_node = 1;
end_node = problem.end_node;

node_list = problem.node_list;
node_neighbors = problem.node_neighbors;
neighbors_distance = problem.neighbors_distance;
nr_nodes = length(node_list);
M = problem.M;

% figure settings
fig = figure;
tiledlayout(2,1);
% nexttile
% imshow(M,'InitialMagnification',1200);



%% BFS

% init

M_BFS = M;
nexttile
imshow(M_BFS,'InitialMagnification',1200);

labels = Inf(nr_nodes,1);
start_node = problem.start_node;
labels(start_node) = 0;

OPEN = [start_node];
CLOSED = [];
PATH = [];

Max_Iter = 1000;

iter = 0;

while ~isempty(OPEN) && iter < Max_Iter
    iter;
    curr_node = OPEN(1);
    curr_coords = node_list(curr_node,:);
    
    if curr_node == end_node
        disp('path found')
        break;
    end

    CLOSED(end+1) = curr_node;
    
    OPEN(1) = [];

    curr_neighbors = node_neighbors{curr_node};
    for i = 1:height(curr_neighbors)
        if isempty(find(CLOSED == curr_neighbors(i),1))
            if isempty(find(OPEN == curr_neighbors(i),1))
                OPEN(end+1) = curr_neighbors(i);
            end
            labels(curr_neighbors(i)) = neighbors_distance{curr_node}(i) + labels(curr_node);
        end
        
    end

    if curr_coords(1) ~= 1 || curr_coords(2) ~= 1
        M_BFS(curr_coords(1), curr_coords(2), 1) = 25;
        M_BFS(curr_coords(1), curr_coords(2), 2) = 6;
        M_BFS(curr_coords(1), curr_coords(2), 3) = 0;
    end
    % imshow(M_BFS,'InitialMagnification',1200);

    iter = iter+1;
end

% imshow(M_BFS,'InitialMagnification',1200);

curr_node = CLOSED(1);
PATH(1) = CLOSED(1);

potato = 0;

while curr_node ~= end_node && potato < Max_Iter
    potato = potato + 1;
    curr_neighbors = node_neighbors{curr_node};
    neighbors = [];
    costs = [];
    for i = 1:height(curr_neighbors)
        if isempty(find(PATH == curr_neighbors(i),1))
            neighbors(end+1) = curr_neighbors(i);
            costs(end+1) = labels(curr_neighbors(i));
        end
    end

    if ~isempty(costs)
        neighbors;
        costs;
        val = min(costs);
        idxs = find(costs == val);
        temp_neigh = [];
        for i = idxs
            temp_neigh(end+1) = neighbors(i);
        end
        [val,idx] = max(temp_neigh);
        PATH(end+1) = neighbors(idx)
    end

    curr_node = PATH(end);
    
end


for i=2:length(PATH)
    idx = PATH(i);
    curr_coords = node_list(idx,:);

    if curr_coords(1) ~= 1 || curr_coords(2) ~= 1
        M_BFS(curr_coords(1), curr_coords(2), 1) = 255;
        M_BFS(curr_coords(1), curr_coords(2), 2) = 0;
        M_BFS(curr_coords(1), curr_coords(2), 3) = 0;
    end

    imshow(M_BFS,'InitialMagnification',1200);
    % pause(1)

end


labels;





%% A*

% init

M_Astar = M;
nexttile
imshow(M_Astar,'InitialMagnification',1200);

labels_A = Inf(nr_nodes,1);
start_node = problem.start_node;
labels_A(start_node) = 0;

end_coords = node_list(end_node,:)

OPEN = [start_node];
CLOSED = [];
PATH = [];

Max_Iter = 1000;

iter = 0;


while ~isempty(OPEN) && iter < Max_Iter
    iter;

    temp_labels = [];

    for i = 1:length(OPEN)
        temp_labels(end+1) = labels_A(OPEN(i))
    end
    [temp_val, temp_idx] = min(temp_labels)

    curr_node = OPEN(1);
    curr_coords = node_list(curr_node,:);
    
    if curr_node == end_node
        disp('path found')
        break;
    end

    CLOSED(end+1) = curr_node;
    
    OPEN(1) = [];

    curr_heuristic = sqrt( (end_coords(1)-curr_coords(1))^2 + (end_coords(2)-curr_coords(2))^2 );

    curr_neighbors = node_neighbors{curr_node};
    for i = 1:height(curr_neighbors)
        if isempty(find(CLOSED == curr_neighbors(i),1))
            if isempty(find(OPEN == curr_neighbors(i),1))
                OPEN(end+1) = curr_neighbors(i);
                labels(curr_neighbors(i)) = neighbors_distance{curr_node}(i) + labels(curr_node) + curr_heuristic;
            end
        end
        
    end

    if curr_coords(1) ~= 1 || curr_coords(2) ~= 1
        M_Astar(curr_coords(1), curr_coords(2), 1) = 25;
        M_Astar(curr_coords(1), curr_coords(2), 2) = 6;
        M_Astar(curr_coords(1), curr_coords(2), 3) = 0;
    end
    % imshow(M_Astar,'InitialMagnification',1200);

    iter = iter+1;
end

% imshow(M_Astar,'InitialMagnification',1200);

curr_node = CLOSED(1);
PATH(1) = CLOSED(1);

potato = 0;

while curr_node ~= end_node && potato < Max_Iter
    potato = potato + 1;
    curr_neighbors = node_neighbors{curr_node};
    neighbors = [];
    costs = [];
    for i = 1:height(curr_neighbors)
        if isempty(find(PATH == curr_neighbors(i),1))
            neighbors(end+1) = curr_neighbors(i);
            costs(end+1) = labels(curr_neighbors(i));
        end
    end

    if ~isempty(costs)
        neighbors;
        costs;
        val = min(costs);
        idxs = find(costs == val);
        temp_neigh = [];
        for i = idxs
            temp_neigh(end+1) = neighbors(i);
        end
        [val,idx] = min(temp_neigh);
        PATH(end+1) = neighbors(idx)
    end

    curr_node = PATH(end);
    
end


for i=2:length(PATH)
    idx = PATH(i);
    curr_coords = node_list(idx,:);

    if curr_coords(1) ~= 1 || curr_coords(2) ~= 1
        M_Astar(curr_coords(1), curr_coords(2), 1) = 255;
        M_Astar(curr_coords(1), curr_coords(2), 2) = 0;
        M_M_AstarBFS(curr_coords(1), curr_coords(2), 3) = 0;
    end

    % imshow(M_Astar,'InitialMagnification',1200);
    % pause(1)

end
imshow(M_Astar,'InitialMagnification',1200);

labels;














