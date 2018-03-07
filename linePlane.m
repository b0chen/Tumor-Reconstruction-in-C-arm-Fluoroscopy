function point = linePlane(line, matrix)
realdot = @(u, v) u*transpose(v);
normal = cross(matrix(1,:) - matrix(2,:), matrix(1,:) - matrix(3,:));
syms x y z;
P = [x,y,z];
planefunction = realdot(P - matrix(1,:), normal);

syms t;
line = line(1,:) + t*(line(2,:) - line(1,:));
newfunction = subs(planefunction, P, line);
t0 = solve(newfunction);
point = subs(line, t, t0);
subs(planefunction, P, point);