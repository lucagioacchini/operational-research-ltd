function [M, B] = map(B, M, s, d, N)
    if ismember(s,M(:,2))==0
        for i=1:N
            if M(i,2)==0
                M(i,2)=s;
                for j=1:N
                    if B(s,j)==1 && M(j,2)==0 && ismember(d,M(:,2))==0
                        M(j,2)=d;
                        B(i,j)=0;
                        B(j,i)=0;
                        break
                    end
                end
                break
            end
        end
    else
        m_idx = find(M(:,2)==s);
        for j=1:N
            if B(m_idx,j)==1 && M(j,2)==0 && ismember(d,M(:,2))==0
                M(j,2)=d;
                B(m_idx,j)=0;
                B(j,m_idx)=0;
                break
            elseif B(m_idx,j)==1 && M(j,2)~=0
                B(m_idx,j)=0;
                B(j,m_idx)=0;
            end
        end
        
    end
end