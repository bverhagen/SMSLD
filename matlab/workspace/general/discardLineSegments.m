function segments = discardLineSegments(line_segments,length_threshold)
segments = cellfun(@(x) discardLineSegmentsHelper(x,length_threshold),line_segments,'UniformOutput',false);

% Remove empty line_segments
segments = line_segments(~cellfun('isempty',segments));
end

function segment = discardLineSegmentsHelper(line_segment,length_threshold)
% Instead of taking sqrt, square threshold
seg_length = (line_segment(2,2)-line_segment(1,2))^2+(line_segment(2,1)-line_segment(1,1))^2;
if(seg_length < length_threshold^2)
    segment = [];
else
    segment = line_segment;
end
end