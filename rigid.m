function Q = rigid(newPoint, dcor, e1, e2, e3)
% newPoint = [0 -75 0];
% dcor = [0 -75 0];
% e1 = [1 1 1];
% e2 = [0 1 0];
% e3 = cross(e1, e2);

	transMat = [[1 0 0 -dcor(1)]; [0 1 0 -dcor(2)];...
			[0 0 1 -dcor(3)];[0 0 0 1]];
	newPoint = transMat * [newPoint 1]';
	newPoint = newPoint(1:3);
	Q = newPoint;

	v1 = [1 0 0]';
	v2 = [0 1 0]';
	v3 = [0 0 1]';
	rotationM = [[dot(e1, v1) dot(e1, v2) dot(e1, v3) 0];...
		[dot(e2, v1) dot(e2, v2) dot(e2, v3) 0];...
		[dot(e3, v1) dot(e3, v2) dot(e3, v3) 0];...
		[0 0 0 1]];
	
	newPoint =	rotationM * [newPoint; 1];
	newPoint = newPoint(1:3);
	Q = [newPoint(1), newPoint(3), newPoint(2)];
%end
