function [T, B] = initializationMesh(a,b,N)
    T = zeros(N,N);
    n_row = floor(sqrt(N));
    n_col = ceil(N/n_row);
    for i=1:N
        for j=1:N
             if i~=j
                T(i,j) = a + (b-a)*rand(1,1); %Uniform(0,4)
             end
        end
    end
    B = zeros(N,N); %Full mesh topology, zeros on the diagonal
    
    for i=1:N
        for j=1:N
            if meshGrid(i,j,n_row,n_col)
                B(i,j) = 1;
            end
            
        end
    end
end