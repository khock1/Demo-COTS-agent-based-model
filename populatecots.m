function cotsmap = populatecots( cellcoords, initcotsnum )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Initialise grid to track COTS and then put COTS on the grid map; 
% for now, COTS are placed at rendom locations initially

cotsmap=zeros(max(cellcoords(:,1)),max(cellcoords(:,2)));
numcells=size(cellcoords,1);

cotsinitloc=datasample(1:numcells,initcotsnum,'Replace',true);

for initcots=1:length(cotsinitloc)%initial locations of COTS individuals on a map
    cotsmap(cellcoords(cotsinitloc(initcots),1),cellcoords(cotsinitloc(initcots),2))=1;
end

end

