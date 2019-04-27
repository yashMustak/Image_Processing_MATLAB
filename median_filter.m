prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

prompt = 'Enter size of filter: ';
filterSize = input(prompt);
padSize = (filterSize-1)/2;

if ch == 1
    padImg = Pad_image(Img, row, col, filterSize);
    for i = 1+padSize:row+padSize
        for j = 1+padSize:col+padSize
            filterList = zeros(1,filterSize*filterSize);
            count = 1;
            for x = -padSize : padSize
                for y = -padSize : padSize
                    filterList(count) = padImg(i+x, j+y);
                    count = count + 1;
                end
            end
            filterList = sort(filterList);
            Img(i-padSize, j-padSize) = filterList((filterSize*filterSize+1)/2);
        end
    end
else
    for k = 1:ch
        padImg = Pad_image(Img(:,:,k), row, col, filterSize);
        for i = 1+padSize:row+padSize
            for j = 1+padSize:col+padSize
               filterList = zeros(1,filterSize*filterSize);
                count = 1;
                for x = -padSize : padSize
                    for y = -padSize : padSize
                        filterList(count) = padImg(i+x, j+y);
                        count = count + 1;
                    end
                end
                filterList = sort(filterList);
                Img(i-padSize, j-padSize, k) = filterList((filterSize*filterSize+1)/2);
            end
        end
    end
end

prompt = 'Want to save image (y/n) [n]: ';
saveans = input(prompt, 's');
if isempty(saveans)
    saveans = 'n';
end
if saveans == 'y'
    prompt = 'Enter name of final image [imagename_meanFilter.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_mean_filter', ext);
    end
    imwrite(Img, savename);
end
imshow(Img);

function PaddedImg = Pad_image(image, row, col, filterSize)
    padsize = (filterSize-1)/2;
    new = uint8(zeros(row+2*padsize, col+2*padsize));
    for i = 1:(row+2*padsize)
        for j = 1:(col+2*padsize)
            if i>padsize && i<=padsize+row && j>padsize && j<=padsize+col
                new(i, j) = image(i-padsize, j-padsize);
            end
        end
    end
    PaddedImg = new;
end