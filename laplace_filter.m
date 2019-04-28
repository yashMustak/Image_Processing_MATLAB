prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

filter = [0, 1, 0; 1, -4, 1; 0, 1, 0];
if ch == 1
    doubleDiff = uint8(zeros(row, col));
    for i = 2:row-1
        for j = 2:col-1
            diff = 0;
            for x = -1:1
                for y = -1:1
                    diff = diff + filter(x+2, y+2)*double(Img(i+x, j+y));
                end
            end
            doubleDiff(i, j) = uint8(diff);
        end
    end
    Img = Img - doubleDiff;
else
    for k = 1:ch
        doubleDiff = uint8(zeros(row, col));
        for i = 2:row-1
            for j = 2:col-1
                diff = 0;
                for x = -1:1
                    for y = -1:1
                        diff = diff + filter(x+2, y+2)*double(Img(i+x, j+y, k));
                    end
                end
                doubleDiff(i, j) = uint8(diff);
            end
        end
        Img(:,:,k) = Img(:,:,k) - doubleDiff;
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