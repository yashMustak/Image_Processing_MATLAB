prompt = 'Enter name of image 1 with extension: ';
imgName1 = input(prompt, 's');
[filepath1, name1, ext1] = fileparts(imgName);
prompt = 'Enter name of image 2 with extension: ';
imgName2 = input(prompt, 's');
[filepath2, name2, ext2] = fileparts(imgName);
Img1 = imread(imgName1);
Img2 = imread(imgName2);
[row1, col1, ch1] = size(Img1);
[row2, col2, ch2] = size(Img2);
prompt = 'choose your primary image [1]: ';
primary = input(prompt);
if isempty(primary)
    primary = 1;
end
prompt = 'Enter the alpha value for primary image [0.5]: ';
alpha = input(prompt);
if isempty(alpha)
    alpha = 0.5;
end
if primary == 1
    if ch1 == 1 && ch2 == 1
        new = uint8(zeros(row1, col1));
        ch = 1;
    else
        new = uint8(zeros(row1, col1, ch1));
        ch = ch1;
    end
    if row1 ~= row2
        prompt = 'Height of images are not equal. Want to put smaller image at center (y/n) [y]: ';
        startrow = input(prompt);
        if isempty(startrow)
            startrow = (max(row1, row2) - min(row1, row2))/2;
        end
        if col1 ~= col2
            prompt = 'Width of images are not equal. Want to put smaller image at center (y/n) [y]: ';
            startcol = input(prompt);
            if isempty(startcol)
                startcol = round((max(col1, col2) - min(col1, col2))/2);
            end
            for i = 1:row1
                for j = 1:col1
                    if ch ~= 1
                        if i>startrow && j>startcol && i<=startrow+min(row1, row2) && j<=startcol+min(col1, col2)
                            for k = 1:ch
                                new(i, j, k) = alpha*Img1(i, j, k) + (1-alpha)*Img2(i-startrow, j-startcol, k);
                            end
                        else
                            for k = 1:ch
                                new(i, j, k) = Img1(i, j, k);
                            end
                        end
                    else
                        if i>startrow && j>startcol && i<=startrow+min(row1, row2) && j<=startcol+min(col1, col2)
                            new(i, j) = alpha*Img1(i, j) + (1-alpha)*Img2(i-startrow, j-startcol);
                        else
                            new(i, j) = Img1(i, j);
                        end
                    end
                end
            end
        else
            for i = 1:row1
                for j = 1:col1
                    if ch ~= 1
                        if i>startrow && i<=startrow+min(row1, row2)
                            for k = 1:ch
                                new(i, j, k) = alpha*Img1(i, j, k) + (1-alpha)*Img2(i-startrow, j, k);
                            end
                        else
                            for k = 1:ch
                                new(i, j, k) = Img1(i, j, k);
                            end
                        end
                    else
                        if i>startrow && i<=startrow+min(row1, row2)
                            new(i, j) = alpha*Img1(i, j) + (1-alpha)*Img2(i-startrow, j);
                        else
                            new(i, j) = Img1(i, j);
                        end
                    end
                end
            end
        end
    else
        for i = 1:row1
            for j = 1:col1
                if ch ~= 1
                    for k = 1:ch
                        new(i, j, k) = alpha*Img1(i, j, k) + (1-alpha)*Img2(i, j, k);
                    end
                else
                    new(i, j) = alpha*Img1(i, j) + (1-alpha)*Img2(i, j);
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
        prompt = 'Enter name of final image [primaryImageName_blend.ext]: ';
        savename = input(prompt, 's');
        if isempty(savename)
            savename = strcat(name1, '_blend', ext);
        end
        imwrite(new, savename);
    end
    imshow(new);
else
    if ch1 == 1 && ch2 == 1
        new = uint8(zeros(row2, col2));
        ch = 1;
    else
        new = uint8(zeros(row2, col2, ch2));
        ch = ch2;
    end
    if row1 ~= row2
        prompt = 'Height of images are not equal. Want to put smaller image at center (y/n) [y]: ';
        startrow = input(prompt);
        if isempty(startrow)
            startrow = (max(row1, row2) - min(row1, row2))/2;
        end
        if col1 ~= col2
            prompt = 'Width of images are not equal. Want to put smaller image at center (y/n) [y]: ';
            startcol = input(prompt);
            if isempty(startcol)
                startcol = (max(col1, col2) - min(col1, col2))/2;
            end
            for i = 1:row2
                for j = 1:col2
                    if ch ~= 1
                        if i>startrow && j>startcol && i<=startrow+min(row1, row2) && j<=startcol+min(col1, col2)
                            for k = 1:ch
                                new(i, j, k) = alpha*Img2(i, j, k) + (1-alpha)*Img1(i-startrow, j-startcol, k);
                            end
                        else
                            for k = 1:ch
                                new(i, j, k) = Img2(i, j, k);
                            end
                        end
                    else
                        if i>startrow && j>startcol && i<=startrow+min(row1, row2) && j<=startcol+min(col1, col2)
                            new(i, j) = alpha*Img2(i, j) + (1-alpha)*Img1(i-startrow, j-startcol);
                        else
                            new(i, j) = Img2(i, j);
                        end
                    end
                end
            end
        else
            for i = 1:row2
                for j = 1:col2
                    if ch ~= 1
                        if i>startrow && i<=startrow+min(row1, row2)
                            for k = 1:ch
                                new(i, j, k) = alpha*Img2(i, j, k) + (1-alpha)*Img1(i-startrow, j, k);
                            end
                        else
                            for k = 1:ch
                                new(i, j, k) = Img2(i, j, k);
                            end
                        end
                    else
                        if i>startrow && i<=startrow+min(row1, row2)
                            new(i, j) = alpha*Img2(i, j) + (1-alpha)*Img1(i-startrow, j);
                        else
                            new(i, j) = Img2(i, j);
                        end
                    end
                end
            end
        end
    else
        for i = 1:row2
            for j = 1:col2
                if ch ~= 1
                    for k = 1:ch
                        new(i, j, k) = alpha*Img2(i, j, k) + (1-alpha)*Img1(i, j, k);
                    end
                else
                    new(i, j) = alpha*Img2(i, j) + (1-alpha)*Img1(i, j);
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
        prompt = 'Enter name of final image [primaryImageName_blend.ext]: ';
        savename = input(prompt, 's');
        if isempty(savename)
            savename = strcat(name2, '_blend', ext);
        end
        imwrite(new, savename);
    end
    imshow(new);
end
