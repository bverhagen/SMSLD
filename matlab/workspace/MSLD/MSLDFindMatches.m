function [line_segment_matches,elapsed_time] = MSLDFindMatches(I1,I2,path_of_exe,Options)
% Interface for the MSLD program. Also executes the MSLD and returns the
% result in the usual format.
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/../general'];
addpath(path_to_add);
path_to_add = [path, '/../general/subaxis'];
addpath(path_to_add);

Options.find_scaled = 0;

path = [pwd,'\'];

save_name1_txt = 'im1.txt';
save_name2_txt = 'im2.txt';
save_name1_img = ['im1.',Options.extension];
save_name2_img = ['im2.',Options.extension];
save_name_result = 'matches.txt';

[lines1,scales1] = generateLineFileFunction(I1,[path,save_name1_txt], size(I1,1),size(I1,2),Options);
[lines2,scales2] = generateLineFileFunction(I2,[path,save_name2_txt], size(I2,1),size(I2,2),Options);

fprintf(1,'Nb of lines image 1: %d\n', length(lines1));
fprintf(1,'Nb of lines image 2: %d\n', length(lines2));

imwrite(I1,[path,save_name1_img],Options.extension);
imwrite(I2,[path,save_name2_img],Options.extension);

system([path_of_exe,' ',[path,save_name1_img], ' ',[path,save_name2_img],' ', [path,save_name1_txt],' ', [path,save_name2_txt],' ',[path,save_name_result]]);
fid_time = fopen('Elapsed_time.txt');
elapsed_time = fscanf(fid_time,'%f');

fid_matches = fopen([path,save_name_result],'r');
txt_result = fscanf(fid_matches,'%d %d');

matches = zeros(size(txt_result,1)/2,2);
for i = 1:size(txt_result,1)/2
    matches(i,:) = [txt_result(2*i-1)+1 txt_result(2*i)+1];
end

line_segment_matches = cell(size(matches,1),4);
line_segment_matches(:,1) = lines1(matches(:,1));
line_segment_matches(:,2) = lines2(matches(:,2));
line_segment_matches(:,3) = mat2cell(scales1(matches(:,1),:),ones(size(matches,1),1),3);
line_segment_matches(:,4) = mat2cell(scales2(matches(:,2),:),ones(size(matches,1),1),3);
end