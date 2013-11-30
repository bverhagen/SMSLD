function lines = collinearMerge(lines,Options)
% This function applies collinear line merging on the lines (format: [x1
% y1; x2 y2]. The collinear line merging is applied without using the descriptor
% information. 
prev_size = 0;

lines = sortSegments(lines);
if(Options.verbose == 2)
    counter = 0;
    fprintf('iteration %3d',counter);
end
while(prev_size ~= size(lines,1))
    if(Options.verbose == 2)
        counter = counter + 1;
        fprintf('\b\b\b%3d',counter);
    end
    prev_size = size(lines,1);
    merged = zeros(size(lines,1),1);
    [innerdist,outerdist,outer_index] = getInnerOuterPoints(lines);
    lambdas = collinearity(lines,Options.collinearity_sigma_theta,Options.collinearity_sigma_w);
    goodness_function = getLineMergingGoodnessFunction(innerdist,outerdist,lambdas);
    [candidates_row,candidates_col] = find(goodness_function > Options.collinearity_threshold);
    
    % Process candidates
    for i = 1:size(lines,1)
        if(merged(i) == 0)
            merging_candidates = candidates_col(candidates_row == i);
            % Remove itself and all lower (due to symmetry) from the results (otherwise this one will always be the best).
            merging_candidates = merging_candidates(merging_candidates > i);
            if(~isempty(merging_candidates))
                merging_goodness_function = goodness_function(i,merging_candidates);
                [~,best_candidate] = max(merging_goodness_function);
                merged_line_index = merging_candidates(best_candidate);
                if(merged(merged_line_index) == 0)
                    line_to_merge = lines{merged_line_index};
                    % assign as merged
                    merged(merged_line_index) = 1;
                    merged(i) = 1;
                    lines{i} = mergeLines(line_to_merge,lines{i},outer_index(i,merged_line_index));
                    lines{merged_line_index} = [];
                end
            end
        end
    end
    lines = lines(~cellfun('isempty',lines));
end
end

function goodness_function = getLineMergingGoodnessFunction(innerdist,outerdist,lambdas)
goodness_function = (1-innerdist./outerdist).*sqrt(lambdas.*lambdas');
end

function line = mergeLines(line1,line2,index)
switch(index)
    case 1
        col1 = line1(1,2);
        row1 = line1(1,1);
        col2 = line2(1,2);
        row2 = line2(1,1);
    case 2
        col1 = line1(1,2);
        row1 = line1(1,1);
        col2 = line2(2,2);
        row2 = line2(2,1);
    case 3
        col1 = line1(2,2);
        row1 = line1(2,1);
        col2 = line2(1,2);
        row2 = line2(1,1);
    case 4
        col1 = line1(2,2);
        row1 = line1(2,1);
        col2 = line2(2,2);
        row2 = line2(2,1);
    otherwise
        col1 = 0;
        row1 = 0;
        col2 = 0;
        row2 = 0;
end
if(row1 > row2)
    % Change points so first point has smallest row number.
    tmp_x = col1;
    tmp_y = row1;
    col1 = col2;
    row1 = row2;
    col2 = tmp_x;
    row2 = tmp_y;
end

line(1,1) = row1;
line(1,2) = col1;
line(2,1) = row2;
line(2,2) = col2;
end

function collinearities = collinearity(lines,sigma_theta,sigma_w)
li_angles = cellfun(@getAngle,lines);

angles = zeros(length(lines),length(lines));
d_orth = zeros(length(lines),length(lines));

% Vectorize?
for i = 1:length(lines)
    for j = 1:i-1
        % Get the infinite support line by orthogonal regression of the
        % endpoints
        p = linortfit2([lines{i}(1:2,1)', lines{j}(1:2,1)'],[lines{i}(1:2,2)', lines{j}(1:2,2)']);
        % Take some points from this line as input for next calculations.
        support_line = zeros(2,2);
        support_line(1,1) = 0;
        support_line(1,2)= p(2);
        support_line(2,1) = 1000;
        support_line(2,2) = p(2) + p(1)*support_line(2,1);
        l_angle = getAngle(support_line);
        
        angles(i,j) = li_angles(i) - l_angle;
        angles(j,i) = li_angles(j) - l_angle;
        
        d_orth(i,j) = getOrthogonalDistance(lines{i}(1:2,1:2),support_line);
        d_orth(j,i) = getOrthogonalDistance(lines{j}(1:2,1:2),support_line);
    end
end

collinearities = normpdf(angles,0,sigma_theta).*normpdf(d_orth,0,sigma_w);
end
