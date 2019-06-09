function c = meshGrid(i,j,n_row, n_col)
    c = false;
    if mod(i-1, n_col) == 0 && j == n_col*ceil(i/n_row)
        c = true;
    elseif i ~= j && j == i+1 && mod(i,n_col) ~= 0
        c = true;
    elseif i ~= j && j== i+ n_col
        c = true;
    elseif i <= n_col && j == i+ n_col*(n_row-1)
        c = true;
    elseif mod(j-1,n_col) == 0 && i == n_col*ceil(j/n_row)
        c = true;
    elseif j ~= i && i == j+1 && mod(j,n_col) ~= 0
        c = true;
    elseif j~= i && i==j+n_col
        c = true;
    elseif j <= n_col && i==j+n_col*(n_row-1)
        c = true;
    end
end