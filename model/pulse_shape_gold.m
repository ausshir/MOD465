close all;

F_s = 1;
N_sps = 4;
shared_span = 145;

%% TX Filter
% SRRC, n Points, 0.12 rolloff, 0.875MHz BW

tx_BW = 0.875; %MHz
tx_rate = 6.25; %Msps
tx_OB1 = 0.22;
tx_OB2 = 1.53;

tx_rolloff = 0.12;
tx_span = shared_span;
tx_fd = 0.125;
tx_shape = 0;
tx_beta = tx_rolloff;

%tx_h_srrc = firrcos(tx_span-1,tx_fd,tx_rolloff,1,'rolloff','sqrt');
tx_h_srrc = rcosdesign(tx_beta, (tx_span-1)/N_sps, N_sps, 'sqrt');
tx_w = kaiser(tx_span, tx_shape).';
tx_h_srrc = (tx_h_srrc .* tx_w);

[tx_H, tx_rad] = freqz(tx_h_srrc,1,8192,'whole');

tx_cutoff_bin_OB1_start = 1+ceil(tx_BW/(tx_rate) * length(tx_H));
tx_cutoff_bin_OB2_start = 1+ceil((tx_BW + tx_OB1)/(tx_rate) * length(tx_H));
tx_cutoff_bin_OB2_end = 1+ceil((tx_BW + tx_OB1 + tx_OB2)/(tx_rate) * length(tx_H));
tx_cutoff_bin_adj_start = 1+ceil((3*tx_BW)/(tx_rate) * length(tx_H));
tx_cutoff_bin_adj_end = 1+ceil((5*tx_BW)/(tx_rate) * length(tx_H));


G_tx_c_candidate_pbp = sum(abs(tx_H(1:tx_cutoff_bin_OB1_start)).^2);
G_tx_c_candidate_OB1 = sum(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)).^2);
G_tx_c_candidate_OB2 = sum(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)).^2);
G_tx_c_candidate_adj = sum(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)).^2);

OB1_power = 10*log10(G_tx_c_candidate_OB1 / G_tx_c_candidate_pbp);
OB2_power = 10*log10(G_tx_c_candidate_OB2 / G_tx_c_candidate_pbp);
adj_power = 10*log10(G_tx_c_candidate_adj / G_tx_c_candidate_pbp);

h1 = figure;
hold off;
plot(tx_rad/(2*pi), 20*log10(abs(tx_H)) - 20*log10(abs(tx_H(1))));
hold on;
plot(tx_rad(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start))) - 20*log10(abs(tx_H(1))), 'r');
plot(tx_rad(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end))) - 20*log10(abs(tx_H(1))), 'm');
plot(tx_rad(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end))) - 20*log10(abs(tx_H(1))), 'k');

plot(tx_rad(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)))*ones(1, tx_cutoff_bin_OB2_start + 1 - tx_cutoff_bin_OB1_start)) - 20*log10(abs(tx_H(1))), 'y');
plot(tx_rad(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)))*ones(1, tx_cutoff_bin_OB2_end + 1 - tx_cutoff_bin_OB2_start)) - 20*log10(abs(tx_H(1))), 'y');
plot(tx_rad(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)))*ones(1, tx_cutoff_bin_adj_end + 1 - tx_cutoff_bin_adj_start)) - 20*log10(abs(tx_H(1))), 'y');

hold off;
title({strcat('TX Filter Amplitude, Stopband Gain OB1 (req:-58)=', num2str(OB1_power));...
    strcat('TX Filter Amplitude, Stopband Gain OB2 (req:-60)=', num2str(OB2_power));...
    strcat('TX Filter Amplitude, Stopband Gain ADJ (req:-64)=', num2str(adj_power))...
    });

%% RX Filter
% SRRC, n Points, 0.12 rolloff, 0.875MHz BW

rcv_rolloff = 0.12;
rcv_span = shared_span;
rcv_fd = .125;
rcv_beta = 0.12;

rcv_h_srrc = rcosdesign(rcv_beta, (rcv_span-1)/N_sps, N_sps, 'sqrt');
%rcv_h_srrc = firrcos(rcv_span-1,rcv_fd,rcv_rolloff,1,'rolloff','sqrt');

%% ISI Modeling
% Convolve the frequency responses

h_sys = conv(tx_h_srrc(1:end), rcv_h_srrc(1:end));
h_isi_norm = (h_sys)/max(h_sys);
isi = [vpa(sum(vpa((h_isi_norm(1:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(2:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(3:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(4:4:end)).^2))) - vpa(1)];

isi_idx = find(isi > 0);

    figure(2);
    subplot(2,1,1)
    stem(h_isi_norm);
    title(num2str(length(h_isi_norm)));
    subplot(2,1,2)
    h_isi_plot = h_isi_norm;
    h_isi_plot(h_isi_plot==1) = 0;
    stem(h_isi_plot(isi_idx:4:end));
    title(num2str(length(h_isi_plot(isi_idx:4:end))));

MER = 10*log10(1/isi(isi_idx))

figure(h1)
dim = [.4 .5 .3 .3];
str = strcat('MER (req:50)=', num2str(double(MER)));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
WinOnTop(h1, true);

hold off

%% Output TX Filter Coefficients
fileID = fopen('LUT/srrc_tx_gold_coefs.vh','w');

fprintf(fileID, '\n//TX Filter 18''sd P2 LUT Coefficients (headroom)\n');
tx_h_srrc_18sd = round(remove_headroom(tx_h_srrc, 0.999) * (2^17) * 0.5);
for i = 1:(length(tx_h_srrc))
    if(tx_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign PRECOMP_P2[%3d] = -18''sd %6d;\n', i-1, -tx_h_srrc_18sd(i));
    else

        fprintf(fileID, 'assign PRECOMP_P2[%3d] =  18''sd %6d;\n', i-1, tx_h_srrc_18sd(i));
    end
end

fprintf(fileID,'\n\n');

fprintf(fileID, '\n//TX Filter 18''sd P1 LUT Coefficients (headroom)\n');
tx_h_srrc_18sd = round(remove_headroom(tx_h_srrc, 0.999) * (2^17) * 0.167);
for i = 1:(length(tx_h_srrc))
    if(tx_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign PRECOMP_P1[%3d] = -18''sd %6d;\n', i-1, -tx_h_srrc_18sd(i));
    else

        fprintf(fileID, 'assign PRECOMP_P1[%3d] =  18''sd %6d;\n', i-1, tx_h_srrc_18sd(i));
    end
end

fprintf(fileID,'\n\n');

fprintf(fileID, '\n//TX Filter 18''sd N1 LUT Coefficients (headroom)\n');
tx_h_srrc_18sd = round(remove_headroom(tx_h_srrc, 0.999) * (2^17) * -0.167);
for i = 1:(length(tx_h_srrc))
    if(tx_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign PRECOMP_N1[%3d] = -18''sd %6d;\n', i-1, -tx_h_srrc_18sd(i));
    else

        fprintf(fileID, 'assign PRECOMP_N1[%3d] =  18''sd %6d;\n', i-1, tx_h_srrc_18sd(i));
    end
end

fprintf(fileID,'\n\n');

fprintf(fileID, '\n//TX Filter 18''sd N2 LUT Coefficients (headroom)\n');
tx_h_srrc_18sd = round(remove_headroom(tx_h_srrc, 0.999) * (2^17) * -0.5);
for i = 1:(length(tx_h_srrc))
    if(tx_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign PRECOMP_N2[%3d] = -18''sd %6d;\n', i-1, -tx_h_srrc_18sd(i));
    else

        fprintf(fileID, 'assign PRECOMP_N2[%3d] =  18''sd %6d;\n', i-1, tx_h_srrc_18sd(i));
    end
end

fprintf(fileID,'\n');
fclose(fileID);

%% Output the RX Filter Coefficients

fileID = fopen('LUT/srrc_rx_gold_coefs.vh','w');
 
fprintf(fileID, '\n//RX Filter 18''sd Multiplier Coefficients (headroom)\n');
rcv_h_srrc_18sd = round(remove_headroom(rcv_h_srrc, 4, 0.99) * (2^17));
for i = 1:(round(length(rcv_h_srrc))/2) + 1
    if(rcv_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign coef[%3d] = -18''sd %6d;\n', i-1, -rcv_h_srrc_18sd(i));
    else
 
        fprintf(fileID, 'assign coef[%3d] =  18''sd %6d;\n', i-1, rcv_h_srrc_18sd(i));
    end
end
 
 fclose(fileID);