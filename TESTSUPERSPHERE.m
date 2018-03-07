% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 

% SUPERSPHERE Develops a module that computes super-sphere which is the 
% smallest sphere that centered in the in the center of the C-arm coordinate 
% system and completely encompasses tumor object to be reconstructed.
% Input: vector of imaging angles, array of tumor silhouettes in detector 
% coordinate system (u,v,w=0)
% Output: radius of the super-sphere (Rs)
clear; 
angles = [0,90];
boundryPoints = [];


%Tumor projector with random sphere with radius of 3
theta = 2 * pi * rand(100, 1);  
phi = asin(2 * rand(100, 1) - 1);  
d = 3 * (rand(100, 1) .^ (1/3));  
[x, y, z] = sph2cart(theta, phi, d);

for i=1:length(angles) %runs TUMORPROJECTOR with all angles (0 and 90)
    boundryPoints = vertcat(boundryPoints, TUMORPROJECTOR( angles(i), [x, y, z]));
end
approxRadius = SUPERSPHERE( angles, boundryPoints);


clear; 
angles = [0,90];
boundryPoints = [];
%Tumor projector with random elipsoide with a=1, b=2, c=3 
d = [1,2,3] .^ 2;  
r = max([1,2,3]); 

theta = 2 * pi * rand(100, 1);  
phi = asin(2 * rand(100, 1) - 1);  
d = r * (rand(100, 1) .^ (1/3));  
[x, y, z] = sph2cart(theta, phi, d);

insphere = x.^2/d(1) + y.^2/d(2) + z.^2/d(3) <= 1;  
nredraw = sum(~insphere);  
while nredraw > 0
    
    theta = 2 * pi * rand(nredraw, 1);  
    phi = asin(2 * rand(nredraw, 1) - 1);  
    d = r * (rand(nredraw, 1) .^ (1/3));  
    [xn, yn, zn] = sph2cart(theta, phi, d);
    if size(xn) < 3
        break
    end
    insphere_new = xn.^2/d(1) + yn.^2/d(2) + zn.^2/d(3) <= 1;
    x(~insphere) = xn;
    y(~insphere) = yn;
    z(~insphere) = zn;
    insphere(~insphere) = insphere_new;
    nredraw = sum(~insphere_new);
end

for i=1:length(angles) %runs TUMORPROJECTOR with all angles (0 and 90)
    boundryPoints = vertcat(boundryPoints, TUMORPROJECTOR( angles(i), [x, y, z]));
end

approxRadius = SUPERSPHERE(angles, boundryPoints);


