prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

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
    grayHE = img;
end

function hist = histogram_eq(cdf, min_cdf, M, N)
    hist = round((cdf - min_cdf) * 255 / (M*N - min_cdf));
end