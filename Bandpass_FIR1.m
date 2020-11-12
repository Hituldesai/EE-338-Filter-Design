f_samp = 330e3;

%Band Edge speifications
fs1 = 53.2e3;
fp1 = 57.2e3;
fp2 = 77.2e3;
fs2 = 81.2e3;

Wc1 = fp1*2*pi/f_samp;
Wc2  = fp2*2*pi/f_samp;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-8) / (2*(2.285*0.024*pi)));           %empirical formula for N_min

%Window length for Kaiser Window
n=N_min+28;

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(0.46*pi,n) - ideal_lp(0.34*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
plot(f,abs(H))
xline(fs1, "g--");
xline(fp1, "r--");
xline(fp2, "r--");
xline(fs2, "g--");
legend("Magnitude", "fs1 53.2 KHz", "fp1 57.2 KHz", "fp2 77.2 KHz", "fs2 81.2 KHz")
grid