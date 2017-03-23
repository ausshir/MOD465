function [ h_hd_rm_removed ] = remove_headroom(h, mode, safety_factor, w)
% Usage set impulse response to be reduced so peak gain is less than 2      
%       default safety factor is 0.999
    
    

    if nargin < 4 || isempty(w)
        w = linspace(0, pi, 1000);
    end
    
    if nargin < 3 || safety_factor == 0
        safety_factor = 0.999;
    end
    
    if mode == 4
        
        % For Debug
        figure(3)
        subplot(5,1,1)
        stem(h(1:4:end))
        subplot(5,1,2)
        stem(h(2:4:end))
        subplot(5,1,3)
        stem(h(3:4:end))
        subplot(5,1,4)
        stem(h(4:4:end))
        subplot(5,1,5)
        stem(h)
        
        sum_1 = sum(abs(h(1:4:end)))
        sum_2 = sum(abs(h(2:4:end)))
        sum_3 = sum(abs(h(3:4:end)))
        sum_4 = sum(abs(h(4:4:end)))
        
        size = max([sum(abs(h(1:4:end))), sum(abs(h(2:4:end))), sum(abs(h(3:4:end))), sum(abs(h(4:4:end)))]);
        h_hd_rm_removed = (h/(size/2)) * safety_factor;
        
        h_bits = round(h_hd_rm_removed * 2^17);        
        sum_1 = sum((abs(h_bits(1:4:end))  * 131071)/(2^18))
        sum_2 = sum((abs(h_bits(2:4:end))  * 131071)/(2^18))
        sum_3 = sum((abs(h_bits(3:4:end))  * 131071)/(2^18))
        sum_4 = sum((abs(h_bits(4:4:end))  * 131071)/(2^18))        
        
    else
        H = freqz(h, 1, w);
        H_max = max(abs(H));
        h_hd_rm_removed = h * (2/H_max) * safety_factor;
    
    end

end