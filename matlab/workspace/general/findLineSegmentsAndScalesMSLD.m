function [lines,scales] = findLineSegmentsAndScalesMSLD(I,Options)
if(Options.verbose == 2)
    fprintf(1,'\tDetecting line segments...');
end
lines =  detectAllLines(I);
if(Options.verbose == 2)
    fprintf(1,'\t Nb of found line segments: %d\n',size(lines,1));
end

if(Options.showMergedLineSegments)
    lines_old = lines;
end
%lines = collinearMerge(lines,Options);
if(Options.verbose == 2)
    fprintf(1,'\tDiscarding small line segments...');
end
if(Options.showDiscardedSmallLines)
    lines_old = lines;
end
lines = discardLineSegments(lines,Options.minimum_line_length);
if(Options.verbose == 2)
    fprintf(1,'\t Nb of found line segments: %d\n',size(lines,1));
end
if(Options.showDiscardedSmallLines)
    displayLineSegmentCouloursTwoImages(lines_old,lines,size(I,1),size(I,2));
    title('Image after discarding small lines');
    subaxis(1,2,1);
    title('Image before discarding small lines');
end

if(Options.verbose == 2)
    fprintf(1,'\tSearching scales and scaled candidates...');
end
scales = zeros(size(lines,1),3);
% Set the angle with respect to the line to pi/2 for the lines with scale 0
scales(:,3) = pi/2 * ones(size(lines,1),1);

combined_ptr = 0;
combined_lines = cell(2*size(lines,1),1);
combined_scale = zeros(2*size(lines,1),3);
combined_lines_index = zeros(2*size(lines,1),2);

angles = calculateDiffAngles(lines);
[rows,columns] = find(abs(angles) < Options.scale_angle);
for i = 1:size(lines,1)
    % Select the columns for which the row index is i
    tmp_columns = columns(rows == i);
    % Remove the line segment itself
    tmp_columns = tmp_columns(tmp_columns ~= i);
    if(~isempty(tmp_columns))
        tmp_line = lines(tmp_columns);
        line_indexes = getLinesToCombineWith(lines{i},tmp_line,Options.extract_scales_distance_threshold, Options.nb_of_scale_matches);
        real_indexes = tmp_columns(line_indexes);
        if(~isempty(line_indexes))
            for j = 1:length(line_indexes)
                if(~checkCombinationExists(i,real_indexes(j),combined_lines_index(1:combined_ptr,:)))
                    [tmp_comb_line,tmp_comb_scale] = combineLineHelper(lines{i},lines{real_indexes(j)});
                    if(~isempty(tmp_comb_line))
                        combined_ptr = combined_ptr + 1;
                        combined_lines{combined_ptr} = tmp_comb_line;
                        combined_scale(combined_ptr,:) = tmp_comb_scale;
                        combined_lines_index(combined_ptr,:) = [i, real_indexes(j)];
                    end
                end
            end
        end
    end
end

combined_lines = combined_lines(1:combined_ptr);
combined_scale = combined_scale(1:combined_ptr,:);
if(Options.verbose == 2)
    fprintf(1,'\t Nb of found scale line segments: %d\n',size(combined_lines,1));
    fprintf(1,'\tDiscarding small scale line segments...');
end
if(Options.showDiscardedSmallScaleLines)
    combined_lines_old = lines;
end
[combined_lines,combined_scale] = discardScaleLineSegments(combined_lines,combined_scale,Options.minimum_line_length);
if(Options.verbose == 2)
    fprintf(1,'\t Nb of found line segments: %d\n',size(combined_lines,1));
end
if(Options.showDiscardedSmallScaleLines)
    displayLineSegmentCouloursTwoImages(combined_lines_old,combined_lines,size(I,1),size(I,2));
    title('Image after discarding small scale lines');
    subaxis(1,2,1);
    title('Image before discarding small scale lines');
end

if(Options.showScaledLines)
    displayScaledLineSegments(I,I,lines,combined_lines,ones(size(lines,1),1),combined_scale);
end

lines(end+1:end+size(combined_lines,1)) = combined_lines(1:size(combined_lines,1));
scales(end+1:end+size(combined_lines,1),:) = combined_scale(1:size(combined_lines,1),:);
if(Options.verbose == 2)
    fprintf(1,'\t Nb of found candidates: %d\n',size(lines,1));
end
end

function exists = checkCombinationExists(index1,index2,indexes)
% We assume that combination can only occur with index2 in first column of
% indexes and index 1 in the second.
cols = indexes(indexes(:,1) == index2,2);
if(~isempty(cols == index1))
    exists = true;
else
    exists = false;
end
end

function indexes = getLinesToCombineWith(line,lines,distance_threshold,nb_of_scale_matches)
[~,mean_distances] = cellfun(@(x) directionalDistance(line,x),lines);

indexes = find(mean_distances <= distance_threshold);
mean_distances = mean_distances(mean_distances <= distance_threshold);
if(~isempty(mean_distances))
    to_sort = [indexes mean_distances];
    to_sort = sortrows(to_sort,2);
    if(size(to_sort,1) > nb_of_scale_matches)
        indexes = to_sort(1:nb_of_scale_matches,1);
    else
        indexes = to_sort(:,1);
    end
else
    indexes = [];
end
end

function [orth_distance,mean_distance] = directionalDistance(line1,line2)
% Distance is calculated based on the  mean of the endpoints of the line.
P = [(line2(1,1)+line2(2,1))/2, (line2(1,2)+line2(2,2))/2];
Q1 = line1(1,:);
Q2 = line1(2,:);
orth_distance = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);

if((line1(1,1) <= line1(2,1) && line2(1,1) <= line2(2,1)) || (line1(1,1) > line1(2,1) && line2(1,1) > line2(2,1)))
    % Combine two begin points
    distance1 = sqrt((line1(1,2)-line2(1,2))^2+(line1(1,1)-line2(1,1))^2);
    distance2 = sqrt((line1(2,2)-line2(2,2))^2+(line1(1,1)-line2(1,1))^2);
else
    % Combine beginpoint of point 1 with endpoint of point 2
    distance1 = sqrt((line1(1,2)-line2(2,2))^2+(line1(1,1)-line2(2,1))^2);
    distance2 = sqrt((line1(2,2)-line2(1,2))^2+(line1(2,1)-line2(1,1))^2);
end
mean_distance = mean([distance1 distance2]);
end

function angles = calculateDiffAngles(lines)
line_angles = cellfun(@getAngle,lines);

angles = pi/2*ones(size(lines,1));
for i = 1:size(lines,1)
    angles(i,:) = line_angles(i)-line_angles;
end
% For making the circle round, the angle_distance can not be bigger than
% pi/2.
angles(angles > pi/2) = pi - angles(angles > pi/2);
% and bigger than -pi/2
angles(angles < -pi/2) = - pi - angles(angles < -pi/2);
end