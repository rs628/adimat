% function [t, y_obj] = ode23s(func, ts, y0)
%
% Copyright (c) 2018 Johannes Willkomm <johannes@johannes-willkomm.de>
%
function [t, y_obj] = ode23s(func, ts, y0)
  [t, y_obj] = ode_generic(@ode23s, func, ts, y0);
