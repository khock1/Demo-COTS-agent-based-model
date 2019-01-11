function [ season ] = determineseason(  date, season, dateofseasonchange )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Determine whether it is summer or winter to determine COTS behaviour

if ismember(date,dateofseasonchange) && season==1
    season=2;
end
if ismember(date,dateofseasonchange) && season==2
    season=1;
end

end

