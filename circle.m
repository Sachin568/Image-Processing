function [row,col,r] = circle(eyeimage,threshold,sigma,scaling,edgethrs,rng)
%[fname, path]=uigetfile('*.*','input an image');
%fname=strcat(path,fname);
%eyeimage=imread(fname);
%scaling=0.8;
%threshold=0.145;
%rr1=[30,80]*scaling;
%edgethrs=0.20;
%rr1=[80,160]*scaling;

rr1 = rng*scaling;                                                             %display(rr1);
eyeimage = imresize(eyeimage,scaling);
%eyeimage = imgaussfilt(eyeimage,sigma);                                       %figure;imshow(eyeimage);      
cannyedge = edge(eyeimage,'canny','both',threshold,sigma);                     %figure;imshow(cannyedge);

%figure;imshow(eyeimage);
[center,rad]=imfindcircles(cannyedge,rr1,'ObjectPolarity','dark','method','twostage','sensitivity',0.9,'EdgeThreshold',edgethrs);%0.45
%[centers1,radii1]=imfindcircles(cannyedge,rr2,'ObjectPolarity','dark','method','twostage','sensitivity',0.9,'EdgeThreshold',0.2);

%viscircles(center,rad,'EdgeColor','w');                      %viscircles(centers1,radii1,'EdgeColor','b');

row=center(2);
col=center(1);
r=rad;
%display([row,col,r]);                                                    %display(radii);display(radii1);display(centers1);