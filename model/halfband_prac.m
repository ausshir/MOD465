%% Halfband Filter Design
Fs = 1;
Fp = 0.875/6.25;
kaiser_beta = 5.5;

N = 10;

h_w = kaiser(N+1, kaiser_beta);

h_hb = firhalfband(N, h_w);
fvtool(h_hb);

%% Output the TX Filter Multiplier Coefficients

fileID = fopen('LUT/halfband_coefs.vh','w');

fprintf(fileID, '\n//Halfband Filter 18''sd Multiplier Coefficients (headroom)\n');

h_hb_prac = remove_headroom(h_hb, 0, 0.999);
%h_hb_prac(round(length(h_hb)/2)) = 1;
h_hb_prac = h_hb_prac/max(h_hb_prac);
tx_h_hb_18sd = round(h_hb_prac * (2^17));
fvtool(h_hb_prac);

for i = 1:(round(length(h_hb)/2))
    if(tx_h_hb_18sd(i) < 0)
        fprintf(fileID, 'assign coef[%3d] = -18''sd %6d;\n', i-1, -tx_h_hb_18sd(i));
    else

        fprintf(fileID, 'assign coef[%3d] =  18''sd %6d;\n', i-1, tx_h_hb_18sd(i));
    end
end

fclose(fileID);
