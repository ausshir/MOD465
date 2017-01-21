

F_s = 1;
N_sps = 4;

df = 1/2000;   % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

%% RCV Filter
% SRRC 17 Points, Rectangular Window, 0.25 Rolloff

rcv_beta = 0.25;
rcv_span = 17;

rcv_h_srrc = rcosine(F_s/N_sps,F_s,'sqrt',rcv_beta,2);
[H_rx, w_rx] = freqz(rcv_h_srrc);

figure(1);
subplot(2,2,1);
stem(rcv_h_srrc,'r*');
title('RX Filter Taps');
subplot(2,2,2);
plot(w_rx/(2*pi), 20*log10(abs(H_rx)), 'r');
title('RX Filter Frequency Response');


%% TX Filter
% SRRC 17 Points, Variable Window, 0.25 Rolloff

tx_beta = 0.35;
tx_span = 17;
tx_kshape = 2.5;
tx_fd = 0.23563;

tx_h_srrc = rcosine(tx_fd,F_s,'sqrt',tx_rolloff,tx_fd*(tx_span-1)/2);

tx_window = kaiser(tx_span, tx_kshape).';
tx_h_srrc = (tx_h_srrc .* tx_w);

[H_tx, w_tx] = freqz(tx_h_srrc);    
G_tx_c_candidate = max(20*log10(abs(H_tx(205:512))));

%w_tx = linspace(0,2*pi,512);
%H_tx = fft(tx_h_srrc, 512);

figure(1);
subplot(2,2,3);
stem(tx_h_srrc,'b');
title('TX Filter Taps');
subplot(2,2,4);
hold off;
plot(w_tx/(2*pi), 20*log10(abs(H_tx)),'b');
hold on;
plot(w_tx(204:512)/(2*pi), 20*log10(abs(H_tx(204:512))),'r');
title(strcat('TX Filter Frequency Response. Stopband Gain = ',num2str(G_tx_c_candidate)));
hold off;


%% ISI Modeling
% Convolve the frequency responses


h_sys = conv(tx_h_srrc, rcv_h_srrc);
h_isi_norm = (h_sys)/max(h_sys);
isi = sum(downsample(h_isi_norm,4).^2) - 1;  

MER = 10*log10(1/isi)

[H_sys, w_sys] = freqz(h_sys);

figure(2);
subplot(2,1,1);
stem(h_sys, 'g');
title(strcat('Matched Pair Impulse response ISI=',num2str(MER)));
subplot(2,1,2)
plot(w_sys/(2*pi), 20*log10(abs(H_sys)),'g');
title('Matched Pair Frequency Response');
