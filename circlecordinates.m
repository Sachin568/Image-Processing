% circlecordinatess - returns the pixel coordinates of a circle defined by the
%                radius and x, y coordinates of its centre.
%
% Usage: 
% [x,y] = circlecordonatess(c, r, imgsize,nsides)
%
% Arguments:
%	c           - an array containing the centre coordinates of the circle
%	              [x,y]
%   r           - the radius of the circle
%   imgsize     - size of the image array to plot coordinates onto
%   nsides      - the circle is actually approximated by a polygon, this
%                 argument gives the number of sides used in this approximation. Default
%                 is 600.
%
% Output:
%	x		    - an array containing x coordinates of circle boundary
%	              points
%   y		    - an array containing y coordinates of circle boundary
%                 points
%
%   circle equation in polar form
%  p(rad,tita) = p( {sqrt(x^2 + y^2} , invtan(y/x) )
%where, 
%       r = sqrt (x^2 + y^2)
%       tita = invtan (y/x)
%


function [x,y] = circlecordinates(c, r, imgsize,nsides)

    
    if nargin == 3
	nsides = 600;
    end
    
    nsides = round(nsides);
    
    a = [0:pi/nsides:2*pi];
    xd = (double(r)*cos(a)+ double(c(1)) );                                 % x0 + r.cos(tita)
    yd = (double(r)*sin(a)+ double(c(2)) );                                 % y0 + r.sin(tita)
    
    xd = round(xd);
    yd = round(yd);
    
    %get rid of -ves    
    %get rid of values larger than image
    xd2 = xd;
    coords = find(xd>imgsize(2));
    xd2(coords) = imgsize(2);
    coords = find(xd<=0);
    xd2(coords) = 1;
    
    yd2 = yd;
    coords = find(yd>imgsize(1));
    yd2(coords) = imgsize(1);
    coords = find(yd<=0);
    yd2(coords) = 1;
    
    x = int32(xd2);
    y = int32(yd2);   