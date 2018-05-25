figure
hold on
xlim([-10 470])
ylim([-10 470])
title('Map')
xlabel('x coördinate')
ylabel('y coördinate')
Px=[150 200 400 230];
Py=[150 360 200 230];
Mx=[460 0 0 460 230];
My=[0 0 460 460 460];
scatter(Px,Py,'r','x')
scatter(Mx,My,'b')

%plot turning radius
r = 85.5;
for i=1:100
    KITTx(i) = r*cos(0.1*i);
    KITTy(i) = r*sin(0.1*i);
end
plot(KITTx, KITTy)

%TODO: shift turning radius to let it start at a certain starting position
%and calculate with every iteration if the tangent gets close to the target
%position. if it does, stop the loop and plot the line to the target.

