% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 

% reconstructs the tumor?s outer shell as a closed convex surface tumor from
% its silhouettes and compute the tumor volume
%Input: vector of imaging angles, array of tumor silhouettes.
%Output: array of triangles defining the tumor surface; tumor volume.

clear;  
%Ground Truth Test
clear; 
angles = [0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240,255,270,285,300,315,330,345,360];
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

%Place a ground truth ellipsoidal tumor in (1,1,1) point of the C-arm 
%coordinate system, with principal axes a=1, b=2, c=3. In a full-panoramic 
%(360 degree) span, create synthetic X-ray images using the Tumor Projector 
%module, at every 15 degrees. 
for i=1:length(angles) %runs TUMORPROJECTOR with all angles (0 and 90)
    boundryPoints = vertcat(boundryPoints, TUMORPROJECTOR( angles(i), [x, y, z]));
end


%Reconstruct the tumor gradually
clear; 
angles180 = [0,180,360];
angles90 = [0,90,180,270,360];
angles60 = [0,60,120,180,240,300,360];
angles30 = [0,30,60,90,120,150,180,210,240,270,300,330,360];
angles15 = [0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240,255,270,285,300,315,330,345,360];

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

[k, values, vol, A] = TUMORRECONSTRUCTOR(angles180, [x, y, z]);
[k, values, vol, A] = TUMORRECONSTRUCTOR(angles90, [x, y, z]);
[k, values, vol, A] = TUMORRECONSTRUCTOR(angles60, [x, y, z]);
[k, values, vol, A] = TUMORRECONSTRUCTOR(angles30, [x, y, z]);
[k, values, vol, A] = TUMORRECONSTRUCTOR(angles15, [x, y, z]);
