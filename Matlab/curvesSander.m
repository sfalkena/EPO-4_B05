% Script written by Sander Delfos
%
% This script will make the acceleration and deceleration curves to model
% KITT. The first value of the acceleration curve will be at d=0, de
% deceleration curve will have the last value at d=0. This is done to make
% the shifting of the curves easier.

load achtste_meting_18.9v.mat
t(1)=0;
d=max(d_l_log,d_r_log);
d=d(15:end)./100;
d=-(d-max(d));
t=t(15:end);
d=transpose(smooth(d));
dx=diff(d);
dt=diff(t);
v=dx./dt;
v=transpose(smooth(v));

v_acc = v(1:19);
t_acc = t(1:19)-t(1);
d_acc = d(1:19);

v_dec = v(19:end-3);
t_dec = t(19:end-4)-t(19);
d_dec = d(19:end-4)-d(end-4);


% figure
% hold on
% plot(d_acc,v_acc);
% plot(d_dec,v_dec);
% xlabel('Distance [m]')
% ylabel('Velocity [m/s]')


