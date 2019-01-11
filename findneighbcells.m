function [ngb, NGBWC] = findneighbcells( currentcell, cellcoords )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Determine neighbourhood of the cell, i.e. allowed/legal moves; for now, COTS
% only move one cell per move (but possibly more than one move per day)

%the offset of the 1-cell 8-neighbors case
offsetneigh=horzcat([-1; -1; 0; 1; 1;  1;  0; -1],[ 0; 1; 1; 1; 0; -1; -1; -1]); 

ngb=[];
ngb(:,1)=offsetneigh(:,1)+cellcoords(currentcell,1);
ngb(:,2)=offsetneigh(:,2)+cellcoords(currentcell,2);
ngb(ngb(:,1)==0 | ngb(:,2)==0 | ngb(:,1)>max(cellcoords(:,1)) | ngb(:,2)>max(cellcoords(:,2)),:)=[];%remove all neighbours outside grid for corners and edges
NGBWC=zeros(size(ngb,1),1);%this is the row number, i.e. cell index by row, of neighbouring cells, later used to find cells with coral in them
for i=1:size(ngb,1)
    NGBWC(i,1)=find(cellcoords(:,1)==ngb(i,1) & cellcoords(:,2)==ngb(i,2));
end

end

