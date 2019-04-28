prompt = 'Enter name of image with extension: ';
imgName = input(prompt, 's');
[filepath, name, ext] = fileparts(imgName);
Img = imread(imgName);
[row, col, ch] = size(Img);

prompt = 'Enter size of filter [3]: ';
InputSize = input(prompt, 's');
if isempty(InputSize)
    InputSize = '3';
end
filterSize = str2double(InputSize);
padSize = (filterSize-1)/2;

if mod(filterSize, 2) ~= 0
    prompt = 'Enter value of sigma [1.0]: ';
    InputSize = input(prompt, 's');
    if isempty(InputSize)
        InputSize = '1';
    end
    sigma = str2double(InputSize);

    disp('1 for zero padding');
    disp('2 for replication of boundary pixel');
    prompt = 'Enter the type of padding [1]: ';
    PaddingType = input(prompt, 's');
    if isempty(PaddingType)
        PaddingType = '1';
    end

    filter = zeros(filterSize, filterSize);
    for i = -(filterSize-1)/2 : (filterSize-1)/2
        for j = -(filterSize-1)/2 : (filterSize-1)/2
            filter(i+(filterSize-1)/2+1, j+(filterSize-1)/2+1) = gaussian(i, j, sigma);
        end
    end

    if ch == 1
        PadImg = uint8(zeros(row + (filterSize-1)/2, col + (filterSize-1)/2));
        switch(PaddingType)
            case '1'
                PadImg = Zero_Pad(Img, row, col, filterSize);
            case '2'
                PadImg = Boundary_Value_Pad(Img, row, col, filterSize);
        end

        for i = 1+padSize:row+padSize
            for j = 1+padSize:col+padSize
                sum = 0;
                for x = -padSize : padSize
                    for y = -padSize : padSize
                        sum = sum + double(PadImg(i+x, j+y))*filter(x+padSize+1, y+padSize+1);
                    end
                end
                Img(i-padSize, j-padSize) = uint8(sum);
            end
        end
    else
        for k = 1:ch
            PadImg = uint8(zeros(row + (filterSize-1)/2, col + (filterSize-1)/2));
            switch(PaddingType)
                case '1'
                    PadImg = Zero_Pad(Img(:,:,k), row, col, filterSize);
                case '2'
                    PadImg = Boundary_Value_Pad(Img(:,:,k), row, col, filterSize);
            end
            
            for i = 1+padSize:row+padSize
                for j = 1+padSize:col+padSize
                    sum = 0;
                    for x = -padSize : padSize
                        for y = -padSize : padSize
                            sum = sum + double(PadImg(i+x, j+y))*filter(x+padSize+1, y+padSize+1);
                        end
                    end
                    Img(i-padSize, j-padSize, k) = uint8(sum);
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
        prompt = 'Enter name of final image [imagename_gaussianFilter.ext]: ';
        savename = input(prompt, 's');
        if isempty(savename)
            savename = strcat(name, '_gaussianFilter', ext);
        end
        imwrite(Img, savename);
    end
    imshow(Img);
end

function G = gaussian(x, y, sigma)
    G = exp(-((x^2 + y^2)/2*sigma^2))/(2*pi*sigma^2);
end

function PaddedImg = Zero_Pad(image, row, col, filterSize)
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

function PaddedImg = Boundary_Value_Pad(image, row, col, filterSize)
    padsize = (filterSize-1)/2;
    new = uint8(zeros(row+2*padsize, col+2*padsize));
    for i = 1:(row+2*padsize)
        for j = 1:(col+2*padsize)
            if i>padsize && i<=padsize+row && j>padsize && j<=padsize+col
                new(i, j) = image(i-padsize, j-padsize);
            else
                if i <= padsize && j<=col && j>padsize
                    new(i, j) = image(1, j);
                else
                    if i>padsize+row && j<=col && j>padsize
                        new(i, j) = image(row, j);
                    else
                        if j<=padsize && i<=row && i>padsize
                            new(i, j) = image(i, 1);
                        end
                        if j>padsize+col && i<=row && i>padsize
                            new(i, j) = image(i, col);
                        end
                    end
                end
            end
        end
    end
    PaddedImg = new;
end