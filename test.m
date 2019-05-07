IN_DIR = 'D:\TataPowerSED\MatlabCode\ANPRDATA\toCluster_B_U_9\';
READ_DIR  = [IN_DIR 'U\U\'];
RESULT_DIR = [IN_DIR 'U\U_Clusters'];
mkdir(RESULT_DIR);
files = dir(READ_DIR);
ind = 1;
K = 2;
sz = numel(files);
reshpImg = [];
for k = 1:sz
    if ~files(k).isdir
        file = [READ_DIR, '\', files(k).name];
        img = imread(file);
        img(img < 200) = 0;
        img(img >= 200) = 1;
        reshpImg(ind,:) = reshape(img',1,numel(img));
        ind = ind +1;
    end
end
opts = statset('Display','final');
[cidx, ctrs] = kmeans(reshpImg, K,'Distance','Hamming', 'Replicates',5, 'Options',opts);

for k = 1: K
    indx = cidx == k;
    matfile = reshpImg(indx,:);
    for j = 1: size(matfile,1)
        img = reshape(matfile(j,:),20,30)';
        img(img == 1) = 255;
        str = sprintf('%d_%d%s',k,j,'.jpg');
        imwrite(img,[RESULT_DIR '\' str]);
    end
end
disp('done')

        