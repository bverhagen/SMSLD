function displayLineSegment(I,line_segments)
figure();
imshow(I);
hold on;
for i = 1:length(line_segments)
    plot(line_segments{i}(1:2,2),line_segments{i}(1:2,1),'r-');
end
hold off;
end