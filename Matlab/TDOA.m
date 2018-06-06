% Code written by:
% - Sander Delfos : 4317262
% - Sieger Falkena: 4293681

function afstand = TDOA(h1,h2)
h11=h1(700:end-700);
M1=max(h11);
F1=find(h11==M1)+700;
Ts=700;
h22=h2(F1-Ts:F1+Ts);
% figure
% plot(h22)

M2=max(h22);
F2=find(h22==M2);

Diff=abs(F2-Ts); %Aantal samples verschil
Tijd=Diff/44100;
afstand=Tijd*34300;
end