prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);
if ch==1
    for i = 1:row
        for j = 1:col
            Img(i, j) = 255-Img(i, j);
        end
    end
else
    for i = 1:row
        for j = 1:col
            for k = 1:ch
                Img(i, j, k) = 255-Img(i, j, k);
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
    prompt = 'Enter name of final image [imagename_cmp.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_comp', ext);
    end
    imwrite(new, savename);
end
imshow(Img);