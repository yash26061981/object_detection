clc; close all; clear all
rgb = imread('D:\TataPowerSED\MatlabCode\ANPRDATA\ExtractedFrames\MH02CD779\MH02CD779_11.jpg');
I = rgb2gray(rgb);
imshow(rgb);
figure; imshow(I)

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
% figure
% imshow(gradmag)

se = strel('disk', 20);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
% figure
% imshow(Iobr)
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
backgroundImg = immultiply(I,bw);
foregroundImg = immultiply(I, ~bw);
figure; imshow(backgroundImg),title('Background')
figure; imshow(foregroundImg),title('Foreground')


