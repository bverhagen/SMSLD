clear;
close all;
restoredefaultpath;

addpath('../../general/');
addpath('../../SMSLD/');
path_to_exe = '..\..\..\..\SMSLD\SMSLD\SMSLD\Release\TianMatch.exe';

Options.collinearity_sigma_theta = 3*pi/180;
Options.collinearity_sigma_w = 2;
Options.collinearity_threshold = 1.3;

Options.minimum_line_length = 15;

Options.extract_scales_distance_threshold = 50;
Options.nb_of_scale_matches = 50;

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

run('../../benchmark/readzoom');
[result,elapsed_time] = SMSLDFindMatches(I1,I4,path_to_exe, Options);

displayScaledMatches(I1,I4,result);

fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);
nb_scaled_matches = countNbMatches(result,1);