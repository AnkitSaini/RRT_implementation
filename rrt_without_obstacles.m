clc; close all; clear all;
tic
%% Setting up the environment

N = 5000; %maximum number of iterations
step_size = 10;
threshold = 40; %maximum distance between random node and the goal state

% Initial position and a goal position
x_init = 100; y_init = 100;
x_goal = 400; y_goal = 500;

%grid size
x_min = 0; y_min = 0;
x_max = 600; y_max = 600;

%drawing the starting and the goal position
figure(1); axis([x_min x_max y_min y_max]); hold on; grid on;
plot(x_init, y_init, 'ko', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(x_goal, y_goal, 'go', 'MarkerSize',10, 'MarkerFaceColor','g');


%% The data structure used to build RRT is a nested structure

%initializing tree
rrt_tree.node(1).x = x_init;
rrt_tree.node(1).y = y_init;
rrt_tree.node(1).index = 1; 
rrt_tree.node(1).parent_index = 0;

%% Building RRT 

%initializing x and y-coordinate of new node that will be added in tree
x_new = 0; y_new = 0;

% iter keeps track of number of iterations and is also used as index. Since
% we have already added one element, the initial configuration, to the
% tree as node. The iter variable is initialized with value 2.
iter = 2;

while iter <= N
    %% Generating random configurations
    
    %Random configuration from a uniform distribution
    x_rand = round((x_max - x_min)*rand);
    y_rand = round((y_max - y_min)*rand);
    
    %Adding bias
    %{
    random_number = rand;
    bias = 0.1; %Probability by which goal node will be sampled
    if random_number >= (1 - bias) && random_number < 1
        x_rand = x_goal;
        y_rand = y_goal;
    else
        x_rand = round((x_max - x_min)*rand);
        y_rand = round((y_max - y_min)*rand);
    end
    %}
    
    %% calculating distance between generated random node and other nodes in the tree
    for i = 1:length(rrt_tree.node)
        distance(i) = round(sqrt( (x_rand - rrt_tree.node(i).x)^2 + (y_rand - rrt_tree.node(i).y)^2 ));
    end
    %extracting minimum distance value and the node index
    [distance_value, parent_index] = min(distance);
    
    %% Steering towards the random node with maximum step size
    if distance_value >= step_size
        x_new = rrt_tree.node(parent_index).x + ((x_rand - rrt_tree.node(parent_index).x)*step_size)/distance(parent_index);
        y_new = rrt_tree.node(parent_index).y + ((y_rand - rrt_tree.node(parent_index).y)*step_size)/distance(parent_index);
    elseif distance_value <= step_size
        x_new = x_rand;
        y_new = y_rand;
    end
   
    %% Adding the new node to the tree
    rrt_tree.node(iter).x = x_new;
    rrt_tree.node(iter).y = y_new;
    rrt_tree.node(iter).index = iter; 
    rrt_tree.node(iter).parent_index = parent_index;

    %% drawing the edge from parent node to the new node added to tree
    plot(rrt_tree.node(iter).x, rrt_tree.node(iter).y, 'ko', 'MarkerSize',2, 'MarkerFaceColor','b');
    line([rrt_tree.node(iter).x, rrt_tree.node(parent_index).x], [rrt_tree.node(iter).y, rrt_tree.node(parent_index).y], 'Color', 'k', 'LineWidth', 2);
    drawnow
    hold on

    %% Checking if goal is within a threshold distance from the new node.
    distance_to_goal = sqrt( (x_new - x_goal)^2 + (y_new - y_goal)^2);
    if distance_to_goal <= threshold
        line([rrt_tree.node(iter).x, x_goal], [rrt_tree.node(iter).y, y_goal], 'Color', 'k', 'LineWidth', 2);
        drawnow
        hold on;
        rrt_tree.node(iter+1).x = x_goal;
        rrt_tree.node(iter+1).y = y_goal;
        rrt_tree.node(iter+1).index = iter+1; 
        rrt_tree.node(iter+1).parent_index = iter;
        break
    end
    iter = iter + 1;
end

%% plotting the path from goal to the start by backtracing
index = length(rrt_tree.node);
parent_index = rrt_tree.node(index).parent_index;

if rrt_tree.node(index).x == x_goal && rrt_tree.node(index).y == y_goal
    while parent_index ~= 0 
         line([rrt_tree.node(index).x, rrt_tree.node(parent_index).x], [rrt_tree.node(index).y, rrt_tree.node(parent_index).y], 'Color', 'r', 'LineWidth', 3);
         drawnow
         hold on;
         index = parent_index;
         parent_index = rrt_tree.node(index).parent_index;
    end
end

%% Reading the elapsed time from stopwatch started by tic
toc 