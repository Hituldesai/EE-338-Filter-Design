f_samp = 260e3;

%Band Edge speifications
fp1 = 43.4e3;
fs1 = 47.4e3;
fs2 = 67.4e3;
fp2 = 71.4e3;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

Wn = [(fs1+fp1)/2 (fs2+fp2)/2]*2/f_samp;        %average value of the two paramters
N_min = ceil((A-8) / (2*(2.285*0.03*pi)));       %empirical formula for N_min

%Window length for Kaiser Window
n=N_min+13;

%Ideal bandstop impulse response of length "n"

bs_ideal =  ideal_lp(pi,n) -ideal_lp(0.549*pi,n) + ideal_lp(0.33*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandStop = bs_ideal .* kaiser_win;
fvtool(FIR_BandStop);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
plot(f,abs(H))
xline(fs1, "g--");
xline(fp1, "r--");
xline(fp2, "r--");
xline(fs2, "g--");
yline(1.15, "v")
yline(0.85, "v")
yline(0.15, "v")
legend("Magnitude", "fs1 43.4 KHz", "fp1 47.4 KHz", "fp2 67.4 KHz", "fs2 71.4 KHz", "Tolerance limit")
grid