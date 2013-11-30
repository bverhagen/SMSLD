function [lines, scales] = generateLineFileFunction(I,save_file, size_row, size_col, offset, Options)
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/../SMSLD/'];
addpath(path_to_add);
path_to_add = [path, '/../SMSLD/'];
addpath(path_to_add);
path_to_add = [path, '/../general/'];
addpath(path_to_add);
path_to_add = [path, '/../general/linortfit/'];
addpath(path_to_add);

[lines, scales] = findLineSegmentsAndScalesMSLD(I,Options);

txt_lines = cellfun(@(x) lineToPixels(x, size_row, size_col),lines,'UniformOutput',false);

file_id = fopen(save_file,'w');
fprintf(file_id, '%d\n',size(lines,1));

if(size(lines,1) > 6100)
    warning('SMSLD:max_line_nb', 'The number of lines is highter than is permitted, the SMSLD program will crash.');
end

% Print line lengths
for i = 1:size(txt_lines,1)
    fprintf(file_id,'%d  ',size(txt_lines{i},1));
end
fprintf(file_id,'\n');

% Print line scales: 3 together give the scale of 1 line
for i = 1:size(txt_lines,1)
    fprintf(file_id,'%f  %f  ', scales(i,1),scales(i,2));
end
fprintf(file_id,'\n');

% Print absolute angles of the scaled lines
for i = 1:size(txt_lines,1)
    angle = getAngle(lines{i});
    fprintf(file_id,'%f  %f  ', angle-scales(i,3),angle+scales(i,3));
end
fprintf(file_id,'\n');

for i = 1:size(txt_lines,1)
    for j = 1:size(txt_lines{i},1)
        fprintf(file_id,'%d  %d  \n',txt_lines{i}(j,1)+offset,txt_lines{i}(j,2)+offset);
    end
end
fclose(file_id);
end

function pixels = lineToPixels(line, size_row, size_col)
angle = getAngle(line);
a = tan(angle);
b = line(1,2) - a * line(1,1);

if(abs(angle) > pi/4 && abs(angle) < 3*pi/4)
    % Work in col-direction with one pixel
    if(line(1,2) <= line(2,2))
        col = line(1,2):line(2,2);
    else
        col = line(2,2):line(1,2);
    end
    row = (col - b)/a;
else
    % Work in row-direction with one pixel
    row = line(1,1):line(2,1);
    col = b + a*row;
end

row = round(row);
col = round(col);

% Filter things outside the image border
i = 1;
while(i <= length(row))
    if(row(i) > size_row || row(i) < 1 || col(i) > size_col || col(i) < 1)
        row(i) = [];
        col(i) = [];
    else
        i = i + 1;
    end
end

% Filter doubles
i = 1;
while(i <= length(row))
    tmp_row = row(i);
    tmp_col = col(i);
    
    j = i + 1;
    while(j < length(row))
        if(row(j) == tmp_row && col(j) == tmp_col)
            row(j) = [];
            col(j) = [];
        else
            j = j + 1;
        end
    end
    i = i+1;    
end
pixels = [row' col'];
end