close all
clear all
clc

% include
addpath(strcat(pwd,'/lib/'))

% init
rng(69)
N = 10;
D = 2;
a = 0;
b = 4;
[T,B] = initialization(a,b,N);

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
[G, Taboo, Free] = reRoute (G, N, D);

if (all((outdegree(G)<=D))==0 && all((indegree(G)<=D))==0)
    fprintf('Minimum Unfeasible MaxFlow:\n%i\n', max(G.Edges.Weight))
else
    fprintf('Minimum Feasible MaxFlow:\n%i\n', max(G.Edges.Weight))
end

figure
plot(G,'EdgeLabel',G.Edges.Weight)