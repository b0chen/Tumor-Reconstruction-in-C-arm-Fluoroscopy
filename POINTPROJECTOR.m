% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 
% POINTPROJECTOR projects a point, given C-arm coordinates P(x,y,z) to the 
% detector at some a imaging angle, resulting in a point in detector 
% coordinates Q(u, v, w=0)
% Input: a imaging angle, P(x,y,z)
% Output: Q(u, v, w=0)
function [newprojection] = POINTPROJECTOR(angle, point)

% convert the imaging angle of rotation into a rotation matrix 
% (around the z axis)
rotationMatrix = [cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1];

% find the C-arm source point after applying the rotation we know the arm 
% starts 75cm above the patient coordinate system
sourcePoint = rotationMatrix * [0; 75; 0] ;

% apply the rotation matrix to the sensorPlane
% we know the sensor plane starts 75cm below the patient coordinate system
sensorPlane = [(rotationMatrix * [0; -75; 0])'; (rotationMatrix * [1; -75; 0])';
    (rotationMatrix * [0; -75; 1])'];

% find the intersection of the projection of the given point and the sensor
% plane using (using line sourcePoint and the given point to create a line)
projection = double(linePlane([sourcePoint'; point], sensorPlane));

%convert the projected point from the patient coordinate system to the
%sensor coordinate system
newprojection = rigid(projection, -sourcePoint, sensorPlane(3,:),rotationMatrix * [0;-74;0], sensorPlane(2,:));

%Please uncomment to see plots
%{ 
figure;
hold on;
title('Point Projector');
xlabel('x-axis');
ylabel('z-axis');
zlabel('y-axis');
plot3([sourcePoint(1),-sourcePoint(1)],[sourcePoint(2),-sourcePoint(2)],[sourcePoint(3),-sourcePoint(3)])% beam source to sensor
plot3([sourcePoint(1),projection(:,1)],[sourcePoint(2),projection(:,2)],[sourcePoint(3),projection(:,3)])% beam source to projected point
plot3 (sourcePoint(1),sourcePoint(2),sourcePoint(3), 'ro') % C-arm source point
plot3 (-sourcePoint(1),-sourcePoint(2),-sourcePoint(3), 'ro') % C-arm sensor point
plot3 (point(:,1),point(:,2),point(:,3), 'g*') % original point
plot3 (projection(:,1),projection(:,2),projection(:,3),'g+') % projected point
%}
end




