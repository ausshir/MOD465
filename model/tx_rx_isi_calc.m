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

tx_beta = 0.25;
tx_span = 100;

tx_h_srrc = rcosdesign(tx_beta, (tx_span-1)/N_sps, N_sps, 'sqrt');
tx_h_srrc = tx_h_srrc / sum(tx_h_srrc); % normalized for Unity DC gain

tx_w = kaiser(tx_span, 1).';

tx_w = fircls1(tx_span-1,0.06,1,10^-6);

tx_h_srrc = (tx_h_srrc .* tx_w);

fvtool(tx_h_srrc)

%tx_h_srrc = fircls1(tx_span-1,0.06,1,10^-6);




%% ISI Modeling
% Convolve the frequency responses

h_sys = conv(tx_h_srrc, rcv_h_srrc);
h_isi_norm = (h_sys)/max(h_sys);
isi = sum(downsample(h_isi_norm,4).^2) - 1;

MER = 10*log10(1/isi)

fvtool(h_isi_norm);
