function a_curves()
global d_l_log d_r_log t

%Parameters
x_stop_desired = 6; %curve evaluation at x = 6m

%Accelerate to maximum speed
i_start = length(t);    %Index starting time
EPOCommunications('transmit','M165');
%Assuming max speed is reached before 3 seconds:
pause(3);
v_max = mean(diff(d_l_log(end-3:end)))/mean(diff(t(end-3:end)));
%Brake according to speed
i_brake = length(t);    %Index braking time
EPOCommunications('transmit','M135');
pause(v_max/4);
EPOCommunications('transmit','M150');
i_stop = length(t);     %Index stop time

%Convert sensor data (distance from wall) to actual distance travelled
dx = -1*diff(0.5*(d_l_log(i_start:i_stop) + d_r_log(i_start:i_stop)));
%Calculate speed and (de)acceleration
dt = diff(t(i_start:i_stop));
v = dx./dt;

%Split data into two segments
x1 = dx(i_start:i_brake);
x2 = dx(i_brake:i_stop);
v1 = dx(i_start:i_brake);
v2 = dx(i_brake:i_stop);

%Plot acceleration curve
figure;
plot(x1,v1);
title('Velocity of KITT')
xlabel('Distance[m]')
ylabel('Velocity [m/s]')
xlim([0,10])
hold on

%Move decceleration curve
i_v0 = find(v2 <0.01);  %Find index when v = 0
value = x2(i_v0);       %Find x when v = 0
x2 = x2-value+x_stop_desired;
%Plot decceleration curve
plot(x2,v2);
[intersect_x,intersect_v] = polyxpoly(x1,v1,x2,v2);
i_intersect = find(x1 == intersect_x); %Index of intersection

end