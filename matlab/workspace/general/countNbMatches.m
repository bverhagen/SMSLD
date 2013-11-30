function nb_scale_matches = countNbMatches(matches,verbose)
% Check number of matches that have a scale other than 0.
nb_scale_matches = 0;
for i = 1:size(matches,1)
    if(matches{i,3}(1) ~= 0 || matches{i,3}(2) ~= 0 || matches{i,4}(1) ~= 0 || matches{i,4}(1) ~= 0)
        nb_scale_matches = nb_scale_matches + 1;
    end
end
if(verbose)
    fprintf(1,'Number of scaled matches: %d\n',nb_scale_matches);
end
end