clear KITTx KITTy
KITTStartX = 300;
KITTStartY = 300;
KITTStartOrientation = 270;
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
angleToTarget = atand((KITTStartX-Px(1))/(KITTStartY-Py(1)))+90-rad2deg(KITTStartOrientation);
r = 70.05;
e = 0.0001;

%negative = left
if (angleToTarget > 0)
    steeringDirection = -1;
    if (angleToTarget > 180)
        steeringDirection = -steeringDirection;
    end
elseif (angleToTarget < 0)
    steeringDirection = 1;
    if (angleToTarget < -180)
        steeringDirection = -steeringDirection;
    end
else
    steeringDirection = 0;
end

L=0;
for i=1:999999999
    KITTx(i) = steeringDirection*r*cos(-steeringDirection*e*(i-1)+KITTStartOrientation+pi)+KITTStartX +steeringDirection*r*cos(KITTStartOrientation);
    KITTy(i) = steeringDirection*r*sin(-steeringDirection*e*(i-1)+KITTStartOrientation+pi)+KITTStartY +steeringDirection*r*sin(KITTStartOrientation);
    if (i>1)
        KITTdeltaX = (KITTx(i)-KITTx(i-1));
        KITTdeltaY = (KITTy(i)-KITTy(i-1));
        KITTtangent = KITTdeltaY/KITTdeltaX;
        L = L + sqrt(KITTdeltaX^2 + KITTdeltaY^2);
        toTargetX = (Px(1)-KITTx(i));
        toTargetY = (Py(1)-KITTy(i));
        targetTangent = toTargetY / toTargetX;
        if (abs(targetTangent - KITTtangent)<e*20) && (abs((KITTx(i)-Px(1)))<abs(KITTx(i-1)-Px(1)))
            break
        end
    end
end
lineX = [KITTx(end)-400, KITTx(end), KITTx(end)+400];
lineY = [KITTy(end)-400*KITTtangent, KITTy(end), KITTy(end)+400*KITTtangent];
plot(lineX, lineY)

lineToTargetx = linspace(KITTx(end), Px(1), 1000);
lineToTargety = linspace(KITTy(end), Py(1), 1000);
KITTx = [KITTx lineToTargetx];
KITTy = [KITTy lineToTargety];
plot(KITTx, KITTy)

% if (steeringDirection == 1)
%     EPOCommunications('transmit','D100')
% elseif (steeringDirection == -1)
%     EPOCommunications('transmit','D200')
% end
% EPOCommunications('transmit','M158')
% pause(1)
% EPOCommunications('transmit','M157')
% pause((17.6*L/(2*r*pi))-1)
% EPOCommunications('transmit','M150')
% EPOCommunications('transmit','D150')









%TODO: decide whether to go right or left turn

