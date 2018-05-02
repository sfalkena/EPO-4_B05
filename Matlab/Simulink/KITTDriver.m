run KITTParameters.m
F_a = F_a_max;
F_b = 0;
v_0 = 0;

sim('KITTRacing')
v_1 = velocityOutput.signals.values;
d_1 = distanceOutput.signals.values;
figure;
plot(d_1, v_1);
title('Velocity of KITT')
xlabel('Distance[m]')
ylabel('Velocity [m/s]')
xlim([0,10])
hold on

F_a = 0;
F_b = F_b_max;
v_0 = 12;
sim('KITTRacing')
v_2 = velocityOutput.signals.values;
d_2 = distanceOutput.signals.values;

%move plot
index1 = find(v_2 <0.01);
index2 = find(d_2 >6);
amountRemoved = index1(1)-index2(1);

%replot
value = d_2(index1(1))
d_2 = d_2-value+6;
plot(d_2, v_2);
[intersect_x,intersect_y] = polyxpoly(d_1, v_1, d_2, v_2);
scatter(intersect_x,intersect_y,'+','k');
