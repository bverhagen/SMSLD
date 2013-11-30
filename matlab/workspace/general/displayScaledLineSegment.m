function displayScaledLineSegment(I,line_segments,scales)
scale_factor = 6/8;
scales = scale_factor * scales;
figure();
imshow(I);
hold on;
for i = 1:length(line_segments)
    plot(line_segments{i}(1:2,2),line_segments{i}(1:2,1),'r-','LineWidth',scales(i,1));
end
hold off;
end