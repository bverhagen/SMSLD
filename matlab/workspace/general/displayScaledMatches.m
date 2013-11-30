function displayScaledMatches(I1,I2,matches)
options = ['m-'; 'g-';'r-';'c-';'b-'];

figure();
subaxis(1,2,1,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
imshow(I1);
hold on;
for i = 1:size(matches,1)
    % Draw individual lines seperate to make sure non are occluded by
    % others
    if(matches{i,3}(1) ~= 0 || matches{i,3}(2) ~= 0)
        index = mod(i,length(options));
        angle = getAngle(matches{i,1});
        angle1 = angle + matches{i,3}(3);
        angle2 = angle - matches{i,3}(3);
        row_begin1 = matches{i,1}(1,1) - matches{i,3}(1)*cos(angle1);
        col_begin1 = matches{i,1}(1,2) - matches{i,3}(1)*sin(angle1);
        row_begin2 = matches{i,1}(1,1) - matches{i,3}(1)*cos(angle2);
        col_begin2 = matches{i,1}(1,2) - matches{i,3}(1)*sin(angle2);
        
        row_end1 = matches{i,1}(2,1) - matches{i,3}(2)*cos(angle1);
        col_end1 = matches{i,1}(2,2) - matches{i,3}(2)*sin(angle1);
        row_end2 = matches{i,1}(2,1) - matches{i,3}(2)*cos(angle2);
        col_end2 = matches{i,1}(2,2) - matches{i,3}(2)*sin(angle2);
        
        fill([col_begin1,matches{i,1}(1,2),matches{i,1}(2,2),col_end1],[row_begin1,matches{i,1}(1,1),matches{i,1}(2,1),row_end1],options(index+1,:));
        fill([col_begin2,matches{i,1}(1,2),matches{i,1}(2,2),col_end2],[row_begin2,matches{i,1}(1,1),matches{i,1}(2,1),row_end2],options(index+1,:));
    end
end
for i = 1:size(matches,1)
    index = mod(i,length(options));
    plot(matches{i,1}(1:2,2),matches{i,1}(1:2,1),options(index+1,:));
end
hold off;

subaxis(1,2,2);
imshow(I2);
hold on;
for i = 1:size(matches,1)
    % Draw individual lines seperate to make sure non are occluded by
    % others
    if(matches{i,4}(1) ~= 0 || matches{i,4}(2) ~= 0)
        index = mod(i,length(options));
        angle = getAngle(matches{i,2});
        angle1 = angle + matches{i,4}(3);
        angle2 = angle - matches{i,4}(3);
        row_begin1 = matches{i,2}(1,1) - matches{i,4}(1)*cos(angle1);
        col_begin1 = matches{i,2}(1,2) - matches{i,4}(1)*sin(angle1);
        row_begin2 = matches{i,2}(1,1) - matches{i,4}(1)*cos(angle2);
        col_begin2 = matches{i,2}(1,2) - matches{i,4}(1)*sin(angle2);
        
        row_end1 = matches{i,2}(2,1) - matches{i,4}(2)*cos(angle1);
        col_end1 = matches{i,2}(2,2) - matches{i,4}(2)*sin(angle1);
        row_end2 = matches{i,2}(2,1) - matches{i,4}(2)*cos(angle2);
        col_end2 = matches{i,2}(2,2) - matches{i,4}(2)*sin(angle2);
        
        fill([col_begin1,matches{i,2}(1,2),matches{i,2}(2,2),col_end1],[row_begin1,matches{i,2}(1,1),matches{i,2}(2,1),row_end1],options(index+1,:));
        fill([col_begin2,matches{i,2}(1,2),matches{i,2}(2,2),col_end2],[row_begin2,matches{i,2}(1,1),matches{i,2}(2,1),row_end2],options(index+1,:));
    end
end
for i = 1:size(matches,1)
    index = mod(i,length(options));
    plot(matches{i,2}(1:2,2),matches{i,2}(1:2,1),options(index+1,:));
end
hold off;
end