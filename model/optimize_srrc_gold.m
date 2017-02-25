function [MER, G_tx_c, R, B, FD] = optimize_srrc_gold(kshape_low, kshape_high, fd_low, fd_high, taps_low, taps_high, delta, stopband1, stopband2, stopband3)
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
  
  
  MER_list = [];
  fd_list = [];
  kshape_list = [];
  taps_list = [];
  
  % RX Filter
 
  for fd = fd_low:delta:fd_high
    for kshape = kshape_low:delta:kshape_high
      for taps = taps_low:delta*20:taps_high
          
        fprintf('taps=%d kshape=%d fd=%d\r', taps, kshape, fd);
        % Pre-allocating
        rcv_h_srrc = zeros(1,taps);
        tx_h_srrc = zeros(1,taps);
        tx_window = zeros(1,taps);
        h_sys = zeros(1,taps*2);
        H_tx = zeros(1,512);
        w_tx = linspace(0,2*pi,512);
      
        n = n+1;
        %%fprintf('Running iteration %d on R=%d B=%d FD=%d\r', n, tx_rolloff, tx_kshape, tx_fd);
        %%tx_h_srrc = rcosine(tx_fd,F_s,'sqrt',tx_rolloff,tx_fd*(tx_span-1)/2);
        
        tx_h_srrc = firrcos(taps,fd,0.12,1,'rolloff','sqrt');
        rx_h_srrc = tx_h_srrc;
        
        if(length(tx_h_srrc) == taps)
          tx_window = kaiser(taps, kshape).';
          tx_h_srrc = (tx_h_srrc .* tx_window);
          
          [tx_H, tx_rad] = freqz(tx_h_srrc,1,8192,'whole');
          tx_cutoff_bin_OB1_start = ceil(tx_BW/(tx_rate) * length(tx_H));
          tx_cutoff_bin_OB2_start = ceil((tx_BW + tx_OB1)/(tx_rate) * length(tx_H));
          tx_cutoff_bin_OB2_end = ceil((tx_BW + tx_OB1 + tx_OB2)/(tx_rate) * length(tx_H));
          tx_cutoff_bin_adj_start = ceil((3*tx_BW)/(tx_rate) * length(tx_H));
          tx_cutoff_bin_adj_end = ceil((5*tx_BW)/(tx_rate) * length(tx_H));
          
          G_tx_c_candidate_pbp = 10*log10(sum(abs(tx_H(1:tx_cutoff_bin_OB1_start)).^2));
          G_tx_c_candidate_OB1 = 10*log10(sum(abs(tx_H(tx_cutoff_bin_OB1_start:tx_cutoff_bin_OB2_start)).^2));
          G_tx_c_candidate_OB2 = 10*log10(sum(abs(tx_H(tx_cutoff_bin_OB2_start:tx_cutoff_bin_OB2_end)).^2));
          G_tx_c_candidate_adj = 10*log10(sum(abs(tx_H(tx_cutoff_bin_adj_start:tx_cutoff_bin_adj_end)).^2));

          % Calculate ISI
          h_sys = conv(tx_h_srrc, rcv_h_srrc);
          h_sys = (h_sys)/max(h_sys);
          isi = sum(downsample(h_sys,4).^2) - 1;

          MER_candidate = 10*log10(1/isi);
          
          % Save if a new optimal value is found
          if(((G_tx_c_candidate_OB1 - G_tx_c_candidate_pbp) < stopband1) && ((G_tx_c_candidate_OB2 - G_tx_c_candidate_pbp) < stopband2) && ((G_tx_c_candidate_adj - G_tx_c_candidate_pbp) < stopband3))
            if(MER_candidate > MER)
              G_tx_c = G_tx_c_candidate;
              MER = MER_candidate;
              fprintf('Found new best MER %d that meets specs: @ t=%d B=%d FD=%d\r', MER, taps, kshape, fd);
            end
            %Add to list for 3D plot
            MER_list(end+1) = MER_candidate
            kshape_list(end+1) = kshape
            taps_list(end+1) = taps
            fd_list(end+1) = fd
          end
        
        end
         
      end
    end
  end
 

figure(2);
% Try with rolloff and Fc
tri = delaunay(kshape_list,fd_list);
trisurf(tri,kshape_list, fd_list, MER_list);
xlabel('rolloff');
ylabel('fd');
zlabel('MER');

rotate3d on

