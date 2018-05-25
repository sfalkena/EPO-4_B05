function [d_l, d_r] = checkDistance()
Str = EPOCommunications('transmit','Sd');
Index_l = strfind(Str, 'USL');
d_l = sscanf(Str(Index_l(1) + 3:end), '%g', 1);
Index_r = strfind(Str, 'USR');
d_r = sscanf(Str(Index_r(1) + 3:end), '%g', 1);
end