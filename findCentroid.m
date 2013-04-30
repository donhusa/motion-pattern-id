%x, y, width, height of face
function [x,y] = findCentroid (bbox)
    x = floor(bbox(3)/2+bbox(1));
    y = floor(bbox(4)/2+bbox(2));
end