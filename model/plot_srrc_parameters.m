function plot_srrc_parameters(R_low, R_high, R_def, B_low, B_high, B_def, FD_low, FD_high, FD_def, delta, stopband)
% Usage plot_srrc_parameters(0.1,0.4,0.25,1,8,3,1/12,1/3,1/8,0.005,-20)

  F_s = 1;
  N_sps = 4;
  
  MER = 0;
  G_tx_c = 0;
  R = 0;
  B = 0;
  FD = 0;
  n = 0;
  
  MER_fd = 0;
  MER_kshape = 0;
  MER_rolloff = 0;
  
  fd_val = 0;
  kshape_val = 0;
  rolloff_val = 0;
  
  
  % Pre-allocating not needed in 2017??
  %rcv_h_srrc = zeros(1,17);
  %tx_h_srrc = zeros(1,17);
  %tx_window = zeros(1,17);
  %h_sys = zeros(1,33);
  %H_tx = zeros(1,512);
  %w_tx = linspace(0,2*pi,512);  
  
  figure(1);
  
  % RX Filter
  rcv_beta = 0.25;
  rcv_span = 17;
  
  rcv_h_srrc = firrcos(rcv_span-1,1/(2*N_sps),rcv_beta,1,'rolloff','sqrt');

  % Optimize TX Filter for ideal specs
  
  tx_span = 17;

  for tx_rolloff = R_low:delta:R_high
      tx_h_srrc = firrcos(tx_span-1,FD_def,tx_rolloff,1,'rolloff','sqrt');
        
        if(length(tx_h_srrc) == 17)
          tx_window = kaiser(tx_span, B_def).';
          tx_h_srrc = (tx_h_srrc .* tx_window);
          
          [tx_H, tx_rad] = freqz(tx_h_srrc);
          % using FFT for more speed
          %H_tx = fft(tx_h_srrc, 512);
          G_tx_c_candidate = max(20*log10(abs(tx_H(205:512))));
               
          % Calculate ISI
          h_sys = conv(tx_h_srrc, rcv_h_srrc);
          h_sys = (h_sys)/max(h_sys);
          isi = sum(downsample(h_sys,4).^2) - 1;

          MER_candidate = 10*log10(1/isi);
          
           if(G_tx_c_candidate < stopband)
              MER_rolloff(end +1) = MER_candidate;
              rolloff_val(end + 1) = tx_rolloff;
           end
           
        end
  end
  subplot(3,1,1);
  plot(rolloff_val(2:end), MER_rolloff(2:end));
  title('MER vs SRRC Rolloff');

  for tx_kshape = B_low:delta*50:B_high
      tx_h_srrc = firrcos(tx_span-1,FD_def,R_def,1,'rolloff','sqrt');
        
        if(length(tx_h_srrc) == 17)
          tx_window = kaiser(tx_span, tx_kshape).';
          tx_h_srrc = (tx_h_srrc .* tx_window);
          
          [tx_H, tx_rad] = freqz(tx_h_srrc);
          % using FFT for more speed
          %H_tx = fft(tx_h_srrc, 512);
          G_tx_c_candidate = max(20*log10(abs(tx_H(205:512))));
               
          % Calculate ISI
          h_sys = conv(tx_h_srrc, rcv_h_srrc);
          h_sys = (h_sys)/max(h_sys);
          isi = sum(downsample(h_sys,4).^2) - 1;

          MER_candidate = 10*log10(1/isi);
          
          if(G_tx_c_candidate < stopband)
              MER_kshape(end +1) = MER_candidate;
              kshape_val(end + 1) = tx_kshape;
          end
          
        end
  end    
  
  subplot(3,1,2);
  plot(kshape_val(2:end), MER_kshape(2:end));
  title('MER vs Kaiser Shape');
  
  for tx_fd = FD_low:delta:FD_high
      tx_h_srrc = firrcos(tx_span-1,tx_fd,R_def,1,'rolloff','sqrt');
        
        if(length(tx_h_srrc) == 17)
          tx_window = kaiser(tx_span, B_def).';
          tx_h_srrc = (tx_h_srrc .* tx_window);
          
          [tx_H, tx_rad] = freqz(tx_h_srrc);
          % using FFT for more speed
          %H_tx = fft(tx_h_srrc, 512);
          G_tx_c_candidate = max(20*log10(abs(tx_H(205:512))));
               
          % Calculate ISI
          h_sys = conv(tx_h_srrc, rcv_h_srrc);
          h_sys = (h_sys)/max(h_sys);
          isi = sum(downsample(h_sys,4).^2) - 1;

          MER_candidate = 10*log10(1/isi);
          
          if(G_tx_c_candidate < stopband)
              MER_fd(end +1) = MER_candidate;
              fd_val(end + 1) = tx_fd;
          end
        end
  end
  
  subplot(3,1,3);
  plot(fd_val(2:end), MER_fd(2:end));
  title('MER vs 1/2(Nsps)');



