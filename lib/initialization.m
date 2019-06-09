function [T, B] = initialization(a,b,N)
    T = zeros(N,N);
    
    for i=1:N
        for j=1:N
             if i~=j
                T(i,j) = a + (b-a)*rand(1,1); %Uniform(0,4)
%                   T(i,j) = randi([0,4],1,1);  
             end
        end
    end
    B = ones(N,N) - eye(N); %Full mesh topology, zeros on the diagonal

end