function [vT,xLambda,vT_ges,vX_ges] = fLjapunovExpCalc_template(fODE,vParams, fSolver, log, sODE_options,vX0,nT0,nT1,nDelta_T);
  %% Beschreibung
  % Programmiert nach Nayfeh, Balachandran - "Applied Nonlinear Dynamics",
  % Kapitel 7. Validiert für Nayfeh-Ergebnisse zum Rössler- und Lorenzattraktor. 
  % Die Ljapunov-Exponenten werden mit dem Gram-Schmidt-Verfahren zur
  % Orthogonalisierung der Störungen im System berechnet
  
  %% Initialisierung
  nN      = size(vX0,1);   % Dimension der DGL
  vT_ges  = [];
  vX_ges  = [];
  nR      = round((nT1-nT0)/nDelta_T);
  xY      = eye(nN);
  vX0_i   = vX0;
  nT0_i   = nT0;
  nT1_i   = nT0 + nDelta_T;
  xN_ij   = zeros(nR,nN);
  xLambda = NaN(nR,nN);
  vT      = (1:nR)*nDelta_T;
  
  %% Zeitintegration: 
  for nI = 1:nR
    % Integration mit Abweichungen y_i (alle y_i Gleichzeitig in Matrix xY)
    [vT_i,vX_i] = feval(fSolver, @(t,x) fODE(t,x,vParams), [nT0_i nT1_i], [vX0_i;xY(:)], sODE_options);
    vT_ges = [vT_ges;vT_i];
    vX_ges = [vX_ges;vX_i(:,1:nN)];

    % Gram-Schmidt-Verfahren (Orthogonalisierung der Vektoren)
    ...
    % Berechnung der Ljapunov exponenten zum Zeitpunkt nR*nDelta_T
    xLambda(nI,:) = ...
    % Vorbereitung für nächsten Schritt
    nT0_i = ...
    nT1_i = ...
    vX0_i = ...
    xY    = ...
  end 
end