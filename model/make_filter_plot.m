function make_filter_plot(hObject,~,kaiser_shape,srrc_rolloff,taps,hplot)


if(strcmp(get(hObject,'Tag'),'kaiser_shape'))
    tx_shape = 10*kaiser_shape;
else
    tx_shape = 10*kaiser_shape;
end

if(strcmp(get(hObject,'Tag'),'srrc_rolloff'))
    tx_beta = 0.12*(1-srrc_rolloff);
else
    tx_beta = 0.12*(1-srrc_rolloff);
end

if(strcmp(get(hObject,'Tag'),'length'))
    tx_span = 2.*ceil((220*taps+3)/2)-1;
else
    tx_span = 2.*ceil((220*taps+3)/2)-1;
end

F_s = 1;
N_sps = 4;

tx_BW = 0.875; %MHz
tx_rate = 6.25; %Msps
tx_OB1 = 0.22;
tx_OB2 = 1.53;
tx_fd = 0.125;

tx_h_srrc = rcosdesign(tx_beta, (tx_span-1)/N_sps, N_sps, 'sqrt');
tx_w = kaiser(tx_span, tx_shape).';
tx_h_srrc = (tx_h_srrc .* tx_w);

[tx_H, tx_rad] = freqz(tx_h_srrc, 1, 8192, 'whole');

%set(hplot,'ydata', 20*log10(abs(tx_H)));
%set(hplot,'xdata', tx_rad/(2*pi));

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

f = hplot;
hold off;
plot(tx_rad/(2*pi), 20*log10(abs(tx_H)) - 20*log10(abs(tx_H(1))));
ylim([-150,20])
hold on;
plot(tx_rad(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start))) - 20*log10(abs(tx_H(1))), 'r');
plot(tx_rad(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end))) - 20*log10(abs(tx_H(1))), 'm');
plot(tx_rad(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)/(2*pi), 20*log10(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end))) - 20*log10(abs(tx_H(1))), 'k');

plot(tx_rad(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)))*ones(1, tx_cutoff_bin_OB2_start + 1 - tx_cutoff_bin_OB1_start)) - 20*log10(abs(tx_H(1))), 'y');
plot(tx_rad(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)))*ones(1, tx_cutoff_bin_OB2_end + 1 - tx_cutoff_bin_OB2_start)) - 20*log10(abs(tx_H(1))), 'y');
plot(tx_rad(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)/(2*pi), mean(20*log10(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)))*ones(1, tx_cutoff_bin_adj_end + 1 - tx_cutoff_bin_adj_start)) - 20*log10(abs(tx_H(1))), 'y');
hold off;



rcv_rolloff = 0.12;
rcv_span = 145;
rcv_fd = .125;
rcv_beta = 0.12;

rcv_h_srrc = rcosdesign(rcv_beta, (rcv_span-1)/N_sps, N_sps, 'sqrt');
%rcv_h_srrc = firrcos(rcv_span-1,rcv_fd,rcv_rolloff,1,'rolloff','sqrt');

h_sys = conv(tx_h_srrc(1:end), rcv_h_srrc(1:end));
h_isi_norm = (h_sys)/max(h_sys);
isi = [vpa(sum(vpa((h_isi_norm(1:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(2:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(3:4:end)).^2))) - vpa(1), ...
    vpa(sum(vpa((h_isi_norm(4:4:end)).^2))) - vpa(1)];

isi_idx = find(isi > 0);

    %figure(2);
    %subplot(2,1,1)
    %stem(h_isi_norm);
    %title(num2str(length(h_isi_norm)));
    %subplot(2,1,2)
    %h_isi_plot = h_isi_norm;
    %h_isi_plot(h_isi_plot==1) = 0;
    %stem(h_isi_plot(isi_idx:4:end));
    %title(num2str(length(h_isi_plot(isi_idx:4:end))));

MER = 10*log10(1/isi(isi_idx));

figure(f);
dim = [.4 .5 .3 .3];
title({strcat('TX Filter Amplitude, Stopband Gain OB1 (req:-58)=', num2str(OB1_power));...
    strcat('TX Filter Amplitude, Stopband Gain OB2 (req:-60)=', num2str(OB2_power));...
    strcat('TX Filter Amplitude, Stopband Gain ADJ (req:-64)=', num2str(adj_power));...
    strcat('MER (req:40)=', num2str(double(MER)));...
    strcat('Kaiser=', num2str(double(tx_shape)));...
    strcat('SRRC=', num2str(double(tx_beta)));...
    strcat('Length=', num2str(double(tx_span)))...    
    });
WinOnTop(f, true);

hold off

drawnow;
