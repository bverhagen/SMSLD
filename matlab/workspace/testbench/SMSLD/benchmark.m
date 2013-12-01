function benchmark(benchmark_name)
run(['../../benchmark/read', benchmark_name]);

fprintf('Applying benchmark %s\n',benchmark_name);

folder_to_save = ['../../benchmark_results/',benchmark_name,'/SMSLD/'];
path_to_exe = '..\..\..\..\SMSLD\SMSLD\SMSLD\Release\TianMatch.exe';

addpath('../../SMSLD/');
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
Options.collinearity_threshold = 0.30;
Options.minimum_line_length = 15;

Options.extract_scales_distance_threshold = 50;
Options.nb_of_scale_matches = 50;

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
[result,elapsed_time] = SMSLDFindMatches(I1,I2,path_to_exe,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I2,result,H1to2p,Options,1);
nb_scale_matches = countNbMatches(result,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Number of scaled matches: %d\n', nb_scale_matches);
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to2.mat'],'result','elapsed_time','correct_matches','nb_scale_matches');

fprintf(1,'\n*** Image 1 vs 3 ***\n');
fprintf(fid,'\n*** Image 1 vs 3 ***\n');
[result,elapsed_time] = SMSLDFindMatches(I1,I3,path_to_exe,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I3,result,H1to3p,Options,1);
nb_scale_matches = countNbMatches(result,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Number of scaled matches: %d\n', nb_scale_matches);
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to3.mat'],'result','elapsed_time','correct_matches','nb_scale_matches');

fprintf(1,'\n*** Image 1 vs 4 ***\n');
fprintf(fid,'\n*** Image 1 vs 4 ***\n');
[result,elapsed_time] = SMSLDFindMatches(I1,I4,path_to_exe,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I4,result,H1to4p,Options,1);
nb_scale_matches = countNbMatches(result,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Number of scaled matches: %d\n', nb_scale_matches);
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to4.mat'],'result','elapsed_time','correct_matches','nb_scale_matches');

fprintf(1,'\n*** Image 1 vs 5 ***\n');
fprintf(fid,'\n*** Image 1 vs 5 ***\n');
[result,elapsed_time] = SMSLDFindMatches(I1,I5,path_to_exe,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I5,result,H1to5p,Options,1);
nb_scale_matches = countNbMatches(result,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Number of scaled matches: %d\n', nb_scale_matches);
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to5.mat'],'result','elapsed_time','correct_matches','nb_scale_matches');

fprintf(1,'\n*** Image 1 vs 6 ***\n');
fprintf(fid,'\n*** Image 1 vs 6 ***\n');

[result,elapsed_time] = SMSLDFindMatches(I1,I6,path_to_exe,Options);
fprintf('Elapsed time: %f s\n',elapsed_time);
correct_matches = checkMatches(I1,I6,result,H1to6p,Options,1);
nb_scale_matches = countNbMatches(result,1);

% Write to file
fprintf(fid,'Total number of matches: %d\n', size(result,1));
fprintf(fid,'Number of scaled matches: %d\n', nb_scale_matches);
fprintf(fid,'Correct matches ratio: %.2f\n', sum(correct_matches)/size(result,1));
fprintf(fid,'Elapsed time: %f s\n',elapsed_time);

save([folder_to_save,'1to6.mat'],'result','elapsed_time','correct_matches','nb_scale_matches');

fclose(fid);
end