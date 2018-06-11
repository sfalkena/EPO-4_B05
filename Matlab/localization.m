%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulation of localisation (Appendix C)
function [x_cor,y_cor] = localization(r12,r13,r14,r23,r24,r34) 

mic_h = 24;
mic5_h = 80;
m = [460 0 mic_h; 0 0 mic_h; 0 460 mic_h; 460 460 mic_h; 230 460 mic5_h]';          %locations of the mics
for i = 1:5
    mabs(i) = m(1,i)^2 + m(2,i)^2 + m(3,i)^2;
end

%Generate matrix A
clear A;
A(1,:) = 2*(m(:,2)-m(:,1))';
A(2,:) = 2*(m(:,3)-m(:,1))';
A(3,:) = 2*(m(:,4)-m(:,1))';
A(4,:) = 2*(m(:,3)-m(:,2))';
A(5,:) = 2*(m(:,4)-m(:,2))';
A(6,:) = 2*(m(:,4)-m(:,3))';
A(1,3) = -2*r12;
A(2,4) = -2*r13;
A(3,5) = -2*r14;
A(4,4) = -2*r23;
A(5,5) = -2*r24;
A(6,5) = -2*r34;

%Generate matrix b
clear b;
b(1) = r12^2 - mabs(1) + mabs(2);
b(2) = r13^2 - mabs(1) + mabs(3);
b(3) = r14^2 - mabs(1) + mabs(4);
b(4) = r23^2 - mabs(2) + mabs(3);
b(5) = r24^2 - mabs(2) + mabs(4);
b(6) = r34^2 - mabs(3) + mabs(4);

b = b';

y=inv(A'*A)*A'*b;

x_cor = y(1);                       %x_coordinate car
y_cor = y(2);                       %y_coordinate car

end