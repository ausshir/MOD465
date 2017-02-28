close all;

F_s = 1;
N_sps = 4;
shared_span = 189;

%% TX Filter
% SRRC, n Points, 0.12 rolloff, 0.875MHz BW

tx_BW = 0.875; %MHz
tx_rate = 6.25; %Msps
tx_OB1 = 0.22;
tx_OB2 = 1.53;

tx_rolloff = 0.1;
tx_span = shared_span;
tx_fd = 0.125;
tx_shape = 1.5;
tx_beta = 0.1;

%tx_h_srrc = firrcos(tx_span-1,tx_fd,tx_rolloff,1,'rolloff','sqrt');
tx_h_srrc = rcosdesign(tx_beta, (tx_span-1)/N_sps, N_sps, 'sqrt');
tx_w = kaiser(tx_span, tx_shape).';
tx_h_srrc = (tx_h_srrc .* tx_w);

[tx_H, tx_rad] = freqz(tx_h_srrc,1,16384,'whole');

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

figure(1);
hold off;
plot(tx_rad/(2*pi), 20*log10(abs(tx_H)));
hold on;
plot(tx_rad(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start))), 'r');
plot(tx_rad(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end))), 'm');
plot(tx_rad(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end))), 'k');

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

h_sys = conv(tx_h_srrc, rcv_h_srrc);
h_isi_norm = (h_sys)/max(h_sys);
isi = vpa(sum(vpa(downsample(h_isi_norm,4).^2))) - vpa(1);

%fvtool(h_isi_norm)

MER = 10*log10(1/isi)

figure(1)
dim = [.4 .5 .3 .3];
str = strcat('MER (req:50)=', num2str(double(MER)));
annotation('textbox',dim,'String',str,'FitBoxToText','on');

hold off

%% Output TX Filter Coefficients
fileID = fopen('srrc_tx_gold_coefs.vh','w');

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

fileID = fopen('srrc_rx_gold_coefs.vh','w');

fprintf(fileID, '\n//RX Filter 18''sd Multiplier Coefficients (headroom)\n');
rcv_h_srrc_18sd = round(remove_headroom(rcv_h_srrc, 0.999) * (2^17));
for i = 1:(round(length(rcv_h_srrc))/2) + 1
    if(rcv_h_srrc_18sd(i) < 0)
        fprintf(fileID, 'assign coef[%3d] = -18''sd %6d;\n', i-1, -rcv_h_srrc_18sd(i));
    else

        fprintf(fileID, 'assign coef[%3d] =  18''sd %6d;\n', i-1, rcv_h_srrc_18sd(i));
    end
end

fclose(fileID);