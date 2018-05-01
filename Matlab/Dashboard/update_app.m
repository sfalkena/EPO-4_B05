function update_app()
global index_log d_l d_r motorspeed direction d_l_log d_r_log motorspeed_log direction_log t
index_log = index_log + 1;

d_l_log(index_log) = d_l;
d_r_log(index_log) = d_r;
direction_log(index_log) = direction;
motorspeed_log(index_log) = motorspeed;
t(index_log) = toc;
end