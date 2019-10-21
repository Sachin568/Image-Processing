% segmentiris - peforms automatic segmentation of the iris region from an eye image. Also isolates noise areas such as occluding
% eyelids and eyelashes.
%
% Usage: 
% [circleiris, circlepupil, imagewithnoise] = segmentiris(image)
%
% Arguments:
%	eyeimage		- the input eye image
%	
% Output:
%	circleiris	    - centre coordinates and radius of the detected iris boundary
%	circlepupil	    - centre coordinates and radius of the detected pupil boundary
%	imagewithnoise	- original eye image, but with location of noise marked with NaN values

function [circleiris, circlepupil, imagewithnoise] = segment(eyeimage)

%[fname, path]=uigetfile('*.*','input an image');
%fname=strcat(path,fname);
%eyeimage=imread(fname);                                                     

[hor,ver]=size(eyeimage);

% define range of pupil & iris radii CASIA
lpupilradius = 30;  upupilradius = 55;                                      %pupil radius range
lirisradius = 75;   uirisradius = 165;                                      %iris radius rang %reflecthres = 240;

% define scaling factor to speed up Hough transform and sigma for gaussian filter
scaling = 1.00;     sigma = 4;      threshold = 0.1;

% find the iris boundary
rng = [lirisradius,uirisradius];        edgethrs=0.1;
[row, col, r] = circle(eyeimage,threshold,sigma,scaling,edgethrs,rng);
row = round(row);           col = round(col);
circleiris = [row, col, r];                                                 %display(circleiris); return vallue
rowd = double(row);           cold = double(col);           rd = double(r);
irl = round(rowd-rd);         iru = round(rowd+rd);

if iru > hor
    iru = hor;
end

icl = round(cold-rd);         icu = round(cold+rd);

if icu > ver
    icu = ver;
end
                                                                            %display([irl,iru,icl,icu]);
%find pupil by cropping the original image
imagepupil = eyeimage(irl:iru,icl:icu);                       %figure;imshow(imagepupil);
%[r,c]=size(imagepupil);                                                    %display([r,c]);

scaling = 1.00;     sigma = 5;      threshold = 0.15;       edgethrs = 0.4;
rng = round([lpupilradius,upupilradius].*0.9);                              %display(rng);
[rowp, colp, rp] = circle(imagepupil,threshold,sigma,scaling,edgethrs,rng); %circlepupil=([rowp,colp,rp]);display(circlepupil);

rowp = double(rowp);          colp = double(colp);          r = double(rp);   
row = double(irl) + rowp;     col = double(icl) + colp;
row = round(row);             col = round(col);
circlepupil = [row, col, rp];                                               %display(circlepupil);
% imshow(eyeimage);hold on
% viscircles([cold,rowd],rd,'edgecolor','w');viscircles([col,row],rp,'edgecolor','w');

imagewithnoise = double(eyeimage);
rowp = round(rowp);           colp = round(colp);           r = round(rp);

%find top eyelid
topeyelid = imagepupil(1:(rowp-r),:);                                       %figure;imshow(topeyelid);
lines = findline(topeyelid);

if size(lines,1) > 0
    [xl ,yl] = linecoords(lines, size(topeyelid));
    yl = double(yl) + irl-1;            xl = double(xl) + icl-1;
    yla = max(yl);    
    y2 = 1:yla;    
    ind3 = sub2ind(size(eyeimage),yl,xl);
    imagewithnoise(ind3) = NaN;    
    imagewithnoise(y2, xl) = NaN;                                           %figure;imshow(imagewithnoise)
end

%find bottom eyelid
bottomeyelid = imagepupil((rowp+r):size(imagepupil,1),:);
lines = findline(bottomeyelid);

if size(lines,1) > 0
    
    [xl, yl] = linecoords(lines, size(bottomeyelid));
    yl = double(yl) + irl + rowp+r-2;       xl = double(xl) + icl-1;
    yla = min(yl);    
    y2 = yla:size(eyeimage,1);    
    ind4 = sub2ind(size(eyeimage),yl,xl);
    imagewithnoise(ind4) = NaN;
    imagewithnoise(y2, xl) = NaN;                                           %NaN represents 'not a number'
end

%For CASIA, eliminate eyelashes by thresholding
ref = eyeimage < 100;
coords = find(ref==1);
imagewithnoise(coords) = NaN;                                               %figure;imshow(imagewithnoise);