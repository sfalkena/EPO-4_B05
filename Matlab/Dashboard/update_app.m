function update_app(d_l, d_r, direction, motorspeed)
global index_log
index_log = index_log + 1;

app.RightDistGauge.Value = d_r;
app.LeftDistGauge.Value = d_l;
app.DirectionGauge.Value = direction;
app.MotorspeedGauge.Value = motorspeed;

d_l_log(index_log) = d_l;
d_r_log(index_log) = d_r;
direction_log(index_log) = direction;
motorspeed_log(index_log) = motorspeed;
t = toc;

plot(app.LeftDistGraph,t,d_l_log);
plot(app.RightDistGraph,t,r_l_log);
plot(app.DirectionGraph,t,direction_log);
plot(app.MotorspeedGraph,t,motorspeed_log);
end