function benchmark(benchmark_name)
run(['../../benchmark/read', benchmark_name]);

fprintf('Applying benchmark %s\n',benchmark_name);

folder_to_save = ['../../benchmark_results/',benchmark_name,'/MSLD/'];

if ~exist(folder_to_save,'dir')
    mkdir(folder_to_save);
end
path_of_desc = '..\..\..\..\MSLD\MSLD\MSLD_descriptor\Debug\TianMatch.exe';
path_of_match = '..\..\..\..\MSLD\MSLD\MSLD_match\Debug\TianMatch.exe';
addpath('../../MSLD_pyramid/');
addpath('../../general/');

% Options
Options=struct;

% Verbose level: 0 = no output, 1 = little output, 2 = a lot of output
Options.verbose = 0;

% Options
Options.scale_angle = 10*pi/180;

% Fit these parameters for 800x600 images.
Options.collinearity_sigma_theta = 10*pi/180;
Options.collinearity_sigma_w = 3;
Options.collinearity_threshold = 0.25;
Options.minimum_line_length = 15;

Options.extract_scales_distance_threshold = 50;
Options.nb_of_scale_matches = 20;

% Descriptor options
% Noise reduction through spline interpolation.
Options.spline_distance_points = 1;
Options.description_distance = 4;
% 18 Hue bins ranging from 0 to 1.
nb_hue_bins = 18;
Options.histogram_partition_hue = 0:1/(nb_hue_bins-1):1;

% 3 saturation levels
Options.histogram_partition_saturation = [0.60 1];

% Value: 3 levels. Value ranges from 0 to 1.
nb_value_bins = 3;
min_value_value= 0.33;
Options.histogram_partition_value = min_value_value:(1-min_value_value)/(nb_value_bins-1):1;

% 4 levels of grey => modeled by Saturation. 4 levels: 0 -> 1 for value
% component if saturation value is below histogram_gray_saturation_value
Options.histogram_nb_gray_levels = 4;
Options.histogram_gray_saturation_value = 0.20;

% Matching parameters
Options.soft_threshold = 0.25;
Options.max_nb_soft_candidates = 200;
Options.topological_violation_threshold = 0.15;
Options.boost_correspondences_threshold = Options.topological_violation_threshold;

% Specific options for MSLD
if(strcmp(benchmark_name,'boat'))
    Options.extension = 'pgm';
else
    Options.extension = 'ppm';
end

% Line detection
Options.showMergedLineSegments = 0;
Options.showDiscardedSmallLines = 0;
Options.showDiscardedSmallScaleLines = 0;
Options.showScaledLines = 0;

% For checking matching score
Options.checkMatches_angle_threshold = 5 * pi/180;
Options.checkMatches_distance_threshold = 5;
Options.showCheckMatches = 0;

fid = fopen([folder_to_save,'results.txt'],'w');

fprintf(1,'*** Image 1 vs 2 ***\n');
fprintf(fid,'*** Image 1 vs 2 ***\n');
[result,elapsed_time] = MSLDFindMatches(I1,I2,path_of_desc, path_of_match, Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I2,result,H1to2p,Options,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to2.mat'],'result','elapsed_time','correct_matches');

fprintf(1,'\n*** Image 1 vs 3 ***\n');
fprintf(fid,'\n*** Image 1 vs 3 ***\n');
[result,elapsed_time] = MSLDFindMatches(I1,I3,path_of_desc, path_of_match,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I3,result,H1to3p,Options,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to3.mat'],'result','elapsed_time','correct_matches');

fprintf(1,'\n*** Image 1 vs 4 ***\n');
fprintf(fid,'\n*** Image 1 vs 4 ***\n');
[result,elapsed_time] = MSLDFindMatches(I1,I4,path_of_desc, path_of_match,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to4.mat'],'result','elapsed_time','correct_matches');

fprintf(1,'\n*** Image 1 vs 5 ***\n');
fprintf(fid,'\n*** Image 1 vs 5 ***\n');
[result,elapsed_time] = MSLDFindMatches(I1,I5,path_of_desc, path_of_match,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I5,result,H1to5p,Options,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to5.mat'],'result','elapsed_time','correct_matches');

fprintf(1,'\n*** Image 1 vs 6 ***\n');
fprintf(fid,'\n*** Image 1 vs 6 ***\n');

[result,~] = MSLDFindMatches(I1,I6,path_of_desc, path_of_match,Options);
correct_matches = checkMatches(I1,I6,result,H1to6p,Options,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to6.mat'],'result','elapsed_time','correct_matches');

fclose(fid);
end