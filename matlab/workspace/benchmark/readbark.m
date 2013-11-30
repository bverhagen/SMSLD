% Read images
I1 = imread('bark/img1.ppm');
I2 = imread('bark/img2.ppm');
I3 = imread('bark/img3.ppm');
I4 = imread('bark/img4.ppm');
I5 = imread('bark/img5.ppm');
I6 = imread('bark/img6.ppm');

% Read homographies
load('bark/H1to2p');
load('bark/H1to3p');
load('bark/H1to4p');
load('bark/H1to5p');
load('bark/H1to6p');