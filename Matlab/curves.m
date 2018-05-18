% Script of EPO-4, projectgroup B-05
% Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
% May 2018

% This script will make the acceleration and deceleration curves to model
% KITT. The first value of the acceleration curve will be at d=0, de
% deceleration curve will have the last value at d=0. This is done to make
% the shifting of the curves easier.

% Load logging file
load achtste_meting_18.9v.mat

%Set first time value to 0
t(1)=0;

% Use max of sensor to avoid glitches
d=max(d_l_log,d_r_log);

% Select usable parts of data
d=d(15:end)./100;
d=-(d-max(d));
t=t(15:end);

% Use smooth function to get more usable curve
d=transpose(smooth(d));

% Determine velocity with differentials
dx=diff(d);
dt=diff(t);
v=dx./dt;

% More smoothing to improve the curves
v=transpose(smooth(v));
v=transpose(smooth(v));
v=transpose(smooth(v));

% Select usable parts of curves
accVelocityCurve = v(1:19);
accTimeCurve = t(1:19)-t(1);
accDistanceCurve = d(1:19);
brakeVelocityCurve = v(25:end-3);
brakeTimeCurve = t(25:end-4)-t(19);
brakeDistanceCurve = d(25:end-4)-d(end-4);

% Manually add in points to increase range of curves
for i=1:10
    accVelocityCurve(end+1) = (2*accVelocityCurve(end)-(1+0.006/i)*accVelocityCurve(end-1));
    accTimeCurve(end+1) = 2*accTimeCurve(end)-accTimeCurve(end-1);
    accDistanceCurve(end+1) = 2*accDistanceCurve(end)-accDistanceCurve(end-1);
end
for i=1:6
    brakeVelocityCurve = [2*brakeVelocityCurve(1)-brakeVelocityCurve(2) brakeVelocityCurve];
    brakeTimeCurve = [2*brakeTimeCurve(1)-brakeTimeCurve(2) brakeTimeCurve];
    brakeDistanceCurve = [2*brakeDistanceCurve(1)-brakeDistanceCurve(2) brakeDistanceCurve];
end

% Interpolate the curves to increase resolution
accVelocityCurve = interp(accVelocityCurve, 50);
accTimeCurve = interp(accTimeCurve, 50);
accDistanceCurve = interp(accDistanceCurve, 50);
brakeVelocityCurve = interp(brakeVelocityCurve, 50);
brakeTimeCurve = interp(brakeTimeCurve, 50);
brakeDistanceCurve = interp(brakeDistanceCurve, 50);

% Plot the resulting curves
figure
hold on
plot(accDistanceCurve,accVelocityCurve);
plot(brakeDistanceCurve,brakeVelocityCurve);
xlabel('Distance [m]')
ylabel('Velocity [m/s]')
ylim([0 3])
xlim([-2 5])
title('Original acceleration and brake curve')
legend('Acceleration','Braking')

