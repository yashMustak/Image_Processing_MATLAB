prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);
disp('Please wait, it takes some time...');

if ch == 1
    Img = HistGrayImg(Img, row, col);
else
    TempImg = uint8(zeros(row, col));
    for k = 1:ch
        for i = 1:row
            for j = 1:col
                TempImg(i,j) = Img(i, j, k);
            end
        end
        Img(:,:,k) = HistGrayImg(TempImg, row, col);
    end
end
    

prompt = 'Want to save image (y/n) [n]: ';
saveans = input(prompt, 's');
if isempty(saveans)
    saveans = 'n';
end
if saveans == 'y'
    prompt = 'Enter name of final image [imagename_histeq.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_histeq', ext);
    end
    imwrite(Img, savename);
end
imshow(Img);

function grayHE = HistGrayImg(img, row, col)
    map = containers.Map('KeyType','double','ValueType','double');
    for i = 0:255
        map(double(i)) = 0;
    end
    for i = 1:row
        for j = 1:col
            map(double(img(i, j))) = map(double(img(i, j))) + 1;
        end
    end

    cdf = 0;
    for i = 0:255
        if map(i)>0
            cdf = cdf + map(i);
            map(i) = cdf;
        end
    end

    min_cdf = row*col;
    for i = 0:255
        if map(i)>0 && map(i) < min_cdf
            min_cdf = map(i);
            break;
        end
    end

    for i = 0:255
        if map(i)>0
            map(i) = histogram_eq(map(i), min_cdf, row, col);
        end
    end

    for i = 1:row
        for j = 1:col
            img(i, j) = map(double(img(i, j)));
        end
    end
    grayHE = img;
end

function hist = histogram_eq(cdf, min_cdf, M, N)
    hist = round((cdf - min_cdf) * 255 / (M*N - min_cdf));
end