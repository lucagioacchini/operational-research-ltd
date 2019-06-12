close all
clear all
clc

% include
addpath(strcat(pwd,'/lib/'))

% init
rng(69)
N = 10;
D = 4;
a_l = 0;
b_l = 3;
a_h = 5;
b_h = 15;
[T,B] = initializationUnbalanced(a_l,b_l,a_h,b_h,N);

% graph init
G = digraph(B);
W = reshape(T', [N*N,1]);
W(1:N+1:end) = [];
G.Edges.Weight = W;

% plot the original graph
figure
plot(G,'EdgeLabel',G.Edges.Weight)

%% Greedy Heuristic

fprintf('Applying the heuristic...\n')
[G, Taboo, Free] = reRouteMesh (G, N, D);

if (all((outdegree(G)<=D))==0 && all((indegree(G)<=D))==0)
    fprintf('Minimum Unfeasible MaxFlow:\n%i\n', max(G.Edges.Weight))
else
    fprintf('Minimum Feasible MaxFlow:\n%i\n', max(G.Edges.Weight))
end

figure
plot(G,'EdgeLabel',G.Edges.Weight)
