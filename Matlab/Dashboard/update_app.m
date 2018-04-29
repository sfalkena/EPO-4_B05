function update_app()
global index_log d_l d_r motorspeed direction d_l_log d_r_log motorspeed_log direction_log t
index_log = index_log + 1;

app.RightDistGauge.Value = d_r;
app.LeftDistGauge.Value = d_l;
app.DirectionGauge.Value = direction;
app.MotorspeedGauge.Value = motorspeed;

d_l_log(index_log) = d_l;
d_r_log(index_log) = d_r;
direction_log(index_log) = direction;
motorspeed_log(index_log) = motorspeed;
t(index_log) = toc;

plot(app.LeftDistGraph,t,d_l_log);
plot(app.RightDistGraph,t,d_r_log);
plot(app.DirectionGraph,t,direction_log);
plot(app.MotorspeedGraph,t,motorspeed_log);
end