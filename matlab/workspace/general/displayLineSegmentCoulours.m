function displayLineSegmentCoulours(line_segments,rows,cols)
figure();
options = ['r-'; 'g-';'y-';'m-';'c-'];
imshow(zeros(rows,cols));

hold on;
for i = 1:length(line_segments)
    index = mod(i,length(options));
    plot(line_segments{i}(1:2,2),line_segments{i}(1:2,1),options(index+1,:));
end
hold off;
end