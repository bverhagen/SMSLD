function [line_segment_matches,elapsed_time] = PSMSLDFindMatches(I1,I2,path_of_desc, path_of_match,Options)
% Interface for the MSLD program. Also executes the MSLD and returns the
% result in the usual format.
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/../general'];
addpath(path_to_add);
path_to_add = [path, '/../general/subaxis'];
addpath(path_to_add);
path_to_add = [path, '/../SMSLD/'];
addpath(path_to_add);

Options.find_scaled = 0;

% Calculate offset for image border.
offset = 0;

path = [pwd,'\'];

save_name1_txt = 'im1.txt';
save_name2_txt = 'im2.txt';
save_name1_img = ['im1.',Options.extension];
save_name2_img = ['im2.',Options.extension];
save_name_result = 'matches.txt';

iteration_factor = 0.8;
scaling_factor = 1;
nb_of_iterations = 5;

I1 = imresize(I1, scaling_factor);
I2 = imresize(I2, scaling_factor);
lines1 = cell(0);
lines2 = cell(0);
scales1 = [];
scales2 = [];

for i = 1:nb_of_iterations
fprintf(1,'Executing iteration %d\n', i);
[lines1_tmp,scales1_tmp] = generateLineFileFunction(I1,[path,save_name1_txt], size(I1,1),size(I1,2), offset, Options);
[lines2_tmp,scales2_tmp] = generateLineFileFunction(I2,[path,save_name2_txt], size(I2,1),size(I2,2), offset, Options);

for j = 1:size(lines1_tmp,1)
   lines1_tmp{j} = lines1_tmp{j}/scaling_factor; 
end
for j = 1:size(lines2_tmp,1)
   lines2_tmp{j} = lines2_tmp{j}/scaling_factor; 
end

lines1(end+1:end+size(lines1_tmp,1)) = lines1_tmp;
lines2(end+1:end+size(lines2_tmp,1)) = lines2_tmp;
scales1(end+1:end+size(lines1_tmp,1),:) = scales1_tmp/scaling_factor;
scales2(end+1:end+size(lines2_tmp,1),:) = scales2_tmp/scaling_factor;

imwrite(I1,[path,save_name1_img],Options.extension);
imwrite(I2,[path,save_name2_img],Options.extension);

system([path_of_desc,' ',save_name1_img, ' ',save_name2_img,' ', save_name1_txt,' ', save_name2_txt,' ',save_name_result]);

I1 = imresize(I1,iteration_factor);
I2 = imresize(I2,iteration_factor);

movefile('Descriptor1.txt',[num2str(i),'-1.txt']);
movefile('Descriptor2.txt',[num2str(i),'-2.txt']);
scaling_factor = scaling_factor * iteration_factor;
end

clear lines1_tmp;
clear scales1_tmp;
clear lines2_tmp;
clear scales2_tmp;
fprintf(1,'Nb of lines image 1: %d\n', length(lines1));
fprintf(1,'Nb of lines image 2: %d\n', length(lines2));

% Set all descriptors together
makeDescriptor(1, nb_of_iterations);
makeDescriptor(2, nb_of_iterations);

system([path_of_match,' ', [path,'Descriptor1.txt'],' ', [path,'Descriptor2.txt'],' ',[path,save_name_result]]);
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

function makeDescriptor(nb, iterations)
nb_of_lines = 0;
valid = [];
countForEachLine = [];
for i = 1:iterations
    fp = fopen([num2str(i),'-',num2str(nb),'.txt'],'r');
    controlparams = fscanf(fp, '%d');
    tmp_nb_lines = controlparams(1);
    nb_of_lines = nb_of_lines + tmp_nb_lines;
    valid(end+1:end+tmp_nb_lines) = controlparams(2:1+tmp_nb_lines);
    countForEachLine(end+1:end+tmp_nb_lines) = controlparams(2+tmp_nb_lines:1+2*tmp_nb_lines);
    fclose(fp);
end
fdesc = fopen(['Descriptor',num2str(nb),'.txt'],'w');
% Write control params
fprintf(fdesc, '%d\n', nb_of_lines);
for i = 1:nb_of_lines
   fprintf(fdesc, '%d  ', valid(i)); 
end
fprintf(fdesc, '\n');
for i = 1:nb_of_lines
    fprintf(fdesc, '%d  ', countForEachLine(i));
end
fprintf(fdesc, '\n');

% Write descriptors
descriptorLength = 72;
for i = 1:iterations
    fp = fopen([num2str(i),'-',num2str(nb),'.txt'],'r');
    data = fscanf(fp, '%f');
    % Do not write control data again.
    offset = 1 + 2*data(1);
    for j = 1:(size(data,1)-offset)/descriptorLength
        for k = 1:descriptorLength
            fprintf(fdesc, '%f  ', data((j-1)*descriptorLength+k+offset)); 
        end
        fprintf(fdesc, '\n');
    end
end

fclose(fdesc);
end