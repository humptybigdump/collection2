function y = EvaluatePolynom(u, a)
%
% Wertet das Polynom
%
%     y(u) = a_0 + a_1 * u + ... + a_(M-1) * u^(M-1)
%
% an den im Vektor u gegeben Stellen aus.
%
% u : Stützstellen an denen das Polynom berechnet werden soll
%     [u_0; u_1; ... u_(N-1)]
% a : Polynomkoeffizienten als Vektor in der Form
%     [a_0; a_1; ...; a_(M-1)]
%
% y : An den Stellen u ausgewertetes Polynom y(u)
%     [y(u_0); y(u_1); ... y(u_(N-1))]
%

N = numel(u);
M = numel(a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Vandermonde-Matrix erstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%vander(u) liefert automatisch eine quadratische Vandermonde Matrix. Bei
%%vielen Stützstellen bei einem kleinen Polynomgrad wird also eine viel zu
%%große Matrix erstellt, daher wird hier die Vandermonde-Matrix von Hand
%%erstellt.
V = zeros(N, M);

l = ones(N, 1);  %%u^0 = 1
for i=1:M
    V(:, i) = l;
    l = l.*u;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Polynom auswerten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = V * a;