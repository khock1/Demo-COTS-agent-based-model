function [coralmap, clusterinit] = populatecoral( cellcoords, prccover, numclusters )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019


% Create an artifical (for now) coral landscape that repreesents areas with
% and without coral cover; the map is populated by coral by growing 
% from initial seed locations up to the point when the proportion of cells 
% (given by the initial coral cover) is filled with coral


coralmap=zeros(max(cellcoords(:,1)),max(cellcoords(:,2)));

numcells=size(cellcoords,1);
initialcellswithcover=round(numcells*prccover);%target initial coral cover

clusterinit=datasample(1:numcells,numclusters,'Replace',false);%initial seed locations from which coral clusters will grow
filledcells=0;
for initcor=1:length(clusterinit)%populate initial seeds of coral clusters
    coralmap(cellcoords(clusterinit(initcor),1),cellcoords(clusterinit(initcor),2))=1;
    filledcells=filledcells+1;
end

nghb=[1 1 1;1 0 1; 1 1 1];%cell's neighbourhood to check
for i=filledcells:(initialcellswithcover-1)
    cells2grow=[];
    cellswithpop=[];
    neighbmap=[];
    neighbmap=conv2( coralmap, nghb, 'same' );
    [cellswithpop(:,1),cellswithpop(:,2)]=find(coralmap);%take all filled cells
    [cells2grow(:,1),cells2grow(:,2),v]=find(neighbmap);%return neighbouring cells
    alreadyoccupied=ismember(cells2grow,cellswithpop,'rows');%check if neighbouring cells are empty
    cells2grow=[cells2grow v];%grow cells that have neihgghbours
    cells2grow(find(alreadyoccupied),:)=[];
    growthis=datasample(1:size(cells2grow,1),1,'Replace',false,'Weights',cells2grow(:,3));%pick a random cell based on number of neighbours
    coralmap(cells2grow(growthis,1),cells2grow(growthis,2))=1;%grow coral in that cell
end

end

