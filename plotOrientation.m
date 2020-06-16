function plotOrientation(I, O, w)
% Present 1. Blue lines: orientation in mask area
% 2. Yellow dots: background area
    [M, N] = size(I);
    block_x = (0 : floor(M/w)-1) * w + 1;
    block_y = (0 : floor(N/w)-1) * w + 1;
    imshow(I,[0 255]),
    hold on
    [m, n] = size(O);
    for i = 1:m
        for j = 1:n
            center_x = block_x(i) + ceil(w/2);
            center_y = block_y(j) + ceil(w/2);
            theta = O(i, j);
            len = w/2;
             line([center_y - len * cos(theta), center_y + len * cos(theta)],...
                 [center_x - len * sin(theta), center_x + len * sin(theta)], 'linewidth', 2);
            %line([center_x - len * cos(theta), center_x + len * cos(theta)],[center_y - len * sin(theta), center_y + len * sin(theta)],'color','b','linewidth', 2);
        end
    end
end