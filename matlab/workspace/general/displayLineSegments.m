function displayLineSegments(I1,I2,line_segments1,line_segments2)
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/subaxis/'];
addpath(path_to_add);

figure();
subaxis(1,2,1,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
imshow(I1);
hold on;
for i = 1:length(line_segments1)
    plot(line_segments1{i}(1:2,2),line_segments1{i}(1:2,1),'r-');
end
hold off;

subaxis(1,2,2,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
imshow(I2);
hold on;
for i = 1:length(line_segments2)
    plot(line_segments2{i}(1:2,2),line_segments2{i}(1:2,1),'r-');
end
hold off;
end