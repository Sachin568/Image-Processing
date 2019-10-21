function lines=eyelidlines(image,sigma)
edgeimage=edge(image,'canny',0.145,'both',sigma);                           %imshow(edgeimage);hold on;

[H,Tita,Rho] = hough(edgeimage);                                            %plotting hough space for the given image to find lines
figure;imshow(H,[],'Xdata',Tita,'Ydata',Rho,'initialmagnification','fit');   
xlabel('1/tita'),ylabel('1/rho'); axis on,axis normal,hold on;

%k=max(H(:));    display(k);display(H(:));

p = houghpeaks(H,25,'threshold',ceil(0.9*max(H(:))));   
x = Tita(p(:,2));    y = Rho(p(:,1));
plot(x,y,'s','color','yellow');

lines = houghlines(image,Tita,Rho,p,'fillgap',6,'minlength',40);                  
 o1 = lines(1).point1;   display(o1);
 o2 = lines(1).point2;   display(o2);

figure;imshow(image);hold on
maxLen = 0;
for k = 1: length(lines)
    xy = [lines(k).point1; lines(k).point2];                                %display(xy);
    plot(xy(:,1),xy(:,2),'lineWidth',1,'color','white');
    plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','blue');
    len = norm(lines(k).point1 - lines(k).point2);
   if ( len > maxLen)
      maxLen = len;
      xy_long = xy;
   end
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue')
