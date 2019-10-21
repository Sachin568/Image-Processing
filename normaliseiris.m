% normaliseiris - performs normalisation of the iris region by unwraping the circular region into a 
% rectangular block of constant dimensions.
%
% Usage: 
% [polar_array, polar_noise] = normaliseiris(image, x_iris, y_iris, r_iris,...
% x_pupil, y_pupil, r_pupil,eyeimage_filename, radpixels, angulardiv)
%
% Arguments:
% image                 - the input eye image to extract iris data from
% x_iris                - the x coordinate of the circle defining the iris boundary
% y_iris                - the y coordinate of the circle defining the iris boundary
% r_iris                - the radius of the circle defining the iris boundary
% x_pupil               - the x coordinate of the circle defining the pupil boundary
% y_pupil               - the y coordinate of the circle defining the pupil boundary
% r_pupil               - the radius of the circle defining the pupil boundary
% eyeimage_filename     - original filename of the input eye image
% radpixels             - radial resolution, defines vertical dimension of normalised representation
% angulardiv            - angular resolution, defines horizontal dimension of normalised representation
%
% Output:
% polar_array  &  polar_noise


function [polar_array, polar_noise] = normaliseiris(image, x_iris, y_iris, r_iris,...
x_pupil, y_pupil, r_pupil,fnamee, radpixels, angulardiv)

global DIAGPATH

radiuspixels = radpixels + 2;                                               % this value is 22
angledivisions = angulardiv-1;                                              % this value is 239

r = 0:(radiuspixels-1);                                                     % why? r=0 to 21
theta = 0:2*pi/angledivisions:2*pi;                                         %(0 to 2*pi) in steps of 2*pi/239

x_iris = double(x_iris);
y_iris = double(y_iris);
r_iris = double(r_iris);

x_pupil = double(x_pupil);
y_pupil = double(y_pupil);
r_pupil = double(r_pupil);

% calculate displacement of pupil center from the iris center
ox = x_pupil - x_iris;
oy = y_pupil - y_iris;

if ox <= 0
    sgn = -1;
elseif ox > 0
    sgn = 1;
end

if ox==0 && oy > 0
    sgn = 1;
end

r = double(r);
theta = double(theta);

a = ones(1,angledivisions+1)* (ox^2 + oy^2);                                % store the value of x^2+y^2 240 times;  but why?
b = sgn.*cos(pi - atan(oy/ox) - theta);

% calculate radius around the iris as a function of the angle               % conversion for cartisian to polar
r = (sqrt(a).*b) + ( sqrt( a.*(b.^2) - (a - (r_iris^2))));
r = r - r_pupil;                                                            %display(r);

rmat = ones(1,radiuspixels)'*r;                                             %display(rmat)
rmat = rmat.* (ones(angledivisions+1,1)*[0:1/(radiuspixels-1):1])';         % here angular division value is again 240---------0 to 1 in terms of 1/20
rmat = rmat + r_pupil;

% exclude values at the boundary of the pupil iris border, and the iris scelra border
% as these may not correspond to areas in the iris region and will introduce noise.ie don't take the outside rings as iris data.
rmat  = rmat(2:(radiuspixels-1), :);

% calculate cartesian location of each data point around the circular iris region
cosmat = ones(radiuspixels-2,1)*cos(theta);
sinmat = ones(radiuspixels-2,1)*sin(theta);

xo = rmat.*cosmat;    
yo = rmat.*sinmat;

%Why is this done?????
xo = x_pupil+xo;
yo = y_pupil-yo;

% extract intensity values into the normalised polar representation through interpolation
[x,y] = meshgrid(1:size(image,2),1:size(image,1));  
polar_array = interp2(x,y,image,xo,yo);
polar_array = double(polar_array)./255;

% create noise array with location of NaNs in polar_array
polar_noise = zeros(size(polar_array));
coords = find(isnan(polar_array));                                          %NaN=Not A Number
polar_noise(coords) = 1;

% start diagnostics, writing out eye image with rings overlayed

% get rid of outline points in order to write out the circular pattern
coords = find(xo > size(image,2));
xo(coords) = size(image,2);
coords = find(xo < 1);
xo(coords) = 1;

coords = find(yo > size(image,1));
yo(coords) = size(image,1);
coords = find(yo<1);
yo(coords) = 1;

%again unnecessary
xo = round(xo);
yo = round(yo);

xo = int32(xo);
yo = int32(yo);

ind1 = sub2ind(size(image),double(yo),double(xo));
image = uint8(image);
image(ind1) = 255;

%get pixel coords for circle around iris
[x,y] = circlecordinates([x_iris,y_iris],r_iris,size(image));
ind2 = sub2ind(size(image),double(y),double(x));

%get pixel coords for circle around pupil
[xp,yp] = circlecordinates([x_pupil,y_pupil],r_pupil,size(image));
ind1 = sub2ind(size(image),double(yp),double(xp));

image(ind2) = 255;
image(ind1) = 255;

%%%%% write out rings overlaying original iris image
w = cd;
cd(DIAGPATH);
imwrite(image,[fnamee,'-normal.jpg'],'jpg');
cd(w);
%%%%% end diagnostics

%replace NaNs before performing feature encoding
coords = find(isnan(polar_array));
polar_array2 = polar_array;
polar_array2(coords) = 0.5;                                                 %why this line
avg = sum(sum(polar_array2)) / (size(polar_array,1)*size(polar_array,2));
polar_array(coords) = avg;
%imshow(polar_array);title('normalized iris image');