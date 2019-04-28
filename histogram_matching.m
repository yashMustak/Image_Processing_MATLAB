prompt = 'Enter name of image with extension: ';
imgName1 = input(prompt, 's');
[filepath1, name1, ext1] = fileparts(imgName1);
Img1 = imread(imgName1);
[row1, col1, ch1] = size(Img1);

prompt = 'Enter name of reference image with extension: ';
imgName2 = input(prompt, 's');
[filepath2, name2, ext2] = fileparts(imgName2);
Img2 = imread(imgName2);
[row2, col2, ch2] = size(Img2);

if ch1 == 1
    if ch1 == ch2
        map1 = HistGrayImg(Img1, row1, col1);
        map2 = HistGrayImg(Img2, row2, col2);
        Img1 = HistMap(Img1 ,map1, map2, row1, col1);
    end
else
    if ch1 == ch2
        TempImg1 = uint8(zeros(row1, col1));
        TempImg2 = uint8(zeros(row2, col2));
        for k = 1:ch1
            for i = 1:row1
                for j = 1:col1
                    TempImg1(i,j) = Img1(i, j, k);
                end
            end
            for i = 1:row2
                for j = 1:col2
                    TempImg2(i,j) = Img2(i, j, k);
                end
            end
            map1 = HistGrayImg(TempImg1, row1, col1);
            map2 = HistGrayImg(TempImg2, row2, col2);
            Img1(:,:,k) = HistMap(TempImg1 ,map1, map2, row1, col1);
        end
    end
end

prompt = 'Want to save image (y/n) [n]: ';
saveans = input(prompt, 's');
if isempty(saveans)
    saveans = 'n';
end
if saveans == 'y'
    prompt = 'Enter name of final image [imagename_histMat.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name1, '_histMat', ext1);
    end
    imwrite(Img1, savename);
end
imshow(Img1);

function Hist_map = HistGrayImg(img, row, col)
    FreqVect = zeros(256, 1);
    
    for i = 1:row
        for j = 1:col
            FreqVect(img(i, j) + 1, 1) = FreqVect(img(i, j)+1, 1) + 1;
        end
    end

    cdf = 0;
    for i = 1:256
        if FreqVect(i, 1)>0
            cdf = cdf + FreqVect(i, 1);
            FreqVect(i, 1) = cdf;
        end
    end

    min_cdf = row*col;
    for i = 1:256
        if FreqVect(i, 1)>0 && FreqVect(i, 1) < min_cdf
            min_cdf = FreqVect(i, 1);
            break;
        end
    end

    for i = 1:256
        if FreqVect(i, 1)>0
            FreqVect(i, 1) = histogram_eq(FreqVect(i, 1), min_cdf, row, col);
        end
    end

    for i = 1:row
        for j = 1:col
            img(i, j) = FreqVect(img(i, j)+1, 1);
        end
    end
    Hist_map = FreqVect;
end

function MappedImg = HistMap(imgIn ,map1, map2, row, col)
    img = uint8(zeros(row, col));
    for i = 1:256
        if map1(i, 1)>0
            temp = 1;
            while map2(temp, 1) < map1(i, 1) && temp <= 255
                temp = temp + 1;
                while map2(temp, 1) == 0
                    temp = temp + 1;
                end
            end
            map1(i, 1) = temp;
        end
    end
    
    for i = 1:row
        for j = 1:col
            img(i, j) = map1(double(imgIn(i, j)+1));
        end
    end
    MappedImg = img;
end

function hist = histogram_eq(cdf, min_cdf, M, N)
    hist = round((cdf - min_cdf) * 255 / (M*N - min_cdf));
end