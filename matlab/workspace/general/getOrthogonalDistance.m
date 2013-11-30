function d = getOrthogonalDistance(line1,line2)
P = [(line1(1,1)+line1(2,1))/2, (line1(1,2)+line1(2,2))/2];
Q1 = line2(2,:);
Q2 = line2(1,:);
d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1); % for col. vectors
end