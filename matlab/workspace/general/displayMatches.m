function displayMatches(I1,I2,line_segments1,line_segments2,matches)
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/subaxis'];
addpath(path_to_add);

options = ['r-'; 'g-';'y-';'m-';'c-'];
figure();
subaxis(1,2,1,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
imshow(I1);
hold on;
for i = 1:size(matches,1)
    index = mod(i,length(options));
    plot(line_segments1{matches(i,1)}(1:2,2),line_segments1{matches(i,1)}(1:2,1),options(index+1,:),'LineWidth',2);
end
hold off;

subaxis(1,2,2);
imshow(I2);
hold on;
for i = 1:size(matches,1)
    index = mod(i,length(options));
    plot(line_segments2{matches(i,2)}(1:2,2),line_segments2{matches(i,2)}(1:2,1),options(index+1,:),'LineWidth',2);
end
hold off;
end