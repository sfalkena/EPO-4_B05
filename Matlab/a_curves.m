%Load/declare parameters
load('...mat');            %Loads time and sensor data

x_stop_desired = 6;         %Curve evaluation at x = 6 m
v_threshold = 0.01          %Threshold between moving and not moving

%Convert sensor data (distance from wall) to actual distance travelled
dx = -1*diff(0.5*(d_l_log + d_r_log));
x = dx;
for i = 2:length(x)
    x(i) = x(i)+x(i-1);
    i = i+1;
end

%Calculate speed
dt = diff(t);
v = dx./dt;              %[m/s]

%Find index of starting,braking and stopping point
i = find(v > v_threshold);
i_start = i(1);
i_brake = find(v == max(v));
i_stop = i(end)+1;

%Split data into two segments
x1 = x(i_start:i_brake);
x2 = x(i_brake:i_stop);
v1 = v(i_start:i_brake);
v2 = v(i_brake:i_stop);

%Plot acceleration curve
figure;
plot(x1,v1);
title('Velocity of KITT')
xlabel('Distance[m]')
ylabel('Velocity [m/s]')
xlim([0 10]);
hold on

%Move decceleration curve
offset = x2(end);       %Find x when v = 0
x2 = x2-offset+x_stop_desired; %x2 = x2 - offset + x_stop_desired
%Plot decceleration curve
plot(x2,v2);

%Find intersection point
[intersect_x,intersect_v] = polyxpoly(x1,v1,x2,v2);
i_intersect = find(x1 == intersect_x); %Index of intersection