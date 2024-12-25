Fs = 96000;                   
boost = -20;                   
Q = 10;                        % Q-factor (adjustable)
Fo = 2000;

        Wo = 2 * pi * Fo;  % Angular frequency
        G = 10^(boost / 20);
        k = 3 * (G - 1) / (G + 1);

        % Analog filter coefficients 
        B = [1 (3 + k) * Wo / Q Wo^2];
        A = [1 (3 - k) * Wo / Q Wo^2];

        % Bilinear transform for digital filter coefficients
        [b1, a1] = bilinear(B, A, Fs, Fo);

        % Digital filter frequency response
        [Hd, Fd] = freqz(b1, a1, 2^15, Fs);

        figure (1);
        % Plot the magnitude response
        plot(Fd, 20 * log10(abs(Hd)));
        ylim([-25 25]);
        % read the audio file
        [audioIn, samplerate] = audioread('C:\Users\zoubr\Downloads\23_Impulse Noise Burst 96k.wav');
        %select the first column of audioIn
        audioIn = audioIn(:,1);
        % get the lenght of audioIn
        n = length(audioIn);
        % Calculate the Fast fourier Transform of audioIn
        fftdata = fft(audioIn);
        % Frequencies from 0 Hz to the Nyquist frequency
        fftdata = fftdata(1:n/2+1);

        frequencies = (0:n/2) * (samplerate/n);
       
        figure (2);
        subplot(2,1,1);
        plot(frequencies/1000,abs(fftdata));
        xlim([0 5]);

        hold on;
        % use the digital filter coefficients to filter the audio file
        filteredaudio = filter(b1,a1,audioIn);
        % now, get the lenght of audioIn
        n = length(filteredaudio);
        % Calculate the Fast fourier Transform of audioIn
        fftdata = fft(filteredaudio);
        % Frequencies from 0 Hz to the Nyquist frequency
        fftdata = fftdata(1:n/2+1);

        frequencies = (0:n/2) * (samplerate/n);
        %play audio
        sound(filteredaudio, Fs);
        %plot
        subplot(2,1,2);
        plot(frequencies/1000,abs(fftdata));

        xlim([0 5]);
        



