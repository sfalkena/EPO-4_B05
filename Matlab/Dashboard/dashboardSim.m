global d_l d_r motorspeed direction voltage

for i=1:10
d_l = 400-40*i;
d_r = 400-40*i;
motorspeed = 165;
direction = 150;
voltage = 19-0.01*i;
pause(1)
end
