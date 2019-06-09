function is_connected = connectedGraph(G,N)

is_connected = true;
uniques = unique(G.Edges.EndNodes);
    for i=1:size(uniques,1)
%         s = G.Edges.EndNodes(i,1);
        bf = bfsearch(G,i);
        if size(bf,1) < N
            is_connected = false;
        end
    end
end