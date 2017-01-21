function [ h_hd_rm_removed ] = remove_headroom(h, w)

    if nargin < 2 || isempty(y)
        w = linspace(0, pi, 1000); 
    end
    
    H = freqz(h, 1, w);
    H_max = max(abs(H));
    safety_factor = 0.999; % used to ensure peak gain is less than 2
    h_hd_rm_removed = h * (2/H_max) * safety_factor;

end