clear; clc; close all;warning('off');
%%%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%%% main function %%%%%%%%%%%%%
global globalpara;
globalpara.time_step = 0.5;
globalpara.numUAV = 6;


%%% any given arbitrary cneter position (x,y,z) and arbitrary radius
globalpara.center_position = [randi([20 30]) randi([20 30]) randi([20 30])];  % tuple [x,y,z]
globalpara.center_radius = randi([10 15]); % any given radius
delta = 0;

draw_sphere();
hold on

globalpara.init_randx = 50;
globalpara.init_randy = 50;
globalpara.init_randz = 50;
init_rand_x = globalpara.init_randx;
init_rand_y = globalpara.init_randy;
init_rand_z = globalpara.init_randz;


position = cell(globalpara.numUAV,1);
for i=1:globalpara.numUAV
    position_init(i,1) = randi([init_rand_x-30 init_rand_x+30]);        % m (East)
    position_init(i,2) = randi([init_rand_y-30 init_rand_y+30]);        % m (North)
    position_init(i,3) = randi([init_rand_z-30 init_rand_z+30]);        % m (height)
    position{i} = position_init(i,:);
end

%position = initialize(); % TYPE: cell, numUAV * TIMES

numcolor = 40;
c = rand(numcolor,3); % create colow number same as number of UAV

% isnot_on_sphere = norm(own_position - globalpara.center_position)^2 ~= globalpara.center_radius^2
% while isnot_on_sphere
% while check_sentence
ITERATE = 1;
for id = 1:globalpara.numUAV
    while (norm(position{id,1}(end,:) - globalpara.center_position) < (globalpara.center_radius - delta)) || (norm(position{id,1}(end,:) - globalpara.center_position) > (globalpara.center_radius + delta))
        for i = 1:globalpara.numUAV
            own_position = position{i,1}(ITERATE,:); % Initial position, row vector [x y z]
            %         plot3(own_position(1), own_position(2), own_position(3),'*','color',c(i,:));
            %         hold on
            %         pause(0.005);
            %% ======================================== compute velocity_vector =============================== %%
            factor1 = (globalpara.center_radius - norm(own_position - globalpara.center_position)) / norm(own_position - globalpara.center_position); % type: scalar
            cumsum_factor2 = 0;
            for j = 1: globalpara.numUAV
                %%%% due to the undirected complete graph, weight is 1 when i != j; weight = 0 when i = j %%%%%%%%%%%%%%
                other_position = position{j,1}(end,:); % row vector [x y z]
                if i ~= j
                    weight_i_j = 1;
                    % x_i = position(for own UAV), x_j = position (for other UAV)
                    R_i = lie_group_isomorphism (own_position);
                    R_j = lie_group_isomorphism (other_position);
                    %                 test_1 = trace((logm(R_j.' * R_i)^2))
                    %                 test_2 = trace((logm(R_j.' * R_i))^2)
                    factor2 = (2 * weight_i_j / (globalpara.center_radius * norm(own_position - globalpara.center_position) * trace((logm(R_j.' * R_i))^2))) * logm(R_j.' * R_i);
                    cumsum_factor2 = cumsum_factor2 + factor2;
                else
                    weight_i_j = 0;
                    % x_i = position(for own UAV), x_j = position (for other UAV)
                    R_i = lie_group_isomorphism (own_position);
                    R_j = lie_group_isomorphism (other_position);
                    %                 test_1 = trace((logm(R_j.' * R_i)^2))
                    %                 test_2 = trace((logm(R_j.' * R_i))^2)
                    factor2 = (2 * weight_i_j / (globalpara.center_radius * norm(own_position - globalpara.center_position) * trace((logm(R_j.' * R_i))^2))) * logm(R_j.' * R_i);
                    cumsum_factor2 = cumsum_factor2 + factor2;                    
                end
            end
            velocity_vector = factor1 * (own_position - globalpara.center_position) + (own_position - globalpara.center_position) * cumsum_factor2;
            %% ======================================= update position ==================================== %%
            new_position = own_position + velocity_vector * globalpara.time_step;
            position{i,1}(ITERATE+1,:) = new_position;
            %         plot3(own_position(1), own_position(2), own_position(3),'o','color',c(i,:));
            %         hold on
            %         pause(0.005);
        end
        ITERATE = ITERATE + 1;
    end
end

colorm = ['or'; 'og'; 'ob'; 'oc'; 'om'; 'oy'; 'ok'; 'xr'; 'xg'; 'xb'; 'xc'; 'xm'; 'xy'; 'xk'; '+r'; '+g'; '+b'; '+c'; '+m'; '+y'; '+k'];

for k = 1: length(position{1,1})
    for kk = 1:globalpara.numUAV
        plot3(position{kk,1}(k,1), position{kk,1}(k,2), position{kk,1}(k,3),colorm(kk,:));
        hold on
        pause(0.005);
    end
end