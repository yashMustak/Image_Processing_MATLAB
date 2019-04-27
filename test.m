Img1 = imread('lowpoly1_bw.png');
Img2 = imread('dark_bw.png');
I = imhistmatch(Img1, Img2);
imshow(I);