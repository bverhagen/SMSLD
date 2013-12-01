% Read images
I1 = imread('zoom/img1.jpg');
I2 = imread('zoom/img2.jpg');
I3 = imread('zoom/img3.jpg');
I4 = imread('zoom/img4.jpg');
I5 = imread('zoom/img5.jpg');
I6 = imread('zoom/img6.jpg');

% Read homographies
load('zoom/H1to2p');
load('zoom/H1to3p');
load('zoom/H1to4p');
load('zoom/H1to5p');
load('zoom/H1to6p');