clear;
close all;
restoredefaultpath;

addpath('../../MSLD/');
path_of_exe = '..\..\..\..\MSLD\MSLD\MSLD\Release\TianMatch.exe';

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
Options.plot_correct = 1;

%load('../../testimages/desk_front_rotated.mat');
run('../../benchmark/readzoom');
Options.extension = 'ppm';

[result,elapsed_time] = MSLDFindMatches(I1,I4,path_of_exe, Options);

fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);