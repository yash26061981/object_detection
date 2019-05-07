img1 = imread('D:\TataPowerSED\MatlabCode\ANPRDATA\ExtractedFrames\MH02CD779\MH02CD779_31.jpg');
img2 = imread('D:\TataPowerSED\MatlabCode\ANPRDATA\ExtractedFrames\MH02CD779\MH02CD779_32.jpg');

gimg1 = rgb2gray(img1);
gimg2 = rgb2gray(img2);
% ed = edge(gimg1,'sobel','both','nothinning');
% imshow(ed);
subimage = abs(imsubtract(gimg1,gimg2));
[idr, idc] = find(subimage > 50);
minr = min(idr); minc = min(idc);
maxr = max(idr); maxc = max(idc);

figure;
subplot(2,2,1);imshow(gimg1);
subplot(2,2,2);imshow(gimg2);
subplot(2,2,[3 4]);imshowpair(gimg1(minr:maxr, minc:maxc), gimg2(minr:maxr, minc:maxc),'montage')
sub1 = zeros(maxr-minr+1, maxc-minc+1);
sub2 = zeros(maxr-minr+1, maxc-minc+1);
for i = 1:size(idr,1)
    sub1(idr(i)-minr+1,idc(i)-minc+1) = gimg1(idr(i),idc(i));
    sub2(idr(i)-minr+1,idc(i)-minc+1) = gimg2(idr(i),idc(i));
end
sub1 = cast(sub1,'uint8');
sub2 = cast(sub2,'uint8');
figure;
subplot(2,2,1);imshow(gimg1);
subplot(2,2,2);imshow(gimg2);
subplot(2,2,[3 4]);imshowpair(sub1, sub2,'montage')