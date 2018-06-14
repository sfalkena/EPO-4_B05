% Code written by:
% - Sander Delfos : 4317262
% - Sieger Falkena: 4293681

function afstand = TDOA(h1,h2,p)
Ts=900;
% M1=max(h1);
M1=max(h1(Ts+1:end-Ts-1));
F1=find(h1==M1);
h11=h1(F1-Ts:F1+Ts);
h22=h2(F1-Ts:F1+Ts);

M2=max(h22);
F2=find(h22==M2);
M22=max(h22(1:Ts-10));
F22=find(h22==M22);
if (2*M22 > M2)
    F2 = F22;
    M2 = M22;
end


M1=max(h11);
F1=find(h11==M1);
M11=max(h11(1:Ts-100));
F11=find(h11==M11);
if (2*M11 > M1)
    F1 = F11;
    M1 = M11;
end


Diff=F1-F2; %Aantal samples verschil
Tijd=Diff/48000;
afstand=Tijd*34300;

% figure
% plot(h11)
% hold on
% plot(h22)
% scatter(F1,M1);
% scatter(F2(1),M2);
% title({['mic ',num2str(p)];['Distance= ',num2str(afstand),' cm']})
% legend(p(2),p(3),'F2','F1')

end