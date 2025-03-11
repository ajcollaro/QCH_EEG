fsr = 128; 
epoch_window = 30; 

eeg_c4_epochs = ceil(height(c4)/fsr/epoch_window); % this rounds up to the nearest epoch length
hypnogram_epochs = height(sleep_stages);
check_eeg_lengths = hypnogram_epochs - eeg_c4_epochs
