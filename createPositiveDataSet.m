function createPositiveDataSet
    IN_DIR = 'D:\ObjectDetection\DataSet\INRIAPerson\';
    READ_DIR  = [IN_DIR 'Train\annotations'];
    RESULT_DIR = [IN_DIR 'TrainingSet'];
    files = dir(READ_DIR);
    mkdir(RESULT_DIR);
    
    sz = numel(files);
    for k = 500:sz
        if ~files(k).isdir
            file = [READ_DIR, '\', files(k).name];
            ifid = fopen(file,'r');
            totalObj = 1;
            fileLocation = '';
            cordinates = zeros(totalObj,4);
            objiter = totalObj;
            details = ['Bounding box for object ' num2str(objiter)  ' "PASperson" (Xmin, Ymin) - (Xmax, Ymax) '];
            
            while 1
                tline = fgets(ifid);
                if tline == -1
                    break;
                end
                if(uint8(tline(1)) == 35 || uint8(tline(1)) == 10)
                    continue;
                end
                deline = textscan(tline,'%s%s', 'Delimiter', ':');
                if strcmp(deline{1,1},'Image filename ')
                    deline2 = textscan(char(deline{1,2}),'%s%s%s', 'Delimiter', '/"');
                    str = sprintf('%s%s%s%s%s',char(deline2{1,2}),'\',char(deline2{1,3}),'\',char(deline2{1,1}(2)));
                    fileLocation = [IN_DIR str];
                end
                if strcmp(deline{1,1},'Objects with ground truth ')
                    deline2 = textscan(char(deline{1,2}),'%s%s', 'Delimiter', '{');
                    totalObj = str2num(char(deline2{1,1}));
                end
                if(objiter > totalObj)
                    break;
                end
                if strcmp(deline{1,1},details)
                    deline2 = textscan(char(deline{1,2}),'%s%s', 'Delimiter', '-');
                    pair = textscan(char(deline2{1,1}),'%s%s', 'Delimiter', '(),');
                    cordinates(objiter,1) = str2num(char(pair{1,1}));
                    cordinates(objiter,2) = str2num(char(pair{1,2}));
                    pair = textscan(char(deline2{1,2}),'%s%s', 'Delimiter', '(),');
                    cordinates(objiter,3) = str2num(char(pair{1,1}));
                    cordinates(objiter,4) = str2num(char(pair{1,2}));
                    objiter = objiter+1;
                    details = ['Bounding box for object ' num2str(objiter)  ' "PASperson" (Xmin, Ymin) - (Xmax, Ymax) '];                    
                end
            end
            img = imread(fileLocation);  
            name = files(k).name;
            for indx = 1:totalObj
                img1 = img(cordinates(indx,1):cordinates(indx,3),cordinates(indx,2):cordinates(indx,4),:);
                str = sprintf('%s%d%s',name(1:end-4),indx,'.png');
%                 figure1 = figure;
%                 axes1 = axes('Parent',figure1);
%                 hold(axes1,'all'); 
%                 imshow(img1);
                imwrite(img1,[RESULT_DIR '\' str]);
%                 saveas(figure1,[RESULT_DIR '\' str],'jpg');  
%                 close all;
%                 subplot(1,totalObj,indx); imshow(img1);
            end
%             imshow(fileLocation);
            disp(fileLocation);
        end
    end

end