%% This program generates motion primitives for a car-like nonholonomic robot
%%
clc; close all; clear all;

% Set vehicle constants
dt = 0.1; % Step by 0.1 seconds
L = 7.5; % Car length

%Starting position and orientation
x_start = 2; y_start = 7; theta_start = 0;

%Initializing figure window and drawing grid and initial position
figure(1); axis([0 12 0 14]); hold on; grid on;
plot(x_start, y_start, 'ko', 'MarkerSize',10, 'MarkerFaceColor','k');

%Simulate forward from x_start
path = [x_start, y_start, theta_start];
deltastep = 10; %Moving for ten steps
max_steering_angle = 1.05; %radians

steering_angle = -max_steering_angle;
while steering_angle <= max_steering_angle
    
    %Calculating and plotting motion primitives in forward direction
    linear_vel = 10;
    for i = 2:deltastep
        path(i,1) = path(i-1,1) + linear_vel*cos(path(i-1,3))*dt;
        path(i,2) = path(i-1,2) + linear_vel*sin(path(i-1,3))*dt;
        path(i,3) = path(i-1,3) + (linear_vel/L)*tan(steering_angle)*dt;
    end
    for j = 2:size(path,1)
        line([path(j,1), path(j-1,1)], [path(j,2), path(j-1,2)], 'Color', 'k', 'LineWidth', 2);
        drawnow
        hold on
    end
    plot(path(j,1), path(j,2), 'ko', 'MarkerSize',5, 'MarkerFaceColor','r');
    
    %Calculating and plotting motion primitives in reverse direction.
    %Uncomment this section to generate draw the motion primitives and
    %To visualize change 'axis([0 12 0 14])' to 'axis([-10 12 0 14])'
    %{
    linear_vel = -10;
    for i = 2:deltastep
        path(i,1) = path(i-1,1) + linear_vel*cos(path(i-1,3))*dt;
        path(i,2) = path(i-1,2) + linear_vel*sin(path(i-1,3))*dt;
        path(i,3) = path(i-1,3) + (linear_vel/L)*tan(steering_angle)*dt;
    end
    for j = 2:size(path,1)
        line([path(j,1), path(j-1,1)], [path(j,2), path(j-1,2)], 'Color', 'k', 'LineWidth', 2);
        drawnow
        hold on
    end
    plot(path(j,1), path(j,2), 'ko', 'MarkerSize',5, 'MarkerFaceColor','r');
    %}
    
    steering_angle = steering_angle + 0.1;
end
