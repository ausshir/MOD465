function [MER, G_tx_c, R, B, FD] = optimize_srrc(R_low, R_high, B_low, B_high, FD_low, FD_high, delta)
% Usage [MER, G_tx_c, R, B] = optimize_srrc(R_low=0.15, R_high=0.35, B_low=1, B_high=7, FD_low = (1/12), FD_high = (1/2), delta=0.001)
%   Note: Fd = F_s/N_sps ~ 1/4;

  F_s = 1;
  N_sps = 4;
  
  MER = 0;
  G_tx_c = 0;
  R = 0;
  B = 0;
  FD = 0;
  n = 0;
  
  
  % Pre-allocating
  rcv_h_srrc = zeros(1,17);
  tx_h_srrc = zeros(1,17);
  tx_window = zeros(1,17);
  h_sys = zeros(1,33);
  H_tx = zeros(1,512);
  w_tx = linspace(0,2*pi,512);  
  
  % RX Filter
  rcv_beta = 0.25;
  rcv_span = 17;
  
  rcv_h_srrc = rcosine(F_s/N_sps,F_s,'sqrt',rcv_beta,(rcv_span-1)/N_sps/2);

  % Optimize TX Filter for ideal specs
  
  tx_span = 17;

  for tx_rolloff = R_low:delta:R_high
    for tx_kshape = B_low:delta*50:B_high
      for tx_fd = FD_low:delta:FD_high
    
        n = n+1;
        printf("Running iteration %d on R=%d B=%d FD=%d\r", n, tx_rolloff, tx_kshape, tx_fd);  
        
        tx_h_srrc = rcosine(tx_fd,F_s,'sqrt',tx_rolloff,tx_fd*(tx_span-1)/2);
        
        if(length(tx_h_srrc) == 17)
          tx_window = kaiser(tx_span, tx_kshape).';
          tx_h_srrc = (tx_h_srrc .* tx_window);
          
          [H_tx, w_tx] = freqz(tx_h_srrc);
          % using FFT for more speed
          %H_tx = fft(tx_h_srrc, 512);
          G_tx_c_candidate = max(20*log10(abs(H_tx(205:512))));
               
          % Calculate ISI
          h_sys = conv(tx_h_srrc, rcv_h_srrc);
          h_sys = (h_sys)/max(h_sys);
          isi = sum(downsample(h_sys,4).^2) - 1;

          MER_candidate = 10*log10(1/isi);
          
          % Save if a new optimal value is found
          if(G_tx_c_candidate < -40)
            if(MER_candidate > MER)
              G_tx_c = G_tx_c_candidate;
              MER = MER_candidate;
              B = tx_kshape;
              R = tx_rolloff;
              FD = tx_fd;
              printf("                                                              Found new best MER %d that meets specs: @ R=%d B=%d FD=%d\r", MER, tx_rolloff, tx_kshape, tx_fd);
            end
          end
        
        end
         
      end
    end
  end
  
endfunction