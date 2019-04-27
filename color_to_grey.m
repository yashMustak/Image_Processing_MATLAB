prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

new = uint8(zeros(row,col));
prompt = 'Want to enter the weightage for RGB? (y/n) [y]: ';
check = input(prompt, 's');
if isempty(check)
    check = 'y';
end

if check == 'y'
    prompt1 = 'Enter R weight: ';
    r = input(prompt1);
    prompt1 = 'Enter G weight: ';
    g = input(prompt1);
    prompt1 = 'Enter B weight: ';
    b = input(prompt1);
    for i = 1:row
        for j = 1:col
            new(i, j) = r*Img(i, j, 1)+g*Img(i, j, 2)+b*Img(i, j, 3);
        end
    end 
else
    for i = 1:row
        for j = 1:col
            new(i, j) = (Img(i, j, 1)+Img(i, j, 2)+Img(i, j, 3))/3;
        end
    end
end

prompt = 'Want to save image (y/n) [n]: ';
saveans = input(prompt, 's');
if isempty(saveans)
    saveans = 'n';
end
if saveans == 'y'
    prompt = 'Enter name of final image [imagename_bw.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_bw', ext);
    end
    imwrite(new, savename);
end
imshow(new);