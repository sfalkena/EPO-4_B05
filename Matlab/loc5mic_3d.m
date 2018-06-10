%Simulation of localisation (Appendix C)

x = [200 360 24]';                                          % (unknown) location of the car
m = [460 0 24; 0 0 24; 0 460 24; 460 460 24; 230 460 54]';     % (known) locations of the mics
for i = 1:5
    d(i) = sqrt((x(1)-m(1,i))^2 + (x(2)-m(2,i))^2 + (x(3)-m(3,i))^2);
    mabs(i) = m(1,i)^2 + m(2,i)^2 + m(3,i)^2;
end
r12 = d(1)-d(2);
r13 = d(1)-d(3);
r14 = d(1)-d(4);
r15 = d(1)-d(5);
r23 = d(2)-d(3);
r24 = d(2)-d(4);
r25 = d(2)-d(5);
r34 = d(3)-d(4);
r35 = d(3)-d(5);
r45 = d(4)-d(5);

%Generate matrix A
clear A;
A(1,:) = 2*(m(:,2)-m(:,1))';
A(2,:) = 2*(m(:,3)-m(:,1))';
A(3,:) = 2*(m(:,4)-m(:,1))';
A(4,:) = 2*(m(:,5)-m(:,1))';
A(5,:) = 2*(m(:,3)-m(:,2))';
A(6,:) = 2*(m(:,4)-m(:,2))';
A(7,:) = 2*(m(:,5)-m(:,2))';
A(8,:) = 2*(m(:,4)-m(:,3))';
A(9,:) = 2*(m(:,5)-m(:,3))';
A(10,:) = 2*(m(:,5)-m(:,4))';
A(1,4) = -2*r12;
A(2,5) = -2*r13;
A(3,6) = -2*r14;
A(4,7) = -2*r15;
A(5,5) = -2*r23;
A(6,6) = -2*r24;
A(7,7) = -2*r25;
A(8,6) = -2*r34;
A(9,7) = -2*r35;
A(10,7) = -2*r45;

%Generate matrix b
clear b;
b(1) = r12^2 - mabs(1) + mabs(2);
b(2) = r13^2 - mabs(1) + mabs(3);
b(3) = r14^2 - mabs(1) + mabs(4);
b(4) = r15^2 - mabs(1) + mabs(5);
b(5) = r23^2 - mabs(2) + mabs(3);
b(6) = r24^2 - mabs(2) + mabs(4);
b(7) = r25^2 - mabs(2) + mabs(5);
b(8) = r34^2 - mabs(3) + mabs(4);
b(9) = r35^2 - mabs(3) + mabs(5);
b(10) = r45^2 - mabs(4) + mabs(5);
b = b';

%Determine location of the car through matrix operations
A_T = transpose(A);
C = A_T*A;
C = inv(C);
C = C*A_T;
y = C*b;
disp('Location of car:')
y(1),y(2),y(3)
