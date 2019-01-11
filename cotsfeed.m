function [ cotspop, coralpop ] = cotsfeed( cotspopO, cotstrack, coralpopO, cellcoords, season )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% COTS feeding and metabolism routine which also sets the speed/number of
% moves to be made in a day; COST of different sizes consume differnt
% amounts of coral within a cell; this changes their satiation state;
% satiation decreases when mvoing, motivating COTS to move more when hungry;
% COTS eat different amounts in winter vs summer due to slower metabolism; 


%get cots feeding at different rates depedning on season
cotspop=cotspopO;coralpop=coralpopO;

%for cotspop, the values are:
%1st size
%2nd class
%3rd amount eaten per day during summer
%4th amount eaten per day during winter
%5th satiation state
%6th speed in metres/moves per day
%7th alive or dead

numcots=nnz(find(cotspop(:,7)));

for thiscots=1:numcots
    if (cotspop(thiscots,7))~=0%if this cots is alive
        currentcell=find(ismember(cellcoords,[cotstrack(thiscots,2) cotstrack(thiscots,3)], 'rows'));
        %when in cell with some coral in it, eat the daily amount of coral surface area accordingly
        if coralpop(find(coralpop(:,1)==currentcell),4)>0%if there is a coral in this cell, eat it
            %different feeding rates during different seasons; different
            %amounts eaten by COTS of different sizes
            if season==1%if feeding during summer
                coralpop(find(coralpop(:,1)==currentcell),4)=coralpop(find(coralpop(:,1)==currentcell),4)-cotspop(thiscots,3);
            else%if feeding during winter
                coralpop(find(coralpop(:,1)==currentcell),4)=coralpop(find(coralpop(:,1)==currentcell),4)-cotspop(thiscots,4);
            end
            %satiation state increases every time cots eats by some amount; if 0.1, feeding for 10 days in a row makes a happy cots
            cotspop(thiscots,5)=cotspop(thiscots,5)+0.1;%change this scaling parameter as needed
            if cotspop(thiscots,5)>1
                cotspop(thiscots,5)=1;
            end
        else%if there is no coral in this cell, decrease satiation for not eating
            %satiation state decreases if cots did not end the day on a cell with coral; for now, in 10 days it is very hungry and reaches maximum speed
            cotspop(thiscots,5)=cotspop(thiscots,5)-0.1;%change this scaling parameter as needed
            if cotspop(thiscots,5)<0
                cotspop(thiscots,5)=0;
            end
        end
        %avg speed vs size formula is speed=10.354367 - 2.6113489*log(size)
        %this means max speed will depend on size, and amount of max speed
        %achieved will depend on satiation state - totally hungry cots will
        %move at maximum rate for their size
        cotspop(thiscots,6)=round((10.354367 - 2.6113489*log(cotspop(thiscots,1)))*(1-cotspop(thiscots,5)));
        if cotspop(thiscots,6)>10
            cotspop(thiscots,6)=10;
        end
        if cotspop(thiscots,6)<1
            cotspop(thiscots,6)=1;
        end
    end
end


end

