%Code provided by TU Delft, edited by:
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

function RXXr = EPO4_audio_record(iMeasure,f_c,f_b,c_r,code,Fs,nMicrop,nLoop,Nrp)
%--------------------------------------------------------------------------
% File        : audio_measure.m
% Project     : EPO-4
% Description : use sample card to record the audio signal, save the audio
% data and parameters as a .mat file
%--------------------------------------------------------------------------
% Input:iMeasure: ith measurement, e.g. iMeasure = 0, save audiodata0.mat
%       comport: bluetooth comport
%       f_c,f_b,c_r,code, as for 
%       Extension: If Timer0 == -1, then no carrier modulation
%       Fs: sample rate at which to generate the template (e.g., 48KHz)
%       nMicrop: number of microphones for measurement, e.g. 4
%       nLoop:   number of data segment to collect, e.g. 10 
%       Nrp:     number of repetition period (Timer 3) to collect, e.g. 1
%       or 2
%
% An example using audio_measure
%     epo4_audio_measure('test','\\.\COM7',15000,5000,500,'92340f0f',48e3,5,11,3);
%     squeeze(RXXr(1,:,:))  
% Output: save the audio data measured by different channels, RXXr is a 3D
%         array, of maximum size nLoop * (length of data segment) * nMicrop,
%         where length of data segment decided by Nrp, Timer3 and Fs
%         and corresponding parameters. e.g. iMeasure = 0, save audiodata0.mat
%   

% first perform sanity checks on the input
if ~ischar(iMeasure), error('iMeasure must be a string'); end
if ~isnumeric(f_c), error('f_c must be an integer'); end
if ~isnumeric(f_b), error('f_b must be an integer'); end
if ~isnumeric(c_r), error('c_r must be an integer'); end
if ~ischar(code), error('code must be a hex string'); end
if ~isnumeric(Fs), error('Fs must be a real'); end
if ~isnumeric(nMicrop), error('nMicrop must be an integer'); end
if ~isnumeric(nLoop), error('nLoop must be an integer'); end
if ~isnumeric(Nrp), error('Nrp must be a real'); end

% arrays to match Timerx to frequencies (Hz)
% FF0 = [0 5 10 15 20 25 30]*1e3; f_c
% FF1 = [1 1.5 2 2.5 3 3.5 4 4.5 5]*1e3; f_b
% FF3 = [1 2 3 4 5 6 7 8 9 10];f_r
% Ncodebits = 32;
% % compute corresponding frequencies (Hz)
% f_c = FF0(Timer0+2);	% (also allow for '-1' as input)
% f_b = FF1(Timer1+1);
% f_r = FF3(Timer3+1);

% Length of data segment
Trec = Nrp*c_r/f_b; % record data segment length
nSamplesRec = floor(Trec*Fs); %the number of samples of the recorded data (one data segment)

% The memory for the whole data segment
a_s_p_0 = zeros(nSamplesRec,1);

% Preallocate recordin storage
RXXr = zeros(nLoop,length(a_s_p_0),nMicrop);

% Repeatedly measure, save the measurements
for nRun = 1:nLoop
    
    % Parameters for transmitting and receiving with the soundcard
    playbuffer = a_s_p_0;
    playdevice = 0;
    samplerate = Fs;
    recnsamples = length(a_s_p_0);
    recfirstchannel = 1;
    reclastchannel = recfirstchannel+nMicrop-1;
    recdevice = 0;
    devicetype = 'asio';

    % RXr: matrix which contains the signal received by each microphone, each
    % column corresponse to one microphone
    RXr = pa_wavplayrecord(playbuffer,playdevice,samplerate,recnsamples, recfirstchannel, reclastchannel,recdevice, devicetype);

    %save the raw data in the data matrix, RXXr is a 3D matrix, RXXr(N_Loop, data_segment, nMicrop)
    RXXr(nRun,:,:) = RXr;

    % Show the raw data
    %for jj = 1:nMicrop        
    %    figure(jj);
    %    plot(RXr(:,jj));
    %    grid on;
    %end
end

% Save all the data and parameters code,Fs,nMicrop,nLoop,Nrp 
%save(['audiodata_' iMeasure '.mat'],'RXXr','f_b','f_c','c_r','code','Fs','nMicrop','nRun','Nrp', 'Trec','-mat');