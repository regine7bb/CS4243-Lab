%Qns 1-----------------------------------------------------------------
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


%Qns 2----------------------------------------------------------------
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


%Qns 3-----------------------------------------------------------------
%Roll, pitch and yaw representation for rotation
r=0;    %roll
p=0;    %pitch
y=0;    %yaw

degree = 0;
rpymat_i = zeros(3,3,4);

%using Eular angle to convert to rotation matrix 
%R=RzRyRx formula
%Axis of rotation is Y-axis
for i = 1:4
   rpymat_i(:,:,i) = [
       cos(r)*cos(y)    cos(r)*sin(y)*sin(p)-sin(r)*cos(p)      cos(r)*sin(y)*cos(p)+sin(r)*sin(p),
       sin(r)*cos(y)    sin(r)*sin(y)*sin(p)+cos(r)*cos(p)      sin(r)*sin(y)*cos(p)-cos(r)*sin(p),
       -sin(y)          cos(y)*sin(p)                           cos(y)*cos(p)
       ];
    degree = degree + pi/6;
    y = degree;
end
rpymat_1 = rpymat_i(:,:,1);
rpymat_2 = rpymat_i(:,:,2);
rpymat_3 = rpymat_i(:,:,3);
rpymat_4 = rpymat_i(:,:,4);
disp('using roll, pitch and yaw representation for rotation, the computed matrices are : ');
rpymat_1
rpymat_2
rpymat_3
rpymat_4

%Quaternion representation
%q=(cos(degree/2), sin(degree/2)Wx, sin(degree/2)Wy, sin(degree/2)Wz)
W = [0 1 0]; %x=0, y=1, z=0 as only y rotates
degree = 0;
quatmat_i = zeros(3,3,4);
for i = 1:4
    q = [cos(degree/2),sin(degree/2)*W(1),sin(degree/2)*W(2),sin(degree/2)*W(3)];
    %The equivalent roation matrix is:
    quatmat_i(:,:,i) = [
        q(1).^2+q(2).^2-q(3).^2-q(4).^2     2*(q(2)*q(3)-q(1)*q(4))             2*(q(2)*q(4)+q(1)*q(3)),
        2*(q(2)*q(3)+q(1)*q(4))             q(1).^2-q(2).^2+q(3).^2-q(4).^2     2*(q(3)*q(4)-q(1)*q(2)),
        2*(q(2)*q(4)-q(1)*q(3))             2*(q(3)*q(4)+q(1)*q(2))             q(1).^2-q(2).^2-q(3).^2+q(4).^2
        ];
    degree = degree + pi/6;
end
quatmat_1 = quatmat_i(:,:,1);
quatmat_2 = quatmat_i(:,:,2);
quatmat_3 = quatmat_i(:,:,3);
quatmat_4 = quatmat_i(:,:,4);
disp('using quaternion representation for rotation, the computed matrices are : ');
quatmat_1
quatmat_2
quatmat_3
quatmat_4
disp('verify that rpymat_i = quatmat_i : ');
rpymat_i - quatmat_i


%Qns 4-------------------------------------------------------------------
%Projection models for orthographic and perspective
%Declare the various parameters
u0 = 0;
v0 = 0;
Bu = 1;
Bv = 1;
ku = 1;  
kv = 1; 
foal_len = 1;
nframes = 4; % number of frames
npts = size(pts,1); % number of 3D points
U = zeros(nframes, npts); % array holding the image coordinates (horizontal)
V = zeros(nframes, npts); % array holding the image coordinates (vertical)

% orthographic projection
for i = 1:4
    for j = 1:8
        Sp = pts(j,:); 
        tf = cam_pos(i,:);
        %Sp-tf = (sp-tf)^T : has already transpose
        If = quatmat_i (1,:,i);
        Jf = quatmat_i (2,:,i);
        U(i,j) = (Sp-tf)*If.'*Bu +u0;
        V(i,j) = (Sp-tf)*Jf.'*Bv +v0;
    end
end
fig=figure;
for fr = 1 : nframes
    subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*');
    for p = 1 : npts
        text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p));
    end
end
figName = 'orthographic.jpeg';
print(fig, '-djpeg',figName);

% perspective projection
for i = 1:4
    for j = 1:8
         kf = quatmat_i(3,:,i);
         Sp = pts(j,:); 
         tf = cam_pos(i,:);
        %Sp-tf = (sp-tf)^T : has already transpose
         If = quatmat_i (1,:,i);
         Jf = quatmat_i (2,:,i);
        U(i,j) = ( foal_len*(Sp-tf)*If.' )/ ( (Sp-tf)*kf.' ) *Bu + u0;
        V(i,j) = ( foal_len*(Sp-tf)*Jf.' )/( (Sp-tf)*kf.' ) *Bv + v0;
    end
end
fig=figure;
for fr = 1 : nframes
    subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*');
    for p = 1 : npts
        text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p));
    end
end
figName = 'perspective.jpeg';
print(fig, '-djpeg',figName);


%Qns 5---------------------------------------------------------------------
Hf = zeros(3,3);
mat = zeros(9,9);

%using eqn from L9 pg 51
for i = 1:4
    up = pts(i,1);
    uc = U(3,i);
    vp = pts(i,2);
    vc = V(3,i);
    mat(2*i-1,:) =  [up  vp  1   0   0    0  -uc*up  -uc*vp  -uc];
    mat(2*i,:) =    [0   0   0   up  vp   1  -vc*up  -vc*vp  -vc];
end

[Ua,Sa,Va] = svd(mat);
H = Va(:,9);
Hnorm = (1/H(9))*H;
Hf(1,:) = Hnorm(1:3);
Hf(2,:) = Hnorm(4:6);
Hf(3,:) = Hnorm(7:9);

Hf
