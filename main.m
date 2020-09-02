%{Random walker collisions}%

% Description: Building a model of two random walkers on 2D grid using
% Monte Carlo silmulation. Investigating the collision between two random
% walkers: "same position" collision and "on the way" collison. Besides,
% tracking the distance between those two until they collide.

clc;
clear all;
close all;

%% Set up and initialize variables
rng ('shuffle');%seeds the rng based on the current time

max_count = 1000;
move_count =0;

bc = [-5 5];% boundary condition

%length and width for DrawRect
l =1;
w =1;


% co-ords arrays for A and B
x_A = zeros (1,move_count);
y_A = zeros (1,move_count);
x_B = zeros (1,move_count);
y_B = zeros (1,move_count);

%walker A
x_A(1) = randi([-5 5]);
y_A(1) = randi ([-5 5]);


% Arrays holding four vertexes
v_x = [-5, -5, 5, 5];
v_y = [5, -5, -5, 5];



%Walker B
max_ab = distance(v_x(1),v_y(1), x_A, y_A);

for k = 1:length(v_x)
    d = distance(v_x(k),v_y(k), x_A, y_A);
    if (d >= max_ab)
        max_ab = d;
        x_B(1) = v_x(k);
        y_B(1) = v_y(k);
    end    
    
end


%% Set up figure
figure (1);
set(gcf, 'Position', [40 20 1200 600]);
subplot(1,2,1);
set(gca, 'LineWidth', 2, 'FontSize', 13);
title ('Random walker collisions');
xlim ([-5.5 5.5]);
ylim ([-5.5 5.5]);

grid on;
hold on;
xticks(-5.5:1:5.5);
yticks(-5.5:1:5.5);

DrawRect (x_A(1),y_A(1),l,w,'c'); %current A   
DrawRect (x_B(1),y_B(1),l,w,'y'); %current B



%% Investigate the collisions
k =1;
col = true;%flag
while (col && move_count < max_count)
    [x_A(k+1), y_A(k+1)] = RandWalk_2D (x_A(k),y_A(k),bc);
    [x_B(k+1), y_B(k+1)] = RandWalk_2D (x_B(k),y_B(k),bc);
    
    %check for collision (same tile)
    if(x_A(k+1) == x_B(k+1) && y_A(k+1) == y_B(k+1))
        col = false;
    end
    
    %check for "on the way" collision (previous position of A is new
    %position of B and vice versa)
    if (x_B(k+1) == x_A(k)&& y_B(k+1) == y_A(k)||x_A(k+1) == x_B(k)&& y_A(k+1) == y_B(k))
        col= false; 
    end    
    
    move_count = move_count +1;
    k = k+1;
    
end


%% Distance plot
dist = distance (x_B,y_B,x_A, y_A);
iter = 0:move_count;


subplot(1,2,2);
set(gca, 'LineWidth', 2, 'FontSize', 13);
m = max(dist);
line = animatedline;
line.Color = 'r';
line.LineWidth =1;
title ('Tracking the distance between A and B');
xlim ([0 move_count]);
ylim ([0 m]);

xlabel ('iteration');
ylabel ('distance');
grid on;
yticks(0:15);
addpoints(line,iter(1),dist(1));


%% Update animation plot
for k =1:move_count
    
    %plot 2
    subplot(1,2,2);
    addpoints(line,iter(k+1),dist(k+1));

    drawnow;
    
    %plot 1
    subplot(1,2,1);
    
    DrawRect (x_A(k+1),y_A(k+1),l,w,'c'); %current A   
    DrawRect (x_B(k+1),y_B(k+1),l,w,'y'); %current B
    
    DrawRect (x_A(k),y_A(k),l,w,'b'); %old A
    DrawRect (x_B(k),y_B(k),l,w,'g'); %old B 
    
    % "On the way" collision
    if (x_B(k+1) == x_A(k)&& y_B(k+1) == y_A(k)||x_A(k+1) == x_B(k)&& y_A(k+1) == y_B(k))
        DrawRect (x_A(k+1),y_A(k+1),l,w,'c'); %current A   
        DrawRect (x_B(k+1),y_B(k+1),l,w,'y'); %current B
    end   
    
    % Fill red for "same pos" collision
    if(x_A(k+1) == x_B(k+1) && y_A(k+1) == y_B(k+1))
        DrawRect (x_A(k+1),y_A(k+1),l,w,'r');
        DrawRect (x_B(k+1),y_B(k+1),l,w,'r');
    end   
    

    
    drawnow; 
    

end

%% Functions
function d = distance (xB,yB, xA, yA)
%DISTANCE calculate the distance between two points A and B

d = sqrt((xB-xA).^2 +(yB-yA).^2);

end

function DrawRect(a,b,L,W,c)
%DRAWRECT: draw a rectangle and fill it with given color
% a,b: x,y co-ords
% L, W: length and width. c is color

A = a-0.5;
B = b-0.5;
x = [A A+L A+L A A]; 
y = [B B B+W B+W B]; 
fill(x,y,c);

end

function [x,y] = RandWalk_2D (x0,y0,BC)
%RANDWALK_2D returns the next random position of the walker
% x0,y0: the initial position of the walker.
% BC: the boundary array

    r = rand;
    lower = BC(1);
    upper = BC(2);
    if (r < 0.25)
        
        %hit the wall
        if (y0 == upper)
            x =x0;
            y =y0;
        else
            %move North
            x = x0;
            y = y0 + 1;
        end
    elseif (0.2 <= r && r < 0.5)
        
         %hit the wall
        if (x0 == upper)
            x =x0;
            y =y0;
        else
            %move East
            x = x0 +1;
            y = y0;
        end
    elseif (0.5 <= r && r < 0.75)
       
        %hit the wall
        if (y0 == lower)
            x =x0;
            y =y0;
        else
           %move South
            x = x0;
            y = y0 - 1;
        end
    elseif (0.75 <= r && r < 1)
        
        %hit the wall
        if (x0 == lower)
            x =x0;
            y =y0;
        else
            %move West
            x = x0 - 1;
            y = y0;
        end
    else
        %stay put
        x =x0;
        y =y0;


    end
end
