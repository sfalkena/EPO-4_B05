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
v=transpose(smooth(v));
v=transpose(smooth(v));

v_acc = v(1:19);
t_acc = t(1:19)-t(1);
d_acc = d(1:19);

v_dec = v(25:end-3)
t_dec = t(25:end-4)-t(19);
d_dec = d(25:end-4)-d(end-4);

%manually add in extra points

for i=1:10
    v_acc(end+1) = (2*v_acc(end)-(1+0.006/i)*v_acc(end-1));
    t_acc(end+1) = 2*t_acc(end)-t_acc(end-1);
    d_acc(end+1) = 2*d_acc(end)-d_acc(end-1);
end
for i=1:6
    v_dec = [2*v_dec(1)-v_dec(2) v_dec];
    t_dec = [2*t_dec(1)-t_dec(2) t_dec];
    d_dec = [2*d_dec(1)-d_dec(2) d_dec];
end

%interpolate to get theoretical 1cm resolution
v_acc = interp(v_acc, 50);
t_acc = interp(t_acc, 50);
d_acc = interp(d_acc, 50);

v_dec = interp(v_dec, 50);
t_dec = interp(t_dec, 50);
d_dec = interp(d_dec, 50);

% figure
% hold on
% plot(d_acc,v_acc);
% plot(d_dec,v_dec);
% xlabel('Distance [m]')
% ylabel('Velocity [m/s]')
% ylim([0 3])
% xlim([-2 5])


