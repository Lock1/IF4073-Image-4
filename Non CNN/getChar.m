function charRes = getChar(I)
    binaryImg = imbinarize(I, graythresh(I));
    %'NOT' operation for dark font in light background
    if bwarea(binaryImg) > size(binaryImg,1) * size(binaryImg,2) / 2
        binaryImg = ~binaryImg;
    end
    binaryImg = imerode(binaryImg, strel('disk', 3));
    binaryImg = imclearborder(binaryImg,8);
    binaryImg = bwareaopen(binaryImg, 100);
    L = binaryImg;
    maxSegment = 0;
    segmentSum = 0;
    for i = 1:36
        newL = bwareafilt(binaryImg,i);
        newSegmentSum = bwarea(newL);
        newSegmentArea = newSegmentSum - segmentSum;
        if newSegmentArea < 0.3 * maxSegment
            break;
        end
        segmentArea = newSegmentArea;
        if segmentArea > maxSegment
            maxSegment = segmentArea;
        end
        L = newL;
        segmentSum = newSegmentSum;
    end
    %imshow(L);
    % crop row
    rowBlocks = bwareafilt(max(L, [], 2), 1);
    topRow = 0; 
    botRow = 0;
    for y = 1: size(rowBlocks, 1)
        if topRow == 0 && rowBlocks(y)
            topRow = y;
        elseif topRow ~= 0 && ~rowBlocks(y)
            botRow = y-1;
            break;
        end
    end
    if botRow == 0
        botRow = size(rowBlocks);
    end
    L = L(topRow:botRow,:);
    colBlocks = max(L,[],1);
    leftCol = 0;
    charRes = logical([]);
    for x = 1: size(colBlocks, 2)
        if leftCol == 0 && colBlocks(x)
            leftCol = x;
        elseif leftCol ~= 0 && (~colBlocks(x) || x == size(colBlocks, 2)) 
            rightCol = x - 1;
            C = L(:, leftCol:rightCol);
            topRow = 0; 
            botRow = 0;
            rowBlocks = max(C, [], 2);
            for y = 1: size(rowBlocks, 1)
                if topRow == 0 && rowBlocks(y)
                    topRow = y;
                elseif topRow ~= 0 && ~rowBlocks(y)
                    botRow = y - 1;
                    break;
                end
            end
            if botRow == 0
                botRow = size(rowBlocks);
            end
            C = C(topRow:botRow, :);
            charRes = cat(3,charRes,imresize(C, [128 128]));
            leftCol = 0;
        end
    end
end