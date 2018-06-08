% Code written by:
% - Sander Delfos : 4317262
% - Sieger Falkena: 4293681

function afstand = TDOA(h1,h2,p)
M1=max(h1);
F1=find(h1==M1);
Ts=700;
h11=h1(F1(1)-Ts:F1(1)+Ts);
h22=h2(F1(1)-Ts:F1(1)+Ts);
figure
plot(h11)
hold on
plot(h22)
title(p)
legend(p(2),p(3))
scatter(Ts,M1);


M2=max(h22);
F2=find(h22==M2);
scatter(F2(1),M2);

Diff=abs(F2-Ts); %Aantal samples verschil
Tijd=Diff/44100;
afstand=Tijd*34300;
end