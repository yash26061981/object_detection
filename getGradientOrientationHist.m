function orientationBins = getGradientOrientationHist(gradientAngle, gradientImage)

    [row,col] = size(gradientAngle);
    blockSize = 16;
    cellSize = 8;
    blockRowSize = fix(row/blockSize);
    blockColSize = fix(col/blockSize);
    totalbins = 9;
    
    stride = 8;
    rowId = 1:stride:(row-blockSize);
    colId = 1:stride:(col-blockSize);
    weight = getGaussianSpatialWindow(0,cellSize,blockSize);
%     cellOreintationHistogram = repmat(struct('orientationHist',zeros(1,totalbins)),...
%         blockSize/cellSize, blockSize/cellSize);
%     orientationBins = repmat(struct('blockOreintationHistogram',[]), blockRowSize, blockColSize);
    orientationBins = [];
    rInd = 1;
    for r = rowId
        cInd = 1;
        for c = colId       
            croppedAngleImg = gradientAngle(r:r+blockSize-1,c:c+blockSize-1);
            croppedMagnitudeImg = gradientImage(r:r+blockSize-1,c:c+blockSize-1);
            rInd1 = 1; 
            blockDescriptor = [];
            for r1 = 1: cellSize:blockSize
                cInd1 = 1;                
                for c1 = 1: cellSize:blockSize
%                     stIndx = (r1-1)*rInd1 + c1;
%                     edIndx = stIndx+8-1;
                    cellAngleImg = croppedAngleImg(r1:r1+cellSize-1,c1:c1+cellSize-1);
                    cellMagnitudeImg = croppedMagnitudeImg(r1:r1+cellSize-1,c1:c1+cellSize-1);
                    histBin = getHistBin(cellAngleImg, cellMagnitudeImg, [0 180], totalbins, weight(c1:cInd1*cellSize));
                    blockDescriptor = [blockDescriptor histBin];
                    cInd1 = cInd1 + 1;
                end
                rInd1 = rInd1 + 1;
            end
            normBlockDesc = applyL2HysClippedNorm(blockDescriptor);
            orientationBins = [orientationBins;normBlockDesc];
%             orientationBins(rInd, cInd).blockOreintationHistogram = normBlockDesc ;
            cInd = cInd + 1;
        end
        rInd = rInd + 1;
    end
end

function histbin = getHistBin(cellAngleImg,cellMagnitudeImg, range, bins, weight)
    histbin = zeros(1,bins);
    cluster = (max(range) -  min(range))/bins;
    [row, col] = size(cellAngleImg);
    for r = 1: row
        for c = 1:col
            bin = ceil(cellAngleImg(r,c)/cluster);
            if(bin == 0) bin = 1; end
            histbin(bin) = histbin(bin) + weight(c)*cellMagnitudeImg(r,c); 
        end
    end
end

function desc = applyL2HysClippedNorm(descriptorVect)
    
    clippedVal = 0.2;
    normOfDesc = sqrt(sum(abs(descriptorVect).^2));
    desc = descriptorVect./normOfDesc;
    desc(desc > clippedVal) = clippedVal;
    normOfDesc = sqrt(sum(abs(desc).^2));
    desc = desc./normOfDesc;    

end