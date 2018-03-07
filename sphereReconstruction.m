function [g, approxRadius, avgDistance, errors] = sphereReconstruction(center, radius, numberOfPoints, offset)
	
	xmin = -offset;
	xmax = offset;
	rvals = [];
	elevation = [];
	azimuth = [];
	finalR = [];
	
	for i = 1:numberOfPoints
		temp = 2*rand(1,1)-1;
		rvals = vertcat(rvals, temp);
		elevation = vertcat(elevation, asin(temp)); %for full circle
		%elevation = vertcat(elevation, acos(temp));	
		azimuth = vertcat(azimuth, 2*pi*rand(1,1));
		finalR = vertcat(finalR, radius + unifrnd(xmin, xmax));
	end
	
	[x,y,z] = sph2cart(azimuth, elevation, finalR);
	figure;
	B = bsxfun(@plus,[x,y,z],center);
	plot3(B(:,1)',B(:,2)',B(:,3)','r.');
	axis equal;
	hold on;

	%now for reconstruction

	dataset = [B(:,1)';B(:,2)';B(:,3)'];
	% A = -2*x' of 1's. x' is the transpose of set.
	A = [(-2).*dataset', ones(numberOfPoints,1)];
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
	for j = 1:length(dataset)
		tempx = dataset(:,j);
		%calculates error from approximated squares
		e2 = e2 + (norm(tempx-g) - approxRadius)^2;
	end
	errors = sqrt(e2/100);
	
	avgDistance = sum(errors)/(length(errors));
	
	[x, y, z] = sphere;
	xx = x * approxRadius + g(1);
	yy = y * approxRadius + g(2);
	zz = z * approxRadius + g(3);
	surface(xx, yy, zz, 'FaceAlpha', 0.5);
end
		