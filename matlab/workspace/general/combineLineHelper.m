function [combined_line,combined_scale] = combineLineHelper(line1,line2)
% !!! Cannot cope with lines that intersect themselves already !!!
% We assume that line(1,1) <= line(2,1) !!!
combined_scale = zeros(3,1);
% Find y = ax + b
angle1 = getAngle(line1);
a1 = tan(angle1);
b1 = line1(1,2) - a1 * line1(1,1);

angle2 = getAngle(line2);
a2 = tan(angle2);
b2 = line2(1,2) - a2 * line2(1,1);

if((abs(angle1) > pi/2-0.03 && abs(angle1) < pi/2+0.03) || (abs(angle2) > pi/2-0.03 && abs(angle2) < pi/2+0.03))
    if(abs(abs(angle1) - abs(angle2)) < 0.1)
        if((angle1 <= pi/2 && angle2 <= pi/2) || (angle1 >= pi/2 && angle2 >= pi/2))
            % Assume x is left and highest of the two.
            width = (line2(1,1) - line1(1,1))/2;
            begin1 = [line1(1,1) + width, line1(1,2)];
            end1 = [line1(2,1) + width, line1(2,2)];
            % Take into account the fact that they are not exactly parallel
            width = (line2(2,1) - line1(2,1))/2;
            begin2 = [line2(1,1) - width, line2(1,2)];
            end2 = [line2(2,1) - width, line2(2,2)];
        else
            % Assume x is left and highest of the two.
            width = (line2(2,1) - line1(1,1))/2;
            begin1 = [line1(1,1) + width, line1(1,2)];
            end1 = [line1(2,1) + width, line1(2,2)];
            % Take into account the fact that they are not exactly parallel
            width = (line2(1,1) - line1(2,1))/2;
            begin2 = [line2(1,1) - width, line2(1,2)];
            end2 = [line2(2,1) - width, line2(2,2)];
        end
        combined_scale(3) = pi/2;
        angle_bis = pi/2;
    else
        if(abs(angle1) > pi/2-0.03)
            x_intersection = line1(1,1);
            y_intersection = a2 * x_intersection + b2;
        else
            x_intersection = line2(1,1);
            y_intersection = a1 * x_intersection + b1;
        end
        % Construct bisectrice
        angle_bis = (angle1 + angle2)/2;
        if(abs(angle1 - angle_bis) > pi/4)
            % This means the other bissectrice is the better one.
            angle_bis = angle_bis + pi/2;
        end
        a_bis = tan(angle_bis);
        b_bis = y_intersection - a_bis * x_intersection;
        [begin1,end1] = projectOrthogonalPoints(line1(1,:),line1(2,:),angle1,a_bis,b_bis);
        [begin2,end2] = projectOrthogonalPoints(line2(1,:),line2(2,:),angle2,a_bis,b_bis);
    end
else
    % Check for quasi parallel lines
    if(abs(angle1 - angle2) < 0.01)
        a_bis = (a1 + a2)/2;
        b_bis = (b1 + b2)/2;
        combined_scale(3) = pi/2;
        
        % Needed for sorting of points
        angle_bis = (angle1 + angle2)/2;
        if(abs(angle1 - angle_bis) > pi/4)
            % This means the other bissectrice is the better one.
            angle_bis = angle_bis + pi/2;
        end
    else
        % Find intersecting point
        x_intersection = (b2-b1)/(a1-a2);
        y_intersection = a1 * x_intersection + b1;
        
        % Construct bisectrice
        angle_bis = (angle1 + angle2)/2;
        if(abs(angle1 - angle_bis) > pi/4)
            % This means the other bissectrice is the better one.
            angle_bis = angle_bis + pi/2;
        end
        a_bis = tan(angle_bis);
        b_bis = y_intersection - a_bis * x_intersection;
    end
    [begin1,end1] = projectOrthogonalPoints(line1(1,:),line1(2,:),angle1,a_bis,b_bis);
    [begin2,end2] = projectOrthogonalPoints(line2(1,:),line2(2,:),angle2,a_bis,b_bis);
end

if(abs(angle_bis) > pi/4 && abs(angle_bis) < 3*pi/4)
    % Sort on the second coordinates for robustness.
    to_sort  = [1 begin1(2) 1;1 end1(2) 2;2 begin2(2) 1;2 end2(2) 2];
else
    to_sort  = [1 begin1(1) 1;1 end1(1) 2;2 begin2(1) 1;2 end2(1) 2];
end
to_sort = sortrows(to_sort,2);

% Check configurations
if(to_sort(1,1) == to_sort(2,1)) % Don't test for 3 == 4, is the same X X O O
    % Prune, these line segments have no overlapping area
    combined_line = [];
    combined_scale = [-1 0 0];
    return;
end

if(to_sort(1,1) == to_sort(4,1))
    % Combine middel points: X O O X
    if(to_sort(2,1) == 1)
            % Means first first point of line1, then second point. Since
            % the order does not matter (is changed later to the right
            % format anyway, we don't have to test for the third column.
            combined_line = [begin1; end1];
            combined_scale(1) = getDistance(begin1,line1(1,:));
            combined_scale(2) = getDistance(end1,line1(2,:));               
    else
            combined_line = [begin2; end2];
            combined_scale(1) = getDistance(begin2,line2(1,:));
            combined_scale(2) = getDistance(end2,line2(2,:));
    end
else
    % X O X O
    if(to_sort(2,1) == 1)        
        if(to_sort(2,3) == 1)
            combined_line(1,:) = begin1;
            combined_scale(1) = getDistance(begin1,line1(1,:));
        else
            combined_line(1,:) = end1;
            combined_scale(1) = getDistance(end1,line1(2,:));
        end
        if(to_sort(3,3) == 2)
            combined_line(2,:) = end2;
            combined_scale(2) = getDistance(end2,line2(2,:));
        else
            combined_line(2,:) = begin2;
            combined_scale(2) = getDistance(begin2,line2(1,:));
        end
    else
        if(to_sort(2,3) == 1)
            combined_line(1,:) = begin2;
            combined_scale(1) = getDistance(begin2,line2(1,:));
        else
            combined_line(1,:) = end2;
            combined_scale(1) = getDistance(end2,line2(2,:));
        end
        if(to_sort(3,3) == 2)
            combined_line(2,:) = end1;
            combined_scale(2) = getDistance(end1,line1(2,:));
        else
            combined_line(2,:) = begin1;
            combined_scale(2) = getDistance(begin1,line1(1,:));
        end        
    end
end

% % Search which line begin to which line ending is the smallest.
% begin1end1 = getDistance(begin1,end1);
% begin1end2 = getDistance(begin1,end2);
% begin2end1 = getDistance(begin2,end1);
% begin2end2 = getDistance(begin2,end2);
% %begin1begin2 = getDistance(begin1,begin2);
% %end1end2 = getDistance(end1,end2);
%
% [~,min_index] = min([begin1end1, begin1end2,begin2end1,begin2end2]);
% %[~,min_index] = min([begin1end1, begin1end2,begin2end1,begin2end2,begin1begin2,end1end2]);
%
% switch(min_index)
%     case 1
%         combined_line = [begin1; end1];
%         combined_scale(1) = getDistance(begin1,line1(1,:));
%         combined_scale(2) = getDistance(end1,line1(2,:));
%     case 2
%         combined_line = [begin1; end2];
%         combined_scale(1) = getDistance(begin1,line1(1,:));
%         combined_scale(2) = getDistance(end2,line2(2,:));
%     case 3
%         combined_line = [begin2; end1];
%         combined_scale(1) = getDistance(begin2,line2(1,:));
%         combined_scale(2) = getDistance(end1,line1(2,:));
%     case 4
%         combined_line = [begin2; end2];
%         combined_scale(1) = getDistance(begin2,line2(1,:));
%         combined_scale(2) = getDistance(end2,line2(2,:));
%     case 5
%         combined_line = [begin1; begin2];
%         combined_scale(1) = getDistance(begin1,line1(1,:));
%         combined_scale(2) = getDistance(begin2,line2(2,:));
%     case 6
%         combined_line = [end1; end2];
%         combined_scale(1) = getDistance(end1,line1(1,:));
%         combined_scale(2) = getDistance(end2,line2(2,:));
%     otherwise
%         error('Something impossible happened');
% end
%
if(combined_line(1,1) > combined_line(2,1))
    % Interchange points
    combined_line = [combined_line(2,:);combined_line(1,:)];
    combined_scale = [combined_scale(2),combined_scale(1),combined_scale(3)];
end

% Find the corner under which we can reconstruct the trapezoid.
% However, this depends on which side of the lines the bissectrice
% lies. Therefore we have to take the difference of the scales into
% account.
if(combined_scale(2) < combined_scale(1))
    % Take complementary angle
    %combined_scale(3) = abs(pi + abs(angle2-angle1))/2;
    combined_scale(3) = pi/2 + abs(angle1-getAngle(combined_line));
else
    combined_scale(3) = pi/2 - abs(angle1-getAngle(combined_line));
end
end

function distance = getDistance(point1,point2)
distance = sqrt((point2(2)-point1(2))^2+(point2(1)-point1(1))^2);
end

function [result1,result2] = projectOrthogonalPoints(point1,point2, angle, a_bis,b_bis)
% We assume point1 and point2 are two points on the same line.

% Be careful for special cases like angle = 0 and angle = pi/2. Atm Matlab
% seems to handle them quite well.
result1 = zeros(1,2);
result2 = zeros(1,2);
% Contruct orthogonal lines of line1
angle_orth = angle+pi/2;
a_orth = tan(angle_orth);
b_orth1 = point1(2) - a_orth * point1(1);
b_orth2 = point2(2) - a_orth * point2(1);

% Find intersecting point of bissectrice and orthogonal line
result1(1) = (b_orth1 - b_bis)/(a_bis - a_orth);
result1(2) = a_bis * result1(1) + b_bis;
result2(1) = (b_orth2 - b_bis)/(a_bis - a_orth);
result2(2) = a_bis * result2(1) + b_bis;
end