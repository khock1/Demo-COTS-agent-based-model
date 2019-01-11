function [ dateofseasonchange ] = seasonchanges( numyears, startdate )

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Determine when season changes to change COTS behaviour

seasonchange1=[4 1];%winter starts April 1st
seasonchange2=[10 1];%summer stats October 1st
yr=startdate(1)-1;
ssn=1;
dateofseasonchange=zeros((numyears*2),1);
for i=1:(numyears*2)
    if mod(ssn,2)
        dateofseasonchange(i,1)=datenum([yr seasonchange1]);
        ssn=ssn+1;
    else
        dateofseasonchange(i,1)=datenum([yr seasonchange2]);
        ssn=ssn+1;
        yr=yr+1;
    end

end

