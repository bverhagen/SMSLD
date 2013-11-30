% Read images
I1 = imread('boat/img1.pgm');
I2 = imread('boat/img2.pgm');
I3 = imread('boat/img3.pgm');
I4 = imread('boat/img4.pgm');
I5 = imread('boat/img5.pgm');
I6 = imread('boat/img6.pgm');

% Read homographies
load('boat/H1to2p');
load('boat/H1to3p');
load('boat/H1to4p');
load('boat/H1to5p');
load('boat/H1to6p');