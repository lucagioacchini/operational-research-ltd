function [G, Taboo, Free] = reRoute(G, N, D)
    cnt = 0;
    Taboo = [0,0];
    Free = [0,0];
        
    while true
        [Sortd, idx] = sort(G.Edges.Weight,'ascend');
        [m, edg] = findMin(Sortd, idx, Taboo, G);

        if size(Sortd,1) == size(Taboo,1)
            break
        end

        % try to remove the edge
        G = rmedge(G,edg(1),edg(2));
        % if the new graph is not connected
        if ~connectedGraph(G, N)
            % readd the edge and the weight
            G = addedge(G,edg(1),edg(2),m);
            % mark the edge as unremovable by adding it to Taboo
            if Taboo == [0,0]
                Taboo = [edg(1),edg(2)];
            else
                Taboo(end+1,:) = [edg(1),edg(2)];    
            end   
        % if the new graph is still connected
        else
           if Free == [0,0]
               Free = [edg(1),edg(2)];
           else
               Free(end+1,:) = [edg(1),edg(2)];    
           end   
           % determine the shortest path 
           short = shortestpath(G,edg(:,1),edg(:,2),'Method','positive');
           % update the shortest path nodes weights
           for k=1:(size(short,2)-1)
               i = short(1,k);
               j = short(1,k+1);
               for pos = 1:size(G.Edges.EndNodes,1)
                   if G.Edges.EndNodes(pos,1) == i && G.Edges.EndNodes(pos,2) == j
                       link_index = pos;
                   end
               end
               G.Edges.Weight(link_index) = G.Edges.Weight(link_index) + m;
           end
        end
        cnt = cnt +1;
    end
end