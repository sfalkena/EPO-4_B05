function saveDatalogging()
global d_l_log d_r_log motorspeed_log direction_log t
c = datetime('now', 'Format', 'd_M_y_hhmm') ;
filename = sprintf('datalogging_%s',c);
save(filename, 'd_l_log', 'd_r_log', 'motorspeed_log', 'direction_log', 't');
end
