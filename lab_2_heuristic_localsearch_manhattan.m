close all
clear all
clc

% include
addpath(strcat(pwd,'/lib/'))

% parameters
rng(69)
N = 6;
D = 2;
a = 0;
b = 4;

n_row = floor(sqrt(N));
n_col = ceil(N/n_row);

B_map = zeros(N,N);
M = zeros(N,2);
M(:,1)=1:N;

% init
[T,B] = initializationMesh(a,b,N);

% map B matrix
[T_sorted,idx] = sort(T(:),'descend');
temp_B = B;
for i=1:size(T_sorted, 1)
    [s, d] = ind2sub([N,N], idx(i));
    [M, temp_B] = map(temp_B, M, s, d, N);
end

% nodes placement
for i=1:N
    for j=1:N
        B_map(M(i,2),M(j,2)) = B(i,j);
    end
end

% graph init
G = digraph(B_map);
height_table = size(G.Edges.EndNodes,1);
G.Edges.Weight = zeros(height_table,1);
for i=1:height_table
    G.Edges.Weight(i)=T(G.Edges.EndNodes(i,1),G.Edges.EndNodes(i,2));
end

% route the first traffic
for i=1:N
    for j=1:N
        w = T(i,j);
        if w~=0 && B_map(i,j)~=1
            shortpath = shortestpath(G, i, j, 'Method','positive');
            for k=1:(size(shortpath,2)-1)
                i_ = shortpath(1,k);
                j_ = shortpath(1,k+1);
                for pos_i = 1:size(G.Edges.EndNodes,1)
                    if G.Edges.EndNodes(pos_i,1) == i_ && G.Edges.EndNodes(pos_i,2) == j_
                        link_index = pos_i;
                    end
                end
                    G.Edges.Weight(link_index) = G.Edges.Weight(link_index) + w;
            end
        end
        break
    end
end

% plot the original graph
figure
plot(G,'EdgeLabel',G.Edges.Weight)

%% Greedy Heuristic
sol = [0,0];
sol_min_F = 0;
sol_min_U = 0;

fprintf('Applying the heuristic...\n')
[G, Taboo, Free] = reRouteGrid (G, N, D);

% update the solution array
sol(1,1) = max(G.Edges.Weight);
% if the solution is unfeasible
if (all((outdegree(G)<=D))==0 && all((indegree(G)<=D))==0)
    sol(1,2) = 1;
    % initialize the minimum unfeasible Graph and Max flow
    G_min_U = G;
    sol_min_U = max(G.Edges.Weight);
else
    % initialize the minimum feasible Graph and Max flow
    G_min_F = G;
    sol_min_F = max(G.Edges.Weight);
end

%% Local Search
G_def = G;
fprintf('Applying the local search...\n')
for i = 1:size(Taboo,1)
    % restore the default graph
    G = G_def;
    % store the edge information
    for k=1:size(G.Edges.EndNodes,1)
        if G.Edges.EndNodes(k,:)==[Taboo(i,1), Taboo(i,2)]
            edg_temp = G.Edges(k,:);
            break
        end
    end
    
    % remove the edge
    G = rmedge(G,Taboo(i,1), Taboo(i,2));
    
    for j=1:size(Free,1)
        % add the new edge
        G_new = addedge(G,Free(j,1), Free(j,2),0);

        % if the new graph is connected
        if connectedGraph(G_new, N)
            % evaluate the shortest path between source and 
            %destination of the removededge
            short = shortestpath(G_new,Taboo(i,1), Taboo(i,2),'Method','positive');

            % update the shortest path nodes weights
            for k=1:(size(short,2)-1)
               i = short(1,k);
               j = short(1,k+1);
               for pos = 1:size(G_new.Edges.EndNodes,1)
                   if G_new.Edges.EndNodes(pos,1) == i && G_new.Edges.EndNodes(pos,2) == j
                       link_index = pos;
                   end
               end
               G_new.Edges.Weight(link_index) = G_new.Edges.Weight(link_index) + edg_temp.Weight;
            end
            fprintf('Re-applying the heuristic...\n')
            [G_temp, Taboo_temp, Free_temp] = reRouteGrid(G_new, N, D);

            % update the solution array
            sol(end+1,:) = [max(G_temp.Edges.Weight),0];
            % if the solution is unfeasible
            if (all((outdegree(G_temp)<=D))==0 && all((indegree(G_temp)<=D))==0)
                % mark it
                sol(end,2) = 1;
                % update the minimum unfeasible solution and graph
                if sol_min_U ~= 0
                    if max(G_temp.Edges.Weight) < sol_min_U
                        G_min_U = G_temp;
                        sol_min_U = max(G_temp.Edges.Weight);
                    end
                else
                    G_min_U = G_temp;
                    sol_min_U = max(G_temp.Edges.Weight);
                end
            % if the solution is feasible
            else
                % update the minimum feasible solution and graph
                if sol_min_F ~= 0
                    if max(G_temp.Edges.Weight) < sol_min_F
                        G_min_F = G_temp;
                        sol_min_F = max(G_temp.Edges.Weight);
                    end
                else
                    G_min_F = G_temp;
                    sol_min_F = max(G_temp.Edges.Weight);
                end
            end
        end
    end
end

% recover info for plotting feasible/unfeasible solutions
for i=1:size(sol,1)
    k = find(sol(:,2)==0);
    feasible = sol(k,1);
end

% plot the local search solutions
figure
p1 = plot(sol(:,1), '-.k');
p1.Color(4) = 0.3;
hold on
p2 = plot(sol(:,1), 'ko');
hold on
p3 = plot(k, feasible, 'r*');

legend([p2,p3],'Unfeasible', 'Feasible', 'Location','northwest');
xlabel('Iterations');
ylabel('MaxFlow');
hold off

% plot the minimum feasible graph
if sol_min_F ~= 0
    fprintf('Minimum Feasible MaxFlow:\n%i\n', sol_min_F)
    figure
    plot(G_min_F,'EdgeLabel',G_min_F.Edges.Weight)
end
% plot the minimum unfeasible graph
if sol_min_U ~= 0
    fprintf('Minimum Unfeasible MaxFlow:\n%i\n', sol_min_U)
    figure
    plot(G_min_U,'EdgeLabel',G_min_U.Edges.Weight)
end
