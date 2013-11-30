% Read images
I1 = imread('trees/img1.ppm');
I2 = imread('trees/img2.ppm');
I3 = imread('trees/img3.ppm');
I4 = imread('trees/img4.ppm');
I5 = imread('trees/img5.ppm');
I6 = imread('trees/img6.ppm');

% Read homographies
load('trees/H1to2p');
load('trees/H1to3p');
load('trees/H1to4p');
load('trees/H1to5p');
load('trees/H1to6p');