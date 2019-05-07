mask = [3   2   1   0   -1  -2  -3
4   3   2   0   -2  -3  -4
5   4   3   0   -3  -4  -5
6   5   4   0   -4  -5  -6
5   4   3   0   -3  -4  -5
4   3   2   0   -2  -3  -4
3   2   1   0   -1  -2  -3];

% mask = [1 0 -1;
%     2 0 -2;
%     1 0 -1];

rgb = imread('D:\TataPowerSED\MatlabCode\ANPRDATA\renumberplatelocalization\notRunning\7.png');
img = rgb2gray(rgb);

bw1 = edge(img,'sobel','vertical'); figure; subplot(3,2,1);imshow(bw1)
bw2 = edge(img,'canny','vertical'); subplot(3,2,2);imshow(bw2)
bw3 = edge(img,'prewitt','vertical'); subplot(3,2,3);imshow(bw3)
bw4 = edge(img,'roberts','vertical'); subplot(3,2,4);imshow(bw4)
bw5 = edge(img,'zerocross',mask); subplot(3,2,5); imshow(bw5)
bw6 = edge(img,'log'); subplot(3,2,6); imshow(bw6)



f = imfilter(img,mask);
x_mask = mask/sum(sum(abs(mask)));
y_mask = x_mask'; kx = 1; ky = 0;
bx = imfilter(img,x_mask,'replicate');
by = imfilter(img,y_mask,'replicate');
b = kx*bx.*bx + ky*by.*by;
cutoff = 4*mean2(b);
thresh = sqrt(cutoff);

fimg = b>thresh;
imshow(fimg);
