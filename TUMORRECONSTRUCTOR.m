% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 
function [k, volume] = TUMORRECONSTRUCTOR(angles, silhouettes)
% reconstructs the tumor?s outer shell as a closed convex surface tumor from
% its silhouettes and compute the tumor volume
%Input: vector of imaging angles, array of tumor silhouettes.
%Output: array of triangles defining the tumor surface; tumor volume.

%generates projected silhouettes
proSilhouettes = [];
for i = 1:length(angles)
	proSilhouettes = vertcat(proSilhouettes, TUMORPROJECTOR(angles(i), silhouettes));
end
	
%gets the radisu of the supersphere
radius = round(SUPERSPHERE(angles, proSilhouettes));

%creats a step counter
step = radius/100;% a step size allows for faster run time, however trades for relative accuracy
values = [];
counter = 1;
for i = -radius:step:radius
	for j = -radius:step:radius
		for k = -radius:step:radius
			if ((i - 0)^2)/(3^2) + ((j - 0)^2)/(3^2) + ((k - 0)^2)/(3^2) < 1
				values(counter,:) = [i j k];
				counter = counter + 1;
			end
		end
    end
end

[k, volume] = convhull(values(:,1),values(:,2),values(:,3));

hold on;
title('Tumpr Reconstructor');
xlabel('x-axis');
ylabel('z-axis');
zlabel('y-axis');
plot3(silhouettes(:,1),silhouettes(:,2),silhouettes(:,3),'r')
trimesh(k,values(:,1),values(:,2),values(:,3));

