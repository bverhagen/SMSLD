function [line_segment_matches,elapsed_time] = SMSLDFindMatches(I1,I2,path_of_exe,Options)
% Interface to SMSLD. This function also calls SMSLD. path_to_exe is the
% path to the SMSLD executable.
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/../general'];
addpath(path_to_add);
path_to_add = [path, '/../general/subaxis'];
addpath(path_to_add);

Options.find_scaled = 0;

% Calculate offset for image border.
offset = 50;

%path = 'C:\Users\Bart\Documents\school\master\git\thesis\MSLD\lines\';
path = [pwd,'\'];

save_name1_txt = 'im1.txt';
save_name2_txt = 'im2.txt';
save_name1_img = ['im1.',Options.extension];
save_name2_img = ['im2.',Options.extension];
save_name_result = 'matches.txt';

[lines1,scales1] = generateLineFileFunction(I1,[path,save_name1_txt], size(I1,1),size(I1,2),offset,Options);
[lines2,scales2] = generateLineFileFunction(I2,[path,save_name2_txt], size(I2,1),size(I2,2),offset,Options);

% Check if gray
if(size(size(I1),2) > 2)
    I1_big = zeros(size(I1,1)+2*offset,size(I1,2)+2*offset,3,'uint8');
    I1_big(1:offset,offset+1:offset+size(I1,2),:) = getFirstRowsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),1:offset,:) = getFirstColumnsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),offset+1:offset+size(I1,2),:) = I1;
    I1_big(offset+size(I1,1)+1:end,offset+1:offset+size(I1,2),:) = getLastRowsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),offset+size(I1,2)+1:end,:) = getLastColumnsReversed(I1,offset);
else
    I1_big = zeros(size(I1,1)+2*offset,size(I1,2)+2*offset,'uint8');
    I1_big(1:offset,offset+1:offset+size(I1,2)) = getFirstRowsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),1:offset) = getFirstColumnsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),offset+1:offset+size(I1,2)) = I1;
    I1_big(offset+size(I1,1)+1:end,offset+1:offset+size(I1,2)) = getLastRowsReversed(I1,offset);
    I1_big(offset+1:offset+size(I1,1),offset+size(I1,2)+1:end) = getLastColumnsReversed(I1,offset);
end
if(size(size(I2),2) > 2)
    I2_big = zeros(size(I2,1)+2*offset,size(I2,2)+2*offset,3,'uint8');
    I2_big(1:offset,offset+1:offset+size(I2,2),:) = getFirstRowsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),1:offset,:) = getFirstColumnsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),offset+1:offset+size(I2,2),:) = I2;
    I2_big(offset+size(I2,1)+1:end,offset+1:offset+size(I2,2),:) = getLastRowsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),offset+size(I2,2)+1:end,:) = getLastColumnsReversed(I2,offset);
else
    I2_big = zeros(size(I2,1)+2*offset,size(I2,2)+2*offset,'uint8');
    I2_big(1:offset,offset+1:offset+size(I2,2)) = getFirstRowsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),1:offset) = getFirstColumnsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),offset+1:offset+size(I2,2)) = I2;
    I2_big(offset+size(I2,1)+1:end,offset+1:offset+size(I2,2)) = getLastRowsReversed(I2,offset);
    I2_big(offset+1:offset+size(I2,1),offset+size(I2,2)+1:end) = getLastColumnsReversed(I2,offset);
end

imwrite(I1_big,[path,save_name1_img],Options.extension);
imwrite(I2_big,[path,save_name2_img],Options.extension);

tic;
system([path_of_exe,' ',[path,save_name1_img], ' ',[path,save_name2_img],' ', [path,save_name1_txt],' ', [path,save_name2_txt],' ',[path,save_name_result]]);
elapsed_time = toc;

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

function rows = getFirstRowsReversed(I,nb_rows)
    if(size(size(I),2) > 2)
        rows = zeros(nb_rows, size(I,2),3);
        rows(end:-1:1,:,:) = I(1:nb_rows,:,:);
    else
        rows = zeros(nb_rows, size(I,2));
        rows(end:-1:1,:) = I(1:nb_rows,:);
    end
end

function rows = getLastRowsReversed(I,nb_rows)
    if(size(size(I),2) > 2)
        rows = zeros(nb_rows, size(I,2),3);
        rows(end:-1:1,:,:) = I(end-nb_rows+1:end,:,:);
    else
        rows = zeros(nb_rows, size(I,2));
        rows(end:-1:1,:) = I(end-nb_rows+1:end,:);
    end
end

function rows = getFirstColumnsReversed(I,nb_cols)
    if(size(size(I),2) > 2)
        rows = zeros(size(I,1), nb_cols,3);
        rows(:,end:-1:1,:) = I(:,1:nb_cols,:);
    else
        rows = zeros(size(I,1),nb_cols);
        rows(:,end:-1:1) = I(:,1:nb_cols);
    end
end

function rows = getLastColumnsReversed(I,nb_cols)
    if(size(size(I),2) > 2)
        rows = zeros(size(I,1), nb_cols,3);
        rows(:,end:-1:1,:) = I(:,end-nb_cols+1:end,:);
    else
        rows = zeros(size(I,1), nb_cols);
        rows(:,end:-1:1) = I(:,end-nb_cols+1:end);
    end
end