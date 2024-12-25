Fs = 96000;                   
boost = 20;                   
boost_lvl = -20:4:20;      % Range of boost/cut levels in steps of 4 dB
Q = 4;                        % Q-factor (adjustable)

frequencies = [300, 2000, 8000, 16000];  %Center frequencies

for Fo = frequencies
    Wo = 2 * pi * Fo;  % Angular frequency

    figure;
    hold on;


    for i = 1:length(boost_lvl)

        boost = boost_lvl(i);
        G = 10^(boost / 20);
        k = 3 * (G - 1) / (G + 1);

        % Analog filter coefficients 
        B = [1 (3 + k) * Wo / Q Wo^2];
        A = [1 (3 - k) * Wo / Q Wo^2];

        % Bilinear transform for digital filter coefficients
        [b1, a1] = bilinear(B, A, Fs, Fo);

        % Digital filter frequency response
        [Hd, Fd] = freqz(b1, a1, 2^15, Fs);
        
        % Plot the magnitude response
        plot(Fd, 20 * log10(abs(Hd)));
    end


end