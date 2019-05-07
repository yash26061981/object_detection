function [gradientImage, gradientAngle] = getGradientImg(inImg, direction, mask)
     
    doSquare = false;
    inImg = double(inImg);
    [maskr, maskc] = size(mask);
    padMask = [fix(maskr/2) fix(maskc/2)];
    inImg = padarray(inImg, padMask, 'both');
    [row,col] = size(inImg);
    tempGradientValueImg = (zeros(row,col));
    tempGradientAngleImg = (zeros(row,col));
    
    maskX = mask; maskY = mask;
    scaleX = 0; scaleY = 0;
    switch direction
        case 'vertical'
            scaleY = 1;
            if(padMask(1) == 0)
                maskY = maskY';
            end
            if(padMask(2) == 0)
                maskX = zeros(size(mask));
                maskX(ceil(length(mask)/2)) = 1;
            end

        case 'horizontal'
            scaleX = 1;
            if(padMask(2) == 0)
                maskX = maskX';
            end
            if(padMask(1) == 0)
                maskY = zeros(size(mask));
                maskY(ceil(length(mask)/2)) = 1;
            end
 
        otherwise
            scaleX = 1;
            scaleY = 1;
            
    end
    for r = padMask(1)+1:row - padMask(1)
        for c = padMask(2)+1:col - padMask(2)
            Gx = sum(sum(maskX .* inImg(r-padMask(1):r+padMask(1),c-padMask(2):c+padMask(2))));
            Gy = sum(sum(maskY .* inImg(r-padMask(1):r+padMask(1),c-padMask(2):c+padMask(2))));
            if doSquare
                tempGradientValueImg(r,c) = sqrt((scaleX * Gx * Gx) + (scaleY * Gy * Gy));
            else
                tempGradientValueImg(r,c) = (scaleX * Gx) + (scaleY * Gy);
            end
            
            tempGradientAngleImg(r,c) = min(max(0,abs(atan2d(Gy,Gx))),180);
%             if(tempGradientAngleImg(r,c) < 0)
%                 tempGradientAngleImg(r,c) = -1 * tempGradientAngleImg(r,c);
%             end
        end
    end
    gradientImage = tempGradientValueImg(padMask(1)+1:row - padMask(1),padMask(2)+1:col - padMask(2));
    gradientAngle = tempGradientAngleImg(padMask(1)+1:row - padMask(1),padMask(2)+1:col - padMask(2));
%     outEdgeImg =  %cast(tempEdgeImg,'uint8');
end