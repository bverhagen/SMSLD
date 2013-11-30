function displayScaledLineSegments(I1,I2,lines1,lines2,scales1,scales2)
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/subaxis/'];
addpath(path_to_add);

options = ['r'; 'g';'y';'m';'c'];

figure();
% subaxis(1,2,1,'Spacing', 0.005, 'Padding', 0.005, 'Margin', 0.005);
%     imshow(I1);
%     hold on;
%     for i = 1:length(lines1)
%         index = mod(i,length(options));
%         plot(lines1{i}(1:2,2),lines1{i}(1:2,1),options(index+1,:));
%     end
%     hold off;
%     subaxis(1,2,2);
     imshow(I2);
    hold on;
    for i = 1:length(lines2)
        index = mod(i,length(options));
        angle = getAngle(lines2{i});
        angle1 = angle + scales2(i,3);
        angle2 = angle - scales2(i,3);
        row_begin1 = lines2{i}(1,1) - scales2(i,1)*cos(angle1);
        col_begin1 = lines2{i}(1,2) - scales2(i,1)*sin(angle1);   
        row_begin2 = lines2{i}(1,1) - scales2(i,1)*cos(angle2);
        col_begin2 = lines2{i}(1,2) - scales2(i,1)*sin(angle2);  
        
        row_end1 = lines2{i}(2,1) - scales2(i,2)*cos(angle1);
        col_end1 = lines2{i}(2,2) - scales2(i,2)*sin(angle1);
        row_end2 = lines2{i}(2,1) - scales2(i,2)*cos(angle2);
        col_end2 = lines2{i}(2,2) - scales2(i,2)*sin(angle2); 
        
        fill([col_begin1,lines2{i}(1,2),lines2{i}(2,2),col_end1],[row_begin1,lines2{i}(1,1),lines2{i}(2,1),row_end1],options(index+1,:));  
        fill([col_begin2,lines2{i}(1,2),lines2{i}(2,2),col_end2],[row_begin2,lines2{i}(1,1),lines2{i}(2,1),row_end2],options(index+1,:));
        plot(lines2{i}(1:2,2),lines2{i}(1:2,1),'k-');
    end
    hold off;
end