function plot_coral_decline(coralchange)

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Draw a quick graph of coral cover decline as a proportion of initial cover

coral_cover=zeros(size(coralchange,3),1);
for t=1:size(coralchange,3)
    coral_cover(t)=nnz(coralchange(:,4,t)>0)/size(coralchange,1);
end

plot(1:size(coralchange,3),coral_cover);
title('Coral cover decline from initial cover', 'FontSize', 11);
xlabel('Days');
ylabel('Coral cover');
end

