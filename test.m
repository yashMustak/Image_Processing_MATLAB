new = uint8(zeros(1000, 1000));
for i = 1:1000
    for j = 1:1000
        if rand > 0.9
            new(i, j) = 255;
        end
    end
end
%imwrite('binary.png');
imshow(new);