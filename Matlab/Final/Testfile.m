%Script of EPO-4, projectgroup B-05
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

%This function calculates all channel responses and executes the TDOA and
%localisation measurement. This is also used for debugging and plotting
%purposes.
function [x_cor,y_cor,lowestError] = Testfile(data)
load('audiodata_B5.mat');                                           %Load data
ref = RXXr(3,:,5);                                                  %Load reference data
ref = ref(2195:18196);                                              %For audiodata_B5
% load('audiodata_B5_a.mat');                                       %Recorded at location A (for simulation)
RXXr = data;                                                      
Fs=48000;
RepFr = 3; %Repetition frequency
t=linspace(0,(length(RXXr(1,:,1))/Fs),length(RXXr(1,:,1)));

u = 1; %measurement (a=6,b=7,c=8,m=9)

%Plot time energy signal
figure('units','normalized','outerposition',[0 0 1 1]) ;            %Open figure in full screen
for i = 1:5
%     a(i)=subplot(5, 1, mod(i-1, 5)+1) ;
%     plot(t,RXXr(u,:,i).^2);   hold on
    %find which microphone has first significant peaks.
    [pk,loc]=findpeaks(RXXr(u,:,i).^2,Fs,'Threshold',0.1e-4);
    pks(i,:) = loc(1); 
%     xlabel('Time[s]');
%     ylabel('Energy');
%     title (['Time/energy signal of p ',num2str(u),', mic',num2str(i)])
%     calculate impulse responses
    h(:,i) = ch3(ref,RXXr(u,:,i)).^2;
end
% linkaxes(a, 'x'); %make sure all plots zoom together

%plot full impulse responses
% figure('units','normalized','outerposition',[0 0 1 1]) ;
% for i = 1:5
%     b(i)=subplot(5, 1, mod(i-1, 5)+1) ;
%     plot(h(:,i));
%     title (['Impulse response h',num2str(i)])
%     xlabel('Samples');
%     ylabel('Energy');
% end
% linkaxes(b, 'x');

%Calculate distance between microphones
r12 = TDOA(h(:,1),h(:,2),'r12');        
r13 = TDOA(h(:,1),h(:,3),'r13');
r14 = TDOA(h(:,1),h(:,4),'r14');
r23 = TDOA(h(:,2),h(:,3),'r23');
r24 = TDOA(h(:,2),h(:,4),'r24');
r34 = TDOA(h(:,3),h(:,4),'r34');
r15 = TDOA(h(:,1),h(:,5),'r15');
r25 = TDOA(h(:,2),h(:,5),'r25');
r35 = TDOA(h(:,3),h(:,5),'r35');
r45 = TDOA(h(:,4),h(:,5),'r45');

[x_cor,y_cor,lowestError] = location(r12,r13,r14,r23,r24,r34,r15,r25,r35,r45);
end