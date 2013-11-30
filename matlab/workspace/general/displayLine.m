function displayLine(line,varargin)
option = 'b-';
if(~isempty(varargin))
    option = varargin{1};
end
plot(line(1:2,2),line(1:2,1),option);
end