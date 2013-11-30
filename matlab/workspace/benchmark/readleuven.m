% Read images
I1 = imread('leuven/img1.ppm');
I2 = imread('leuven/img2.ppm');
I3 = imread('leuven/img3.ppm');
I4 = imread('leuven/img4.ppm');
I5 = imread('leuven/img5.ppm');
I6 = imread('leuven/img6.ppm');

% Read homographies
load('leuven/H1to2p');
load('leuven/H1to3p');
load('leuven/H1to4p');
load('leuven/H1to5p');
load('leuven/H1to6p');