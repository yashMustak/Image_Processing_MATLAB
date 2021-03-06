prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

prompt = 'Enter the value of c [1]: ';
c = input(prompt);
if isempty(c)
    c = 1;
end

if ch == 1
    for i = 1:row
        for j = 1:col
            Img(i, j) = uint8(c*log(double(Img(i, j))+1));
        end
    end
else
    for i = 1:row
        for j = 1:col
            for k = 1:ch
                Img(i, j, k) = uint8(c*log(double(Img(i, j, k))+1));
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
    prompt = 'Enter name of final image [imagename_log.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_log', ext);
    end
    imwrite(new, savename);
end
imshow(Img);