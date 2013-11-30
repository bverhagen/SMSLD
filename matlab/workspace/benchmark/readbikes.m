% Read images
I1 = imread('bikes/img1.ppm');
I2 = imread('bikes/img2.ppm');
I3 = imread('bikes/img3.ppm');
I4 = imread('bikes/img4.ppm');
I5 = imread('bikes/img5.ppm');
I6 = imread('bikes/img6.ppm');

% Read homographies
load('bikes/H1to2p');
load('bikes/H1to3p');
load('bikes/H1to4p');
load('bikes/H1to5p');
load('bikes/H1to6p');