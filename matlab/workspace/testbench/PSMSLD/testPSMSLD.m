clear;
close all;
restoredefaultpath;

addpath('../../general/');
addpath('../../PSMSLD/');
% Yes, these paths are in Windows format...
path_of_desc = '..\..\..\..\SMSLD\SMSLD\SMSLD_descriptor\Debug\TianMatch.exe';
path_of_match = '..\..\..\..\MSLD\MSLD\MSLD_match\Debug\TianMatch.exe';


Options.collinearity_sigma_theta = 3*pi/180;
Options.collinearity_sigma_w = 2;
Options.collinearity_threshold = 1.3;

Options.minimum_line_length = 15;

Options.extract_scales_distance_threshold = 25;
Options.nb_of_scale_matches = 10;

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

Options.extension = 'ppm';

%% Plot using specific images without known homography
% I1 = imread('../../benchmark/difficult_scenes/difficult_scene_2a.jpg');
% I2 = imread('../../benchmark/difficult_scenes/difficult_scene_2b.jpg');
% % Give a fake homography
% H1to2p = [ 1 0 0; 0 1 0; 0 0 1];
% Options.plot_correct = 0;

%% Plot using a benchmark with a known homography
run('../../benchmark/readzoom');

[result,elapsed_time] = PSMSLDFindMatches(I1,I4,path_of_desc, path_of_match, Options);

fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);
nb_scaled_matches = countNbMatches(result,1);