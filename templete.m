% createiristemplate - generates a biometric template from an iris in an eye image.

function [segmentediris,template, mask, polar_array] = templete(eyeimage_filename)
%[fnamee, path] = uigetfile('*.*','input an image'); 
%fname = strcat(path,fnamee); eyeimage = imread(fname);

eyeimage = imread(eyeimage_filename);

% path for writing diagnostic images
global DIAGPATH
DIAGPATH = 'diagnostics';

%eyeimage = imread(eyeimage_filename); 
savefile = [eyeimage_filename,'-houghpara.mat'];
[stat,mess]=fileattrib(savefile);

if stat == 1
    % if this file has been processed before then load the circle parameters andnoise information for that file.
    load(savefile);
else
    % if this file has not been processed before then perform automatic segmentation and save the results to a file
    [circleiris, circlepupil, imagewithnoise] = segment(eyeimage);
    save(savefile,'circleiris','circlepupil','imagewithnoise');
end

% WRITE NOISE IMAGE
imagewithnoise2 = uint8(imagewithnoise);
imagewithcircles = uint8(eyeimage);                                          %imshow(imagewithcircles);title('image with circles');

%get pixel coords for circle around iris
[x,y] = circlecordinates([circleiris(2),circleiris(1)],circleiris(3),size(eyeimage));  % display(x);display(y);
ind2  = sub2ind(size(eyeimage),double(y),double(x)); 

%get pixel coords for circle around pupil
[xp,yp] = circlecordinates([circlepupil(2),circlepupil(1)],circlepupil(3),size(eyeimage));
ind1    = sub2ind(size(eyeimage),double(yp),double(xp));

% Write noise regions
imagewithnoise2(ind2) = 255;
imagewithnoise2(ind1) = 255;

% Write circles overlayed
imagewithcircles(ind2) = 255;
imagewithcircles(ind1) = 255;
w = cd;
cd(DIAGPATH);
imwrite(imagewithnoise2,[eyeimage_filename,'-noise.jpg'],'jpg');
imwrite(imagewithcircles,[eyeimage_filename,'-segmented.jpg'],'jpg');
segmentediris=imagewithcircles;
cd(w);

% perform normalisation
%normalisation parameters; with these settings a 9600 bit iris template is created

radial_res = 20;                                                            % take 20 points on each line
angular_res = 240;                                                          % take 240 radial lines along the circle

[polar_array, noise_array] = normaliseiris(imagewithnoise, circleiris(2),...
    circleiris(1), circleiris(3), circlepupil(2), circlepupil(1), circlepupil(3),eyeimage_filename, radial_res, angular_res);
%imshow(polar_array);title('normalized image');
% WRITE NORMALISED PATTERN, AND NOISE PATTERN
w = cd;
cd(DIAGPATH);
imwrite(polar_array,[eyeimage_filename,'-polar.jpg'],'jpg');
imwrite(noise_array,[eyeimage_filename,'-polarnoise.jpg'],'jpg');
cd(w);

% perform feature encoding with the following feature encoding parameters
sigmaOnf = 0.5;       minWaveLength = 18;
nscales = 1;          mult = 1;                                             % not applicable if using nscales = 1
[template, mask] = encode(polar_array, noise_array, nscales, minWaveLength, mult, sigmaOnf); 
%figure;imshow(template);title('template'); figure;imshow(mask);title('mask');