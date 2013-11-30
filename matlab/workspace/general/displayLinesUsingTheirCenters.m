function displayLinesUsingTheirCenters(I1,I2,matches,color)
whitespace = 20;
options = [[1 0 0]; [0 1 0]; [1 0 1];[0 1 1];[0.75 0 0.75];[0 0.75 0.75];[0.75 0.75 0];[0 1 0.5];[0.5 0 1];[0 0.5 1];[0.5 1 0]];
features1 = calculateLineFeatureCenters(matches(:,1));
    features2 = calculateLineFeatureCenters(matches(:,2));
    
    I_big = 255*ones(size(I1,1)+size(I2,1)+whitespace,size(I1,2),size(I1,3),'uint8');
    I_big(1:size(I1,1),:,:) = I1;
    I_big(size(I1,1) + whitespace+1:end,:,:) = I2;
    
    imshow(I_big);
    hold on;
    %% Show matched line segments.
    % First image
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
            
            fill([col_begin1,matches{i,1}(1,2),matches{i,1}(2,2),col_end1],[row_begin1,matches{i,1}(1,1),matches{i,1}(2,1),row_end1], options(index+1,:));
            fill([col_begin2,matches{i,1}(1,2),matches{i,1}(2,2),col_end2],[row_begin2,matches{i,1}(1,1),matches{i,1}(2,1),row_end2],options(index+1,:));
        end
    end
    for i = 1:size(matches,1)
        index = mod(i,length(options));
        plot(matches{i,1}(1:2,2),matches{i,1}(1:2,1),'Color', options(index+1,:));
    end
    
    % Second image
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
            
            fill([col_begin1,matches{i,2}(1,2),matches{i,2}(2,2),col_end1],[row_begin1+whitespace+size(I1,1)+1,matches{i,2}(1,1)+whitespace+size(I1,1)+1,matches{i,2}(2,1)+whitespace+size(I1,1)+1,row_end1+whitespace+size(I1,1)+1],options(index+1,:));
            fill([col_begin2,matches{i,2}(1,2),matches{i,2}(2,2),col_end2],[row_begin2+whitespace+size(I1,1)+1,matches{i,2}(1,1)+whitespace+size(I1,1)+1,matches{i,2}(2,1)+whitespace+size(I1,1)+1,row_end2+whitespace+size(I1,1)+1],options(index+1,:));
        end
    end
    for i = 1:size(matches,1)
        index = mod(i,length(options));
        plot(matches{i,2}(1:2,2),matches{i,2}(1:2,1)+whitespace+size(I1,1)+1,'Color',options(index+1,:));
    end
    
    %% Show correspondence lines.
    for i = 1:size(features1,1)
        plot([features1(i,2),features2(i,2)],[features1(i,1),features2(i,1)+whitespace+size(I1,1)+1],[color,'-']);
    end
    hold off;
end

function centers = calculateLineFeatureCenters(lines)
feature_centers = cellfun(@calculateLineFeatureCentersHelper,lines,'UniformOutput',false);
centers = cell2mat(feature_centers);
end

function feature_center = calculateLineFeatureCentersHelper(line)
feature_center = zeros(1,2);
% Return midpoint of the line
feature_center(1) = (line(2,1)+line(1,1))/2;
feature_center(2) = (line(2,2)+line(1,2))/2;
end