clear;
close all;
restoredefaultpath;

addpath('../../MSLD_pyramid/');
path_of_desc = '..\..\..\..\MSLD\MSLD\MSLD_descriptor\Debug\TianMatch.exe';
path_of_match = '..\..\..\..\MSLD\MSLD\MSLD_match\Debug\TianMatch.exe';

% Parameters for 375 x 500
Options.collinearity_sigma_theta = 3*pi/180;
Options.collinearity_sigma_w = 2;
Options.collinearity_threshold = 1.3;

% Fit these parameters for 800x600 images.
% Options.collinearity_sigma_theta = 10*pi/180;
% Options.collinearity_sigma_w = 3;
% Options.collinearity_threshold = 0.25;

Options.minimum_line_length = 15;

Options.extract_scales_distance_threshold = 50;
Options.nb_of_scale_matches = 20;
Options.showMergedLineSegments = 0;
Options.showDiscardedSmallLines = 0;
Options.showDiscardedSmallScaleLines = 0;
Options.showScaledLines = 0;
Options.verbose = 0;
Options.scale_angle = 10*pi/180;

% For checking matching score
Options.checkMatches_angle_threshold = 5 * pi/180;
Options.checkMatches_distance_threshold = 5;
Options.showCheckMatches = 1;

%load('../../testimages/desk_front_rotated.mat');
run('../../benchmark/readzoom');
clear I2;
clear I3;
clear I5;
clear I6;
Options.extension = 'ppm';

[result,~] = MSLDFindMatches(I1,I4,path_of_desc, path_of_match, Options);

correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);