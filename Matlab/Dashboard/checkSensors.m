function checkSensors()
global d_l d_r motorspeed direction
Str = EPOCommunications('transmit','S');
Index_l = strfind(Str, 'L');
d_l = sscanf(Str(Index_l(1) + 1:end), '%g', 1);
Index_r = strfind(Str, 'R');
d_r = sscanf(Str(Index_r(1) + 1:end), '%g', 1);
Index_d = strfind(Str, 'Dir.');
direction = sscanf(Str(Index_d(1) + 4:end), '%g', 1);
Index_m = strfind(Str, 'Mot.');
motorspeed = sscanf(Str(Index_m(1) + 4:end), '%g', 1);
update_app();
end