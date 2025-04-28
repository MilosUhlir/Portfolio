clear;clc;close;
% load cv_06a.mat;
load cv_06b.mat;

problem.start_node = 1;
start_node = problem.start_node;
end_node = problem.end_node;


node_list = problem.node_list;
node_neighbors = problem.node_neighbors;
neighbors_distance = problem.neighbors_distance;
nr_nodes = length(node_list);

Max_Iter = nr_nodes;
% Max_Iter = 1000;

M = problem.M;


% figure settings
f1 = figure;
tiledlayout(2,1);
% nexttile
% imshow(M,'InitialMagnification',1200);



%% BFS

% init

M_BFS = M;
nexttile
imshow(M_BFS,'InitialMagnification',1200);
pause(.01)

BFS_labels = Inf(nr_nodes,1);
BFS_labels(start_node) = 0;


BFS_OPEN = [start_node];
BFS_CLOSED = [];
BFS_PATH = [];



% main BFS loop
iter = 0;
while ~isempty(BFS_OPEN) && iter < Max_Iter
    curr_node = BFS_OPEN(1);
    BFS_OPEN(1) = [];
    BFS_CLOSED(end+1) = curr_node;



    % curr_coords = node_list(curr_node,:);
    % M_BFS(curr_coords(1), curr_coords(2), 1) = 255;
    % M_BFS(curr_coords(1), curr_coords(2), 2) = 10;
    % M_BFS(curr_coords(1), curr_coords(2), 3) = 0;

    curr_neighbors = node_neighbors{curr_node};

    for i = 1:height(curr_neighbors)
        if isempty(find(BFS_OPEN == curr_neighbors(i), 1)) && isempty(find(BFS_CLOSED == curr_neighbors(i), 1));
            BFS_OPEN(end+1) = curr_neighbors(i);
            BFS_labels(curr_neighbors(i)) = BFS_labels(curr_node) + neighbors_distance{curr_node}(i);

            M_BFS = recolor_node(curr_neighbors(i), M_BFS, node_list, [0,0,255]);

        end
    end

    neighbor_is_end = ~isempty(find(curr_neighbors == end_node, 1));
    if neighbor_is_end
        break
    end


    M_BFS = recolor_node(curr_node, M_BFS, node_list, [255, 10, 0]);
    imshow(M_BFS,'InitialMagnification',1200)
    pause(.0001)


    iter = iter + 1;
end

bfs_iter = iter

imshow(M_BFS,'InitialMagnification',1200)

% finding path
curr_node = BFS_CLOSED(1);
iter = 0;

while curr_node ~= end_node && ~isempty(BFS_CLOSED) && iter < Max_Iter
    if isempty(find(BFS_PATH == curr_node, 1))

        BFS_PATH(end+1) = curr_node;

        M_BFS = recolor_node(curr_node, M_BFS, node_list, [255,0,0]);
        imshow(M_BFS,'InitialMagnification',1200)
        pause(.01)

        curr_neighbors = node_neighbors{curr_node};
        curr_labels = BFS_labels(curr_neighbors);

        temp_neigh = [];
        temp_labels = [];

        for i=1:height(curr_neighbors)%:-1:1
            if isempty(find(BFS_PATH == curr_neighbors(i), 1))
                temp_neigh(end+1) = curr_neighbors(i);
                temp_labels(end+1) = curr_labels(i);
            end
            % if ~isempty(find(BFS_PATH == curr_neighbors(i), 1))
            %     curr_neighbors(i) = []
            %     curr_labels(i) = []
            % end

        end

        % temp_neigh = curr_neighbors
        % temp_labels = curr_labels

        [v, idx] = min(temp_labels);
        if ~isempty(idx)
            if isempty(find(BFS_PATH == temp_neigh(idx), 1))
                curr_node = temp_neigh(idx);
            end
        end
    end
    iter = iter + 1;
    % break
end

BFS_PATH;



%% A*

% init

M_Astar = M;
nexttile
imshow(M_Astar,'InitialMagnification',1200);
% pause(.01)

Astar_labels = Inf(nr_nodes,1);
Astar_labels(start_node) = 0;


Astar_OPEN = [start_node];
Astar_OPEN_l = [Astar_labels(start_node)];
Astar_CLOSED = [];
Astar_PATH = [];
Astar_PATH_L = [];

end_coords = node_list(end_node,:);

% main A* loop

iter = 0;
while ~isempty(Astar_OPEN) && iter < Max_Iter
    
    [v, idx] = min(Astar_OPEN_l);

    curr_node = Astar_OPEN(idx);

    Astar_OPEN(idx) = [];
    Astar_OPEN_l(idx) = [];
    Astar_CLOSED(end+1) = curr_node;

    curr_coords = node_list(curr_node,:);

    curr_neighbors = node_neighbors{curr_node};
    
    

    for i = 1:height(curr_neighbors)
        if isempty(find(Astar_OPEN == curr_neighbors(i), 1)) && isempty(find(Astar_CLOSED == curr_neighbors(i), 1))
            Astar_OPEN(end+1) = curr_neighbors(i);
            
            curr_neigh_coords = node_list(curr_neighbors(i),:);
            heuristic = sqrt( (end_coords(1)-curr_neigh_coords(1))^2 + (end_coords(2)-curr_neigh_coords(2))^2 );
            Astar_labels(curr_neighbors(i)) = Astar_labels(curr_node) + neighbors_distance{curr_node}(i) + heuristic;
            Astar_OPEN_l(end+1) = Astar_labels(curr_neighbors(i));
            M_Astar = recolor_node(curr_neighbors(i), M_Astar, node_list, [0,0,255]);

        end
    end
    
    neighbor_is_end = ~isempty(find(curr_neighbors == end_node, 1));
    if neighbor_is_end
        break
    end
    

    M_Astar = recolor_node(curr_node, M_Astar, node_list, [255, 10, 0]);
    imshow(M_Astar,'InitialMagnification',1200)
    pause(.0001)
    

    iter = iter + 1;
end

Astar_iter = iter

imshow(M_Astar,'InitialMagnification',1200);



% finding path
curr_node = Astar_CLOSED(1);
iter = 0;

while curr_node ~= end_node && ~isempty(Astar_CLOSED) && iter < Max_Iter
    if isempty(find(Astar_PATH == curr_node, 1))

        Astar_PATH(end+1) = curr_node;
        Astar_PATH_L(end+1) = Astar_labels(curr_node);

        M_Astar = recolor_node(curr_node, M_Astar, node_list, [255,0,0]);
        imshow(M_Astar,'InitialMagnification',1200)
        % pause(.1)

        curr_neighbors = node_neighbors{curr_node};
        curr_labels = Astar_labels(curr_neighbors);

        temp_neigh = [];
        temp_labels = [];

        for i=1:height(curr_neighbors)%:-1:1
            if isempty(find(Astar_PATH == curr_neighbors(i), 1))
                % if curr_labels(i) <= Astar_PATH_L(end)+1;
                    temp_neigh(end+1) = curr_neighbors(i);
                    temp_labels(end+1) = curr_labels(i);
                % end
            end
            % if ~isempty(find(Astar_PATH == curr_neighbors(i), 1))
            %     curr_neighbors(i) = []
            %     curr_labels(i) = []
            % end

        end

        % temp_neigh = curr_neighbors
        % temp_labels = curr_labels

        temp_neigh
        temp_labels

        [v, idx] = min(temp_labels)
        if ~isempty(idx)
            if isempty(find(Astar_PATH == temp_neigh(idx), 1))
                curr_node = temp_neigh(idx)
            end
        end
    end
    iter = iter + 1;
    % break
end









function map = recolor_node(node, map, node_list, RGB)
    coords = node_list(node,:);
    map(coords(1), coords(2), 1) = RGB(1);
    map(coords(1), coords(2), 2) = RGB(2);
    map(coords(1), coords(2), 3) = RGB(3);
    % imshow(map,'InitialMagnification',1200);
end
