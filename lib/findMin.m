function [m, edg] = findMin(Sortd, idx, Taboo, G)
    for i=1:size(Sortd,1)
        flag = false;
        m = Sortd(i,1);
        edg = [G.Edges.EndNodes(idx(i),1), G.Edges.EndNodes(idx(i),2)];
        for k=1:size(Taboo,1)
            if (Taboo(k,1) == edg(1) && Taboo(k,2) == edg(2))
                flag = true;
            end
        end
        if flag == false
            break
        end
    end

end