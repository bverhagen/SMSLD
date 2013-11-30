function is_correct = checkMatches(I1,I2,matches,H,Options,verbose)
% This function checks whether the provided matches are correct given the
% homography H.
% Options is a struct containing those parameters:
%   checkMatches_distance_threshold     Defines the maximum orthogonal
%   distance between the corresponding line segment and the real support
%   line.
%   checkMatches_angle_threshold        Defines the maximum orientation
%   deviation of the corresponding line segment from the real support line.
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/../general/subaxis'];
addpath(path_to_add);
path_to_add = [path, '/../general/linortfit'];
addpath(path_to_add);

homography_places = cellfun(@(x) (H*[x(:,2:-1:1)'; ones(1,2)])',matches(:,1),'UniformOutput',false);
homography_places = cellfun(@(x)  [x(:,2)./x(:,3), x(:,1)./x(:,3)],homography_places,'UniformOutput',false);

is_correct = cellfun(@(x,y) compareSpots(x,y,Options),matches(:,2),homography_places);

if(Options.showCheckMatches)
    plot_colours = zeros(size(is_correct,1),2);
    for i = 1:size(is_correct,1)
        if(is_correct(i) == 1)
            plot_colours(i,:) = 'g-';
        else
            plot_colours(i,:) = 'r-';
        end
    end
    plot_colours = mat2cell(plot_colours,ones(size(plot_colours,1),1),2);
    
    figure();
    subaxis(1,2,1,'Spacing', 0.005,'Padding', 0.005, 'Margin', 0.005);
    imshow(I1);
    hold on;
    cellfun(@(x,y) displayLine(x,char(y)),matches(:,1),plot_colours);
    hold off;
    
    subaxis(1,2,2)
    imshow(I2);
    hold on;
    cellfun(@(x,y) displayLine(x,char(y)),matches(:,2),plot_colours);
    
    for i = 1:length(is_correct)
        if(is_correct(i) == 1)
            displayLine(matches{i,2},'g-');
        else
            displayLine(matches{i,2},'r-');
        end
    end
    hold off;
    
    displayLineSegments(I1,I2,matches,homography_places);
end

if(verbose)
    fprintf(1,'Total number of matches: %d\n', size(is_correct,1));
    fprintf(1,'Number of correct matches: %d\n',sum(is_correct));
    fprintf(1,'Correct matches ratio: %.4f\n', sum(is_correct)/size(is_correct,1));
end
end

function is_correct = compareSpots(found_line, right_line,Options)
angle1 = getAngle(found_line);
angle2 = getAngle(right_line);

if(angle1 > 0)
    alternative_angle = angle1 - pi;
else
    alternative_angle = angle1+pi;
end

angle_to_check = min([abs(angle1-angle2), abs(alternative_angle-angle2)]);
distance = getOrthogonalDistance(found_line,right_line);

if(angle_to_check <= Options.checkMatches_angle_threshold && distance <= Options.checkMatches_distance_threshold)
    is_correct = 1;
else
    is_correct = 0;
end
end