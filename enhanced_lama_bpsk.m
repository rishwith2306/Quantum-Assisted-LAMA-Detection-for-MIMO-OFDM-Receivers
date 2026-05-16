function [sHard, sSoft, reliability] = enhanced_lama_bpsk(H, y, noiseVar, cfg)

Nt = size(H,2);
G = H' * H;
yMF = H' * y;

gDiag = real(diag(G));
gDiag(gDiag <= 1e-12) = 1e-12;
invDiag = 1 ./ gDiag;
Dinv = diag(invDiag);
Gtilde = eye(Nt) - Dinv * G;
yTildeMF = Dinv * yMF;

% Initialize.
sOld = zeros(Nt,1);
z = yTildeMF;
tauHat = 1;
rho = (tauHat + noiseVar) * invDiag;

for it = 1:cfg.lamaIterations
    % BPSK posterior mean under scalar Gaussian approximation.
    denom = max(real(rho), 1e-12);
    sSoft = tanh(2 * real(z) ./ denom);

    % Variance of BPSK with mean tanh(.).
    tauVec = max(0, 1 - sSoft.^2);

    % Damped scalar second moment estimate.
    tauNew = mean(tauVec);
    tauHat = cfg.thetaTau * tauNew + (1 - cfg.thetaTau) * tauHat;

    % Onsager-like correction and damped effective variance.
    alpha = (tauHat / (tauHat + noiseVar + eps)) * (z - sOld);
    rho = cfg.thetaRho * (tauHat + noiseVar) * invDiag + (1 - cfg.thetaRho) * rho;

    % Signal update using Gram-domain preprocessing.
    z = yTildeMF + Gtilde * sSoft + alpha;
    sOld = sSoft;
end

sHard = sign(sSoft);
sHard(sHard == 0) = 1;
reliability = abs(sSoft);  % 1 means confident, 0 means uncertain.
end
