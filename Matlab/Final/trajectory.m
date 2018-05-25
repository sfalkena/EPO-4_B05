clear all
KITTStartX = 50;
KITTStartY = 50;
KITTStartOrientation = 0;
KITTStartOrientation = deg2rad(KITTStartOrientation);

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
scatter(KITTStartX,KITTStartY,'g')

%plot turning radius
r = 87.5;
for i=1:100
    KITTx(i) = r*cos(-0.1*(i-1)+KITTStartOrientation+pi)+KITTStartX +r*cos(KITTStartOrientation);
    KITTy(i) = r*sin(-0.1*(i-1)+KITTStartOrientation+pi)+KITTStartY +r*sin(KITTStartOrientation);
    if (i>1)
        KITTtangent = (KITTy(i)-KITTy(i-1))/(KITTx(i)-KITTx(i-1));
        toTargetX = (Px(1)-KITTx(i));
        toTargetY = (Py(1)-KITTy(i));
        targetTangent = toTargetY / toTargetX;
        if (abs(targetTangent - KITTtangent)<0.1)
            break
        end
    end
end
plot(KITTx, KITTy)
lineX = [KITTx(end), KITTx(end)+100];
lineY = [KITTy(end), KITTy(end)+100*KITTtangent];
plot(lineX, lineY)


%TODO: shift turning radius to let it start at a certain starting position
%and calculate with every iteration if the tangent gets close to the target
%position. if it does, stop the loop and plot the line to the target.

