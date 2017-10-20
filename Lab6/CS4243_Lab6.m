%Qns 1
pts = zeros(8,3);
pts(1,:) = [-1 -1 -1];
pts(2,:) = [1 -1 -1];
pts(3,:) = [1 1 -1];
pts(4,:) = [-1 1 -1];
pts(5,:) = [-1 -1 1];
pts(6,:) = [1 -1 1];
pts(7,:) = [1 1 1];
pts(8,:) = [-1 1 1];
disp(pts);

%Qns 2
cam_pos = zeros(4, 3);
%q0
cam_pos(1,:) = [0 0 -5];

%use quaternion multiplication to rotate the first position to obtain the
%position for frams 2, 3, 4. 

%store the results in the array cam_pos.
%Then use the following statements to print out the resultant positions
%Formula of new position of the camera p'=qpq*
%since it is respect to y-axis, Wx=0, Wz=0, Wy=1
%-------------location 1
disp('camera location 1');
disp(cam_pos(1,:));

%-------------location 2
p = [0 0 0 -5];
q = [cos(-pi/12) 0 sin(-pi/12) 0];
%q*
qs = [cos(-pi/12) 0 -sin(-pi/12) 0];
qp = quatmult(q,p);
qpqs = quatmult(qp,qs);
%disp(qpqs);
cam_pos(2,:) = [qpqs(2) qpqs(3) qpqs(4)];
disp('camera location 2');
disp(cam_pos(2,:));

%--------------location 3
p = [0 0 0 -5];
q = [cos(-pi/6) 0 sin(-pi/6) 0];
%q*
qs = [cos(-pi/6) 0 -sin(-pi/6) 0];
qp = quatmult(q,p);
qpqs = quatmult(qp,qs);
%disp(qpqs);
cam_pos(3,:) = [qpqs(2) qpqs(3) qpqs(4)];
disp('camera location 3');
disp(cam_pos(3,:));

%--------------location 4
p = [0 0 0 -5];
q = [cos(-pi/4) 0 sin(-pi/4) 0];
%q*
qs = [cos(-pi/4) 0 -sin(-pi/4) 0];
qp = quatmult(q,p);
qpqs = quatmult(qp,qs);
%disp(qpqs);
cam_pos(4,:) = [qpqs(2) qpqs(3) qpqs(4)];
disp('camera location 4');
disp(cam_pos(4,:));

