F_s = 1;
N_sps = 4;

df = 1/2000;   % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

%% RCV Filter
% SRRC 17 Points, Rectangular Window, 0.25 Rolloff

rcv_beta = 0.25;
rcv_span = 17;

rcv_h_srrc = rcosdesign(rcv_beta, (rcv_span-1)/N_sps, N_sps, 'sqrt');

%% TX Filter
% SRRC 17 Points, Variable Window, 0.25 Rolloff

tx_rolloff = 0.35;
tx_span = 17;
tx_fd = 0.1156;
tx_shape = 2.5;

tx_h_srrc = firrcos(tx_span-1,tx_fd,tx_rolloff,1,'rolloff','sqrt');

tx_w = kaiser(tx_span, tx_shape).';

tx_h_srrc = (tx_h_srrc .* tx_w);

[tx_H, tx_rad] = freqz(tx_h_srrc);

G_tx_c_candidate = max(20*log10(abs(tx_H(205:512))));

hold off;
plot(tx_rad/(2*pi), 20*log10(abs(tx_H)));
hold on;
plot(tx_rad(205:512)/(2*pi), 20*log10(abs(tx_H(205:512))), 'r');
hold off;
title(strcat('TX Filter Amplitude, Stopband Gain = ', num2str(G_tx_c_candidate)));

fvtool(tx_h_srrc);

%tx_h_srrc = fircls1(tx_span-1,0.06,1,10^-6);




%% ISI Modeling
% Convolve the frequency responses

h_sys = conv(tx_h_srrc, rcv_h_srrc);
h_isi_norm = (h_sys)/max(h_sys);
isi = sum(downsample(h_isi_norm,4).^2) - 1;

MER = 10*log10(1/isi)

fvtool(h_isi_norm);

%% Filter Coefficients
fprintf('\nRX Filter Decimal Coefficients\n');
for i = 1:17
    fprintf('b[%d] = %2.12f \n', i-1, rcv_h_srrc(i))
end

rcv_h_srrc_18sd = round(rcv_h_srrc * 2^17);

fprintf('\nKaiser Filter 18''sd Coefficients\n');
for i = 1:17
    if(rcv_h_srrc_18sd(i) < 0)
        fprintf('b[%2.0f] = -18''sd %6d;\n', i-1, -rcv_h_srrc_18sd(i))
    else
        fprintf('b[%2.0f] =  18''sd %6d;\n', i-1, rcv_h_srrc_18sd(i))
    end
end

fprintf('\nKaiser Filter 18''sd Coefficients (symmetric / headroom)\n');
rcv_h_srrc_18sd = round(remove_headroom(rcv_h_srrc) * 2^17);
for i = 1:8
    if(rcv_h_srrc_18sd(i) < 0)
        fprintf('b[%2.0f] = -18''sd %6d;\n', i-1, -rcv_h_srrc_18sd(i))
    else
        fprintf('b[%2.0f] =  18''sd %6d;\n', i-1, rcv_h_srrc_18sd(i))
    end
end