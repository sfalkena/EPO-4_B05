clear all
load('audiodata_B5.mat');         %Load data
ref = RXXr(3,:,5);                %Load reference data
ref = ref(2195:18196); %For B5
% ref = ref(662:5460); %For B5_1

Fs=48000;
RepFr = 3; %Repetition frequency
t=linspace(0,(length(RXXr(1,:,1))/Fs),length(RXXr(1,:,1)));

u = 9; %measurement (a=6,b=7,c=8,m=9)

%Plot time energy signal
figure('units','normalized','outerposition',[0 0 1 1]) ;
for i = 1:5
    a(i)=subplot(5, 1, mod(i-1, 5)+1) ;
    plot(t,RXXr(u,:,i).^2);   hold on
    %find which microphone has first significant peaks.
    [pk,loc]=findpeaks(RXXr(u,:,i).^2,Fs,'Threshold',0.1e-4);
    pks(i,:) = loc(1); 
    xlabel('Time[s]');
    ylabel('Energy');
    title (['Time/energy signal of p ',num2str(u),', mic',num2str(i)])
    %calculate impulse responses
    h(:,i) = ch2(ref,RXXr(u,:,i)).^2;
end
linkaxes(a, 'x'); %make sure all plots zoom together

%plot full impulse responses
figure('units','normalized','outerposition',[0 0 1 1]) ;
for i = 1:5
    b(i)=subplot(5, 1, mod(i-1, 5)+1) ;
    plot(h(:,i));
    title (['Impulse response h',num2str(i)])
    xlabel('Samples');
    ylabel('Energy');
end
linkaxes(b, 'x');

%trim signals and plot trimmed time signals
% figure('units','normalized','outerposition',[0 0 1 1]) ;
% offset = 100; %amount of samples before first peak
% clear h; %h is rebuild, otherwise Matlab gives errors
% for i = 1:5
%    trim(:,i) = RXXr(m,((min(pks)*Fs-offset):((1/RepFr*Fs))),i);
%    t=linspace(0,(length(trim(:,i))/Fs),length(trim(:,i)));
%    c(i)=subplot(5, 1, mod(i-1, 5)+1) ;
%    plot(t,trim(:,i).^2);
%    xlabel('Time[s]');
%    ylabel('Energy');
%    title (['Trimmed time signal for mic',num2str(i)]) 
%    %calculate impulse responses
%    h(:,i) = ch2(ref,trim(:,i)).^2;
% end
% linkaxes(c, 'x');

%plot trimmed impulse responses
% figure('units','normalized','outerposition',[0 0 1 1]) ;
% for i = 1:5
%     d(i)=subplot(5, 1, mod(i-1, 5)+1) ;
%     plot(h(:,i));
%     title (['Trimmed impulse response h',num2str(i)])
%     xlabel('Samples');
%     ylabel('Energy');
% end
% linkaxes(d, 'x');

r12 = TDOA(h(:,1),h(:,2),'r12');        %Relative distance from mic1
r13 = TDOA(h(:,1),h(:,3),'r13');
r14 = TDOA(h(:,1),h(:,4),'r14');
r23 = TDOA(h(:,2),h(:,3),'r23');
r24 = TDOA(h(:,2),h(:,4),'r24');
r34 = TDOA(h(:,3),h(:,4),'r34');
% r15 = TDOA(h(1),h(5),'r15');
% r25 = TDOA(h(2),h(5),'r25');
% r35 = TDOA(h(3),h(5),'r35');
% r45 = TDOA(h(4),h(5),'r45');

[x_cor,y_cor] = localization(r12,r13,r14,r23,r24,r34)
run loc4mic_2d