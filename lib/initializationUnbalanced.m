function [T, B] = initializationUnbalanced(a_l,b_l,a_h,b_h,N)
    T = zeros(N,N);
    low = floor((N*N)*95/100);
%     high = (N*N) - low;
    cnt = 1;
    for i=1:N
        for j=1:N
             if i~=j && cnt <= low
                T(i,j) = a_l + (b_l-a_l)*rand(1,1); %Uniform(0,4)
%                   T(i,j) = randi([0,4],1,1);  
             elseif i~=j && cnt > low
                 T(i,j) = a_h + (b_h-a_h)*rand(1,1); 
             end
             cnt = cnt + 1;
        end
        
    end
    B = ones(N,N) - eye(N); %Full mesh topology, zeros on the diagonal

end