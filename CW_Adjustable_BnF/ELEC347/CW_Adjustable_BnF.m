Fs = 96000;               % Sampling rate
Q = 10;                    % Q-factor (adjustable)

while true

    Fo = input('Enter a new center frequency (Hz) (enter 0 to exit): ');
    if Fo == 0
        break;
    end

    Wo = 2 * pi * Fo;  % Update angular frequency with new Fo
    
    boost = input('Enter a boost/cut level (dB) between -20 and +20: ');
    if boost < -20 || boost > 20
        break;
    end
    
    G = 10^(boost / 20);
    k = 3 * (G - 1) / (G + 1);

    % Define analog filter coefficients using user inputs
    B = [1 (3 + k) * Wo / Q Wo^2];
    A = [1 (3 - k) * Wo / Q Wo^2];

    %bilinear transform for digital filter coefficients
    [b1, a1] = bilinear(B, A, Fs, Fo);

    % Digital filter frequency response
    [Hd, Fd] = freqz(b1, a1, 2^15, Fs);

    % Plot the magnitude response
    plot(Fd, 20 * log10(abs(Hd)));
    ylim([-20 20]);   % Set y-axis range from -20 to +20 dB
    xlim([0 20000]);  % Set x-axis to 20 kHz
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title('Frequency Response');
    grid on;
end
