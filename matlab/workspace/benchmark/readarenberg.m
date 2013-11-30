% Read images
I1 = imread('arenberg/img1.jpg');
I2 = imread('arenberg/img2.jpg');
I3 = imread('arenberg/img3.jpg');
I4 = imread('arenberg/img4.jpg');
I5 = imread('arenberg/img5.jpg');
I6 = imread('arenberg/img6.jpg');

% Read homographies
load('arenberg/H1to2p');
load('arenberg/H1to3p');
load('arenberg/H1to4p');
load('arenberg/H1to5p');
load('arenberg/H1to6p');