prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);
prompt = 'Entern the border size (pixels): ';
border = input(prompt);
if ch == 1
    new = uint8(zeros(row+2*border, col+2*border));
    for i = 1:row+2*border
        for j = 1:col+2*border
            if i>border && i<=row+border
                if j>border && j<=col+border
                    new(i, j) = Img(i-border, j-border);
                end
            end
        end
    end
else
    new = uint8(zeros(row+2*border, col+2*border, 3));
    prompt = 'Want to go with black border (y/n) [y]: ';
    check = input(prompt, 's');
    if isempty(check)
        check = 'y';
    end
    if check == 'y'
        for i = 1:row+2*border
            for j = 1:col+2*border
                if i>border && i<=row+border
                    if j>border && j<=col+border
                        new(i, j, 1) = Img(i-border, j-border, 1);
                        new(i, j, 2) = Img(i-border, j-border, 2);
                        new(i, j, 3) = Img(i-border, j-border, 3);
                    end
                end
            end
        end
    else
        prompt1 = 'Enter R value: ';
        r = uint8(input(prompt1));
        prompt1 = 'Enter G value: ';
        g = uint8(input(prompt1));
        prompt1 = 'Enter B value: ';
        b = uint8(input(prompt1));
        for i = 1:row+2*border
            for j = 1:col+2*border
                if i>border && i<=row+border
                    if j>border && j<=col+border
                        new(i, j, 1) = Img(i-border, j-border, 1);
                        new(i, j, 2) = Img(i-border, j-border, 2);
                        new(i, j, 3) = Img(i-border, j-border, 3);
                    else
                        new(i, j, 1) = r;
                        new(i, j, 2) = g;
                        new(i, j, 3) = b;
                    end
                else
                    new(i, j, 1) = r;
                    new(i, j, 2) = g;
                    new(i, j, 3) = b;
                end
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
    prompt = 'Enter name of final image [imagename_b.ext]: ';
    savename = input(prompt, 's');
    if isempty(savename)
        savename = strcat(name, '_b', ext);
    end
    imwrite(new, savename);
end
imshow(new);