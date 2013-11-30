% Read images
I1 = imread('graf/img1.ppm');
I2 = imread('graf/img2.ppm');
I3 = imread('graf/img3.ppm');
I4 = imread('graf/img4.ppm');
I5 = imread('graf/img5.ppm');
I6 = imread('graf/img6.ppm');

% Read homographies
load('graf/H1to2p');
load('graf/H1to3p');
load('graf/H1to4p');
load('graf/H1to5p');
load('graf/H1to6p');