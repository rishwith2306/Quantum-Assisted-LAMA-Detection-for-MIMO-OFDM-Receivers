function sHat = mmse_detect_bpsk(H, y, noiseVar)
%MMSE_DETECT_BPSK Linear MMSE detector for BPSK.
Nt = size(H,2);
W = (H' * H + noiseVar * eye(Nt)) \ (H' * y);
sHat = sign(real(W));
sHat(sHat == 0) = 1;
end
