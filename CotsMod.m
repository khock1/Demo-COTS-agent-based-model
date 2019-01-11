function [ cotspop, cotsmap, cotspositions, coralpop, coralmap, coralchange ] = CotsMod( row, col, prccover, numclusters, initcotsnum, days, numyears, startdate  )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% The main file that runs the COTS agent-based model;
% see individual function files for detaisl of the model routines

%SETTING UP----------------------------------------------------------------

%startdate has a format of [1900 1 28]
[ dateofseasonchange ] = seasonchanges( numyears, startdate );

%this sets up the grid on which the model will run; get cell coordinates and their links as a network/lattice
[grid, cellcoords] = generateGrid( row, col );

%this sets up coralmap as the map that contains the info on which cells are 
%occupied by coral at a given timestamp; also provides the initial distribution of coral populations
coralmap = populatecoral( cellcoords, prccover, numclusters );

%this sets up cotsmap as the map of locations of COTS individuals for a
%given timestamp; also provides the initial distribution of COTS on a map
cotsmap = populatecots( cellcoords, initcotsnum );%cotspop is the map of cells occupied by COTS agents

%track coral population, which cells have coral
coralpop=zeros(size(find(coralmap),1),5);
[coralpop(:,2),coralpop(:,3)]=find(coralmap);
for c=1:size(find(coralmap),1)
    coralpop(c,1)=find(ismember(cellcoords,[coralpop(c,2) coralpop(c,3)], 'rows'));
end
coralpop(:,4)=0.05;%initial amount of coral seeded in a cell; determines how fast the COTS will deplete it and move on
coralpop(:,5)=1;%type of coral seeded; for now, ther eis only one type

%this sets up the container to track changes in coral per cell
coralchange=zeros(size(find(coralmap),1),5,days+1);

%this sets up the characteristics of COTS agents; the values are:
%1st size
%2nd class
%3rd amount eaten per day during summer
%4th amount eaten per day during winter
%5th satiation state
%6th speed in metres/moves per day
%7th alive or dead
initmoves=10;%some initial value; not stochastic at the moment
cotspop=zeros(numel(find(cotsmap)),7);
cotspop(:,1)=0.4;%standard adult size of 0.4m
cotspop(:,2)=5;%full adults are category 5; JUV0, JUV1, ADL1, ADL2, ADL3+
cotspop(:,3)=0.03;%this is value for adults during summer
cotspop(:,4)=0.012;%this is value for adults during winter
cotspop(:,5)=0;%totally hungry to begin with!
cotspop(:,6)=initmoves;%start with full movement
cotspop(:,7)=1;%all seeded COTS are alive at start

%track the positions of cots after each day
%this records positions of cots at the end of each day; start with the first day here
%1st row is current cell, 2nd row is current cell's X, 3rd current current cell's Y, 4th moves left
cotspositions=zeros(numel(find(cotsmap)),3,days+1);
[cotspositions(:,2,1),cotspositions(:,3,1)]=find(cotsmap);
for c=1:size(find(cotsmap),1)
    cotspositions(c,1,1)=find(ismember(cellcoords,[cotspositions(c,2,1) cotspositions(c,3,1)], 'rows'));
end

%RUNNING MODEL DAILY-------------------------------------------------------

date=datenum(startdate);
season=2;%start in summer
for day = 1:days
    season=determineseason(date,season, dateofseasonchange);
    
    %move cots around fro this day
    cotstrack = cotswalk( cotspop, cotspositions(:,:,day), coralpop, grid, cellcoords );
    cotspositions(:,:,day+1)=cotstrack;%update cotsmap to reflect the new locations

    %this determines what COTS ate this day
    [ cotspop, coralpop ] = cotsfeed( cotspop, cotstrack, coralpop, cellcoords, season );
    coralchange(:,:,day+1)=coralpop;%update coral to reflect the amounts eaten by COTS this day
    date=date+1;%track dates to determien whether the season changes etc.
end

end
