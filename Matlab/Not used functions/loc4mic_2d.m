%Simulation of localisation (Appendix C)
if (u==6)
    x = [150 150 24]';
elseif (u==7)
    x = [200 360 24]';
elseif (u==8)
    x = [400 60 24]';
else
    x = [230 230 24]';
end

% (unknown) location of the car
m = [460 0 24; 0 0 24; 0 460 24; 460 460 24; 230 460 54]';     % (known) locations of the mics
for i = 1:5
    d(i) = sqrt((x(1)-m(1,i))^2 + (x(2)-m(2,i))^2 + (x(3)-m(3,i))^2);
    mabs(i) = m(1,i)^2 + m(2,i)^2 + m(3,i)^2;
end
R12 = d(1)-d(2);
R13 = d(1)-d(3);
R14 = d(1)-d(4);
R23 = d(2)-d(3);
R24 = d(2)-d(4);
R34 = d(3)-d(4);


%Generate matrix A
clear A;
A(1,:) = 2*(m(:,2)-m(:,1))';
A(2,:) = 2*(m(:,3)-m(:,1))';
A(3,:) = 2*(m(:,4)-m(:,1))';
A(4,:) = 2*(m(:,3)-m(:,2))';
A(5,:) = 2*(m(:,4)-m(:,2))';
A(6,:) = 2*(m(:,4)-m(:,3))';
A(1,3) = -2*R12;
A(2,4) = -2*R13;
A(3,5) = -2*R14;
A(4,4) = -2*R23;
A(5,5) = -2*R24;
A(6,5) = -2*R34;

%Generate matrix b
clear b;
b(1) = R12^2 - mabs(1) + mabs(2);
b(2) = R13^2 - mabs(1) + mabs(3);
b(3) = R14^2 - mabs(1) + mabs(4);
b(4) = R23^2 - mabs(2) + mabs(3);
b(5) = R24^2 - mabs(2) + mabs(4);
b(6) = R34^2 - mabs(3) + mabs(4);

b = b';

y=inv(A'*A)*A'*b;

error12 = R12 - r12;
error13 = R13 - r13;
error14 = R14 - r14;
error23 = R23 - r23;
error24 = R24 - r24;
error34 = R34 - r34;
