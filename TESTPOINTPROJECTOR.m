
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
clear; 
%Ground truth 1
%projected point should be [0,0,0] in the detector coordinat system
%because it is relative to the detector coordinat system
%projected point should be [0,-75,0] in the C-arm coordinat system
POINTPROJECTOR(0, [0,0,0])
pause

clear; 
%Ground truth 2
%projected point should be [0,0,0] in the detector coordinat system
%because it is relative to the detector coordinat system (rotated)
%projected point should be [0,-75,0] in the C-arm coordinat system
POINTPROJECTOR(90, [0,0,0])
pause

clear; 
%Ground truth 3
%See notes for proof
POINTPROJECTOR(0, [1,1,1])
pause

clear; 
%Ground truth 4
%See notes for proof
POINTPROJECTOR(180, [1,1,1])
pause

clear; 
%Ground truth 5
%See notes for proof
POINTPROJECTOR(0, [1, 0 ,2])
 
