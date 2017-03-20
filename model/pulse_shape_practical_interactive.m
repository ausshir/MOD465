%% TX Filter Interactive Design
close all;

%% Initial Plot

F_s = 1;
N_sps = 4;
tx_span = 113;

tx_BW = 0.875; %MHz
tx_rate = 6.25; %Msps
tx_OB1 = 0.22;
tx_OB2 = 1.53;

tx_fd = 0.125;
tx_shape = 4;
tx_beta = 0.09;

tx_h_srrc = rcosdesign(tx_beta, (tx_span-1)/N_sps, N_sps, 'sqrt');
tx_w = kaiser(tx_span, tx_shape).';
tx_h_srrc = (tx_h_srrc .* tx_w);

[tx_H, tx_rad] = freqz(tx_h_srrc,1,8192,'whole');

%hplot = plot(tx_rad/(2*pi), 20*log10(abs(tx_H)), 'k');
hplot = figure;

s1 = uicontrol('Tag','kaiser_shape','style','slider','units','pixel','position',[20 20 300 20]);
s2 = uicontrol('Tag','srrc_rolloff','style','slider','units','pixel','position',[340 20, 300 20]);
s3 = uicontrol('Tag','length','style','slider','units','pixel','position',[660 20 300, 20]);

s1.Value = 0.5;
s2.Value = 0.5;
s3.Value = 0.5;

make_filter_plot(s1, 0, s1.Value, s2.Value, s3.Value, hplot);

addlistener([s1, s2, s3],'ContinuousValueChange',@(hObject_s1, event) make_filter_plot(hObject_s1, event, s1.Value, s2.Value, s3.Value, hplot));