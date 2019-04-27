prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

if ch == 1
    prompt = 'Want to insert specific threshold intensity? (y/n) [n]: ';
    thresh_check = input(prompt, 's');
    if isempty(thresh_check)
        thresh_check = 'n';
    end
    
    if thresh_check == 'n'
        average_Intensity = 0;
        for i = 1:row
            for j = 1:col
                average_Intensity = average_Intensity + double(Img(i, j));
            end
        end
        average_Intensity = average_Intensity/(row*col);
        for i = 1:row
            for j = 1:col
                if Img(i, j) >= uint8(average_Intensity)
                    Img(i, j) = 255;
                else
                    Img(i, j) = 0;
                end
            end
        end
    else
        prompt = 'Please enter the threshold Intensity: ';
        threshold = input(prompt);
        for i = 1:row
            for j = 1:col
                if Img(i, j) >= threshold
                    Img(i, j) = 255;
                else
                    Img(i, j) = 0;
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
    imwrite(Img, savename);
end
imshow(Img);