function get_animations(row, col, coralchange, coralpop, cotspositions, cotspop)

% Agent-based model of COTS individuals moving across a reef with coral patches
% (c) Karlo Hock, University of Queensland, 2016; updated with descriptions to v2 in 2019

% Return simple gif animations for cots movements and coral changes

% transform the changes in coral presence within each cell into a heatmap that
% changes colours over time
filename = 'coraldecline.gif';
colormap hot;
for n = 1:(size(coralchange,3)-1)
    coralmap2=zeros(row,col);
    for i=1:size(coralpop,1)%transform into frames
        coralmap2(coralchange(i,2,n+1),coralchange(i,3,n+1))=coralchange(i,4,n+1);
    end
    imagesc(coralmap2);
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if n == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end

% transform the outputs on COTS movements into a gif animation with individual COTS
% moving around until they encoutner coral and settle to start eating
filename = 'cotsdistribution.gif';
for n = 1:(size(cotspositions,3)-1)
    cotsmap2=zeros(row,col);
    for i=1:size(cotspop,1)
        cotsmap2(cotspositions(i,2,n+1),cotspositions(i,3,n+1))=cotsmap2(cotspositions(i,2,n+1),cotspositions(i,3,n+1))+1;
    end
    imagesc(cotsmap2);
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if n == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
end

