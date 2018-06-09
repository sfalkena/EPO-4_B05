clear all
load('audiodata_B5.mat');         %Load data
ref = RXXr(3,:,5);                %Load reference data
ref = ref(2195:18196); %For B5
% ref = ref(662:5460); %For B5_1

Fs=48000;
RepFr = 3; %Repetition frequency
t=linspace(0,(length(RXXr(1,:,1))/Fs),length(RXXr(1,:,1)));

m=6; %measurement a

%Plot time energy signal
figure('units','normalized','outerposition',[0 0 1 1]) ;
for i = 1:5
    a(i)=subplot(5, 1, mod(i-1, 5)+1) ;
    plot(t,RXXr(m,:,i).^2);   hold on
    %find which microphone has first significant peaks.
    [pk,loc]=findpeaks(RXXr(m,:,i).^2,Fs,'Threshold',0.1e-4);
    pks(i,:) = loc(1); 
    xlabel('Time[s]');
    ylabel('Energy');
    title (['Time/energy signal of pA, mic',num2str(i)])
    %calculate impulse responses
    h(:,i) = ch2(ref,RXXr(m,:,i)).^2;
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
figure('units','normalized','outerposition',[0 0 1 1]) ;
offset = 100; %amount of samples before first peak
clear h; %h is rebuild, otherwise Matlab gives errors
for i = 1:5
   trim(:,i) = RXXr(m,((min(pks)*Fs-offset):((1/RepFr*Fs))),i);
   t=linspace(0,(length(trim(:,i))/Fs),length(trim(:,i)));
   c(i)=subplot(5, 1, mod(i-1, 5)+1) ;
   plot(t,trim(:,i).^2);
   xlabel('Time[s]');
   ylabel('Energy');
   title (['Trimmed time signal for mic',num2str(i)]) 
   %calculate impulse responses
   h(:,i) = ch2(ref,trim(:,i)).^2;
end
linkaxes(c, 'x');

%plot trimmed impulse responses
figure('units','normalized','outerposition',[0 0 1 1]) ;
for i = 1:5
    d(i)=subplot(5, 1, mod(i-1, 5)+1) ;
    plot(h(:,i));
    title (['Trimmed impulse response h',num2str(i)])
    xlabel('Samples');
    ylabel('Energy');
end
linkaxes(d, 'x');