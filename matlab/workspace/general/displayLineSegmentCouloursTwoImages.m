function displayLineSegmentCouloursTwoImages(lines1,lines2,rows,cols)
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/subaxis/'];
addpath(path_to_add);

figure();
options = ['r-'; 'g-';'y-';'m-';'c-'];
subaxis(1,2,1,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
imshow(zeros(rows,cols));
hold on;
for i = 1:length(lines1)
    index = mod(i,length(options));
    plot(lines1{i}(1:2,2),lines1{i}(1:2,1),options(index+1,:));
end
hold off;

subaxis(1,2,2);
imshow(zeros(rows,cols));
hold on;
for i = 1:length(lines2)
    index = mod(i,length(options));
    plot(lines2{i}(1:2,2),lines2{i}(1:2,1),options(index+1,:));
end
hold off;
end