% Read images
I1 = imread('ubc/img1.ppm');
I2 = imread('ubc/img2.ppm');
I3 = imread('ubc/img3.ppm');
I4 = imread('ubc/img4.ppm');
I5 = imread('ubc/img5.ppm');
I6 = imread('ubc/img6.ppm');

% Read homographies
load('ubc/H1to2p');
load('ubc/H1to3p');
load('ubc/H1to4p');
load('ubc/H1to5p');
load('ubc/H1to6p');