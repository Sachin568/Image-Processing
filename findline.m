% findline - returns the coordinates of a line in an image using the
% linear Hough transform and Canny edge detection to create
% the edge map.
%
% Usage: 
% lines = findline(image)
%
% Arguments:
%	image   - the input image
%
% Output:
%	lines   - parameters of the detected line in polar form
%

function lines = findline(image)

threshold = 0.145;
sigma = 2;
cannyedge=edge(image,'canny','both',threshold,sigma);                    %figure;imshow(cannyedge);

theta = (0:179)';
[R, xp] = radon(cannyedge, theta);

maxv = max(max(R));

if maxv > 25
    i = find(R == max(max(R)));
else
    lines = [];
    return;
end

[foo, ind] = sort(-R(i));
u = size(i,1);
k = i(ind(1:u));
[y,x]=ind2sub(size(R),k);
t = -theta(x)*pi/180;
r = xp(y);

lines = [cos(t) sin(t) -r];

cx = size(image,2)/2-1;
cy = size(image,1)/2-1;
lines(:,3) = lines(:,3) - lines(:,1)*cx - lines(:,2)*cy;
