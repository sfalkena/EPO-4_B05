clear all
KITTStartX = 300;
KITTStartY = 300;
KITTStartOrientation = 90;
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
e = 0.001;
for i=1:999999
    KITTx(i) = r*cos(-e*(i-1)+KITTStartOrientation+pi)+KITTStartX +r*cos(KITTStartOrientation);
    KITTy(i) = r*sin(-e*(i-1)+KITTStartOrientation+pi)+KITTStartY +r*sin(KITTStartOrientation);
    if (i>1)
        KITTdeltaX = (KITTx(i)-KITTx(i-1));
        KITTdeltaY = (KITTy(i)-KITTy(i-1));
        KITTtangent = KITTdeltaY/KITTdeltaX;
        toTargetX = (Px(1)-KITTx(i));
        toTargetY = (Py(1)-KITTy(i));
        targetTangent = toTargetY / toTargetX;
        if (abs(targetTangent - KITTtangent)<e) && (abs((KITTx(i)-Px(1)))<abs(KITTx(i-1)-Px(1)))
            break
        end
    end
end
plot(KITTx, KITTy)
lineX = [KITTx(end)-400, KITTx(end), KITTx(end)+400];
lineY = [KITTy(end)-400*KITTtangent, KITTy(end), KITTy(end)+400*KITTtangent];
plot(lineX, lineY)


%TODO: decide whether to go right or left turn

