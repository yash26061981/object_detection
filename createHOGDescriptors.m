function createHOGDescriptors
%     IN_DIR = 'D:\ObjectDetection\DataSet\INRIAPerson\TrainingSet';
    IN_DIR = 'D:\ObjectDetection\DataSet\INRIAPerson\Train\neg';
    files = dir(IN_DIR);
    sz = numel(files);
    descriptors = [];
    for k = 1:sz
        if ~files(k).isdir
            file = [IN_DIR, '\', files(k).name];
%             ifid = fopen(file,'r');
            desc = computeGradientWithHighNorm(file);
            descriptors = [descriptors;desc];
            disp(file);
        end
    end
    disp('done');
end