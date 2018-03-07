% Bo Chen
% 10190141
% 14bc57
 
% CISC 330
% October 23, 2017 
% Assignment 2: Tumor Reconstruction in C-arm Fluoroscopy 

function [approxRadius] = SUPERSPHERE( angles, silhouettes )
% SUPERSPHERE Develops a module that computes super-sphere which is the 
% smallest sphere that centered in the in the center of the C-arm coordinate 
% system and completely encompasses tumor object to be reconstructed.
% Input: vector of imaging angles, array of tumor silhouettes in detector 
% coordinate system (u,v,w=0)
% Output: radius of the super-sphere (Rs)

%initate 
[n,m] = size(angles);
[q,w] = size(silhouettes);
newTemp = [];
newPoints=[];
hold on;

%for loop
for i=1:m
        rotationMatrix =  [1 0 0; 0 cosd(angles(i)) sind(angles(i)) ;0 -sind(angles(i)) cosd(angles(i))];
        for k=1:q
           newTemp = vertcat(newTemp, (rotationMatrix * silhouettes(k,:)')');
        end
        newPoints  = vertcat(newPoints, newTemp)
end

%sphere fit
dataset = [newPoints(:,1)';newPoints(:,2)';newPoints(:,3)'];
	% A = -2*x' of 1's. x' is the transpose of set.
	A = [(-2).*dataset', ones(length(dataset),1)];
	b = [];
	for i = 1:length(dataset)
		% b = negative of the transpose of data multiplied by the data
		b = vertcat(b, (-1).*((dataset(:,i))'*(dataset(:,i))));
	end
	% The sphere equation is now of the form -2x'*g + g'*g - p^2 = -x'*x
	% Performs QR decomposition. Gets a tall thin matrix
	[Q,R] = qr(A,0);
	% solves Rx = Q'b using back substitution. Solves for an approximation
	% of x. This gives [gx, gy, gz, sigma] where [gx, gy, gz] = g. 
	% 'g' is the approximated center and sigma = g'*g-r, where r
	% is the approximated radius of sphere.
	approx = backsub(R,Q'*b);
	
	
	% test it the circles with the formula x'*x - 2x'*g + sigma = 0
	% this will determine our error. Then use it for root mean square error

	e2 = 0;
	%gets sigma
	sigma = approx(length(approx));
	%gets the g vec
	g = approx(1:length(approx)-1,1);
	%gets the approximated radius
	approxRadius = sqrt(dot(g,g)-sigma);




%plot
%
%{
hold on;
title('Super Sphere');
xlabel('x-axis');
ylabel('z-axis');
zlabel('y-axis');
plot3(newPoints(:,1),newPoints(:,2),newPoints(:,3),'r') 
[x, y, z] = sphere;
xx = x * approxRadius + g(1);
yy = y * approxRadius + g(2);
zz = z * approxRadius + g(3);
surface(xx, yy, zz, 'FaceAlpha', 0.1);
%}
end
