%Q1.1 answer
A = [1 7 3; 2 4 1; 4 8 6];
B = [1 1 0.25; 2 4 1; 4 8 2];
C = [0; 0; 0];

disp('Q1.1');
A;
B;
C;

[Ua, Sa, Va] = svd(A);
[Ub, Sb, Vb] = svd(B);

%Q1.2 answer:
disp('Q1.2');
SVa = Sa(3,3);
print = sprintf('Minimum singular value of A is %s. Rank = 3.\n As there all the singular values does not have zero values, A is full rank.',SVa);
disp(print);
SVb = Sb(2,2);
print = sprintf('Minimum singular value of B is %s. Rank = 2.\n The rank of B means there are 1 of the singular values = 0',SVb);
disp(print);

%Q1.3 answer
disp('Q1.3');
print = sprintf('Ax = C ---- x = 0\n As A is full rank, Ax=0. So x=0');
disp(print);
Vbt = transpose(Vb);
x = Vbt(3,:);
disp('Bx = C ---- x = alpha *');
x;

%Q1.4 answer
disp('Q1.4');
disp('Matrix F cannot be of rank 4. Maximum number of singular value is 3 and not 4.');
F = [5 -4 0; 1 3 2; 4 2 3; -1 7 2];
Fx = [1;2;3;4];
%Using Matlab method
x = mldivide(F,Fx);
x;
%Using Calculation method
Ft = transpose(F);
x = inv(Ft*F) * Ft * Fx;
x;

E = [5 -4 0; 1 3 2; 4 3 3; -1 7 2];
Ex = [1;2;3;4];
%Using Matlab method
x = E\Ex;
x;
%Using Calculation method
Et = transpose(E);
x = inv(Et*E) * Et *Ex;
x;

%Q2 answer
A = randi(100,3);
A;
e = eig(A);
disp('eigenvectors & eigenvalues:');
e;
[V,D] = eig(A);
[V,D,W] = eig(A);
V;
D;
W;







