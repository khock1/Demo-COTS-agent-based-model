function [grid, cellcoords, edges] = generateGrid( row, col )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% transform the grid map into a bounded lattice, for later use in movements and
% determining preferential spatial behaviour

[ii jj] = sparse_adj_matrix([row col], 1, inf);
grid = sparse(ii, jj, ones(1,numel(ii)), row*col,row*col);
grid(1:row*col+1:row*col*row*col) = 0;

[edges(:,1),edges(:,2)]=find(grid);
ct=1;
cellcoords=zeros(row*col,2);
for i=1:row
    for j=1:col
        cellcoords(ct,1)=i;
        cellcoords(ct,2)=j;
        ct=ct+1;
    end
end

end
