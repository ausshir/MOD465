function [ h_hd_rm_removed ] = remove_headroom(h, safety_factor, w)
% Usage set impulse response to be reduced so peak gain is less than 2      
%       default safety factor is 0.999

    if nargin < 3 || isempty(w)
        w = linspace(0, pi, 1000);
        safety_factor = 0.999;
    end
    
    if nargin < 2 || safety_factor == 0
        safety_factor = 0.999;
    end
    
    H = freqz(h, 1, w);
    H_max = max(abs(H));
    h_hd_rm_removed = h * (2/H_max) * safety_factor;

end