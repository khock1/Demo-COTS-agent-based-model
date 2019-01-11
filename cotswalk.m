function [ cotstrack ] = cotswalk( cotspop, cotstrackO, coralpop, grid, cellcoords )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% COTS daily movement routine; movements within each day are subdivided
% into cell-to-cell steps, and the satiation state is the main determinant of
% the number of moves an individual will make in a day (hungry individuals
% are motivated to move more); hungry individuals move towards coral when
% close by, i.e. they change their movement behaviour to home in on food;
% individuals stop moving if they encounter coral and start eating, and
% move again once they ahve eaten the coral;
% cotstrack output returns the resultant daily movements

numcots=nnz(find(cotspop(:,7)));%see if individuals are alive or dead first, and whether of age that feeds on coral

%this routine performs and records the moves within a day for each COTS individual
moves=cotspop(:,6);
cotstrack=cotstrackO;
for thiscots=1:numcots
    if (cotspop(thiscots,7))~=0%if this cots is alive
        currentcell=find(ismember(cellcoords,[cotstrack(thiscots,2) cotstrack(thiscots,3)], 'rows'));%find which cell this cots is in right now
        while moves(thiscots,1)~=0%as long as there are moves left in a day; this will be set up based on previous calculations of satiation state etc.
            %if in coral, stay and eat
            if coralpop(find(coralpop(:,1)==currentcell),4)>0
                moves(thiscots,1)=0;
            else
                [ngb,ngbIndices]=findneighbcells(currentcell, cellcoords);
                ngbwithcoralIndices=ngbIndices(ismember(ngb,coralpop(:,2:3),'rows'));%test if neighbour cells have coral; if not and this is empty, keep moving
                %if not in coral but next to it, move there; if >1 option to move to, choose randomly (no preferences yet)
                if numel(ngbwithcoralIndices)>0
                    nextcell=ngbwithcoralIndices(datasample(1:size(ngbwithcoralIndices,1),1));%randomly choose a neighbouring cell
                    cotstrack(thiscots,2)=ngb(ngbwithcoralIndices==nextcell,1);
                    cotstrack(thiscots,3)=ngb(ngbwithcoralIndices==nextcell,2);
                    cotstrack(thiscots,1)=nextcell;
                    moves(thiscots,1)=0;%set remaining moves to zero, stop there; implement differen stopping behaviours later
                else%if not next to coral, move to a neighbouring cell until movements are exhausted
                    nextcell = RandomGraphMove(currentcell,grid);
                    cotstrack(thiscots,2)=ngb(ngbIndices==nextcell,1);
                    cotstrack(thiscots,3)=ngb(ngbIndices==nextcell,2);
                    cotstrack(thiscots,1)=nextcell;
                    moves(thiscots,1)=moves(thiscots,1)-1;%reduce moves left in a day by one
                end
                currentcell=nextcell;
            end
        end
    end
end


end

