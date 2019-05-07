function desc = computeGradientWithHighNorm(filename)

    warning('off')
%     testimg = false(100);
%     st = [5, 30]; ed = [80, 5];
%     y1 = st(2); y2 = ed(2);
%     x1 = st(1); x2 = ed(1);
%     
%     m = (y2-y1)/(x2-x1)
%     c = y1 - m*x1
%     c1 = c+100;
%     for i = 5:80
%         j = fix(m*i+c);
%         testimg(i,j) = true;
%         j = fix(m*i+c1);
%         testimg(i,j) = true;
%     end
%     imshow(testimg)
%     img = imread('D:\ObjectDetection\MatlabCode\test1.png');
    img = imread(filename);
    doSmoothing = false;
    if doSmoothing
        gaussfilter = fspecial('gaussian',[5 5]);
        blurimg = imfilter(img,gaussfilter,'same');
        img = blurimg;
    end

    mask = [-1 0 1];
    [gradImgChannel1, gradAngleChannel1] = getGradientImg(img(:,:,1), 'horizontal', mask);
    [gradImgChannel2, gradAngleChannel2] = getGradientImg(img(:,:,2), 'horizontal', mask);
    [gradImgChannel3, gradAngleChannel3] = getGradientImg(img(:,:,3), 'horizontal', mask);

    gradImg(:,:,1) = gradImgChannel1;
    gradImg(:,:,2) = gradImgChannel2;
    gradImg(:,:,3) = gradImgChannel3;
    gradAngleImg(:,:,1) = gradAngleChannel1;
    gradAngleImg(:,:,2) = gradAngleChannel2;
    gradAngleImg(:,:,3) = gradAngleChannel3;
    
%     figure;
%     imshowpair(blurimg(:,:,1), gradImg(:,:,1),'montage');
%     figure;
%     imshowpair(blurimg(:,:,2), gradImg(:,:,2),'montage');
%     figure;
%     imshowpair(blurimg(:,:,3), gradImg(:,:,3),'montage');
    
    normChannel(1) = norm(gradImgChannel1,2);
    normChannel(2) = norm(gradImgChannel2,2);
    normChannel(3) = norm(gradImgChannel3,2);
    
    [~,id] = max(normChannel);
    gradientImage = gradImg(:,:,id);
    gradientAngle = gradAngleImg(:,:,id);
    win = [64 128];
    [row,col] = size(gradientImage);
    maxrowtogo = fix(row/win(1)) * win(1);
    maxcoltogo = fix(col/win(2)) * win(2);
    desc = [];
    for r = 1:win(1):maxrowtogo
        for c = 1:win(2):maxcoltogo
            hog = getGradientOrientationHist(gradientAngle(r:r+win(1)-1,c:c+win(2)-1),...
                gradientImage(r:r+win(1)-1,c:c+win(2)-1));
            desc = [desc;hog];
        end
    end
end