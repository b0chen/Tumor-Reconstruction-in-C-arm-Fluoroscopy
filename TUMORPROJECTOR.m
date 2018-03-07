% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 

function [ boundryPoints ] = TUMORPROJECTOR( angle, points )
% TUMORPROJECT generates a silhouette of a closed convex tumor object on 
% the detector at some C-arm imaging angle
% Input: imaging angle, array of tumor points in C-arm coordinate system (x,y,z)
% Output: tumor contour as array of points in detector coordinate system (u, v, w=0)

newPoints = [];
% runs POINTPROJECTOR for each set of points and the given angle and 
% vertically concatinates them into newPoints
for row=1:size(points)
    newPoints(row,:)  = POINTPROJECTOR(angle, points(row,:));
end

x = newPoints(:,1);
y = newPoints(:,2);
% uses built in fucntion boundary() to generate the silhouette of the 
% closed convex tumor object 
k = boundary(x,y,.1);

[n,m] = size(k);
% returns only the boundary points (x, y, 0)
boundryPoints = [x(k) y(k) zeros(n,1) ];

%Please uncomment to see plots
%{
figure
hold on;
title('Tumor Projector');
xlabel('x-axis');
ylabel('z-axis');
zlabel('y-axis');
plot(x(k),y(k));
plot3(newPoints(:,1),newPoints(:,2),newPoints(:,3),'.')
%}
end 
