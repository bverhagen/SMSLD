% Read images
I1 = imread('wall/img1.ppm');
I2 = imread('wall/img2.ppm');
I3 = imread('wall/img3.ppm');
I4 = imread('wall/img4.ppm');
I5 = imread('wall/img5.ppm');
I6 = imread('wall/img6.ppm');

% Read homographies
load('wall/H1to2p');
load('wall/H1to3p');
load('wall/H1to4p');
load('wall/H1to5p');
load('wall/H1to6p');