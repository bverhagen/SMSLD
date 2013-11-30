function [segments,scales] = discardScaleLineSegments(line_segments,scales, length_threshold)
keep = cellfun(@(x) discardLineSegmentsHelper(x,length_threshold),line_segments);

% Remove empty line_segments
scales = scales(keep == true,:);
segments = line_segments(keep == true);
end

function keep = discardLineSegmentsHelper(line_segment,length_threshold)
% Instead of taking sqrt, square threshold
seg_length = (line_segment(2,2)-line_segment(1,2))^2+(line_segment(2,1)-line_segment(1,1))^2;
if(seg_length < length_threshold^2)
    keep = false;
else
    keep = true;
end
end