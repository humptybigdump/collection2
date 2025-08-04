function [grvqi] = evgrv1(xqi, t)

%************************************************
% evgrv : Unterprogramm zur Berechnung von grad(V)
%	   "Evaluation von grad V"
%
% Aufruf durch evkft1.m
%
% Berechnung von grad(V) nach Deakin (Clenshaw)
%
% Entwicklung der KF-Entwicklung bis zum Grade MAXDEG
%
%
% xqi	: Ortsvektor im qiS
% t	: aktueller Zeitpunkt
% grvqi	: grad(V) bzgl. des qiS
%
%************************************************

format long g


global RHO K MUE AMOD
global MAXDEG CNMFN SNMFN CNMQN SNMQN
global VATN1M VBTN2M VATPN1 VCTM1




%disp('evgrv2')




xef = zeros(6,1);
rplef = zeros(6,1);
grvlok = zeros(3,1);
grvef = zeros(3,1);
grvqi = zeros(3,1);

%********************************************************
%1.) Umrechnung von xqi vom qiS ins efS(Ergebnis: xef)
%------------------------------------------------------
xef(1:3) = trqief(xqi(1:3), 1, t);		% koosys=1, xef: 3x1
%------------------------------------------------------

%************************************************************
% 2.) Umrechnung der erdfesten kartes. Koordinaten(xef) in
%     erdfeste sphaer. Koordinaten r,phi,lambda (rplef)
%-----------------------------------------------------------
xef(4:6) = [0;0;0];
rplef(1:6) = koumr(xef(1:6), 1);			% mumr=1, rplef: 6x1
%-----------------------------------------------------------

%****************************************************************
% 3.) Berechnung von grad(V) mit erdfesten sphaer. Koordinaten
%--------------------------------------------------------------
r =     rplef(1);
phi =   rplef(2);
lambda = rplef(3);

sinp = sin(phi);
cosp = cos(phi);
sinl = sin(lambda);
cosl = cos(lambda);

q = AMOD/r;
q2 = q*q;
cosp2 = cosp*cosp;
scp = sinp/cosp2;

%-----------------------------------------------------------------
% 3.1) Berechnung von cos(m*lambda), sin(m*lambda), m= 0,...,MAXDEG
% Vorsicht : Vektorindizes beginnen bei 1 !

cosml = zeros(MAXDEG + 1, 1);
sinml = zeros(MAXDEG + 1, 1);

cosml(1) = 1;
sinml(1) = 0;
cosml(2) = cosl;
sinml(2) = sinl;

for m = 2:MAXDEG
    cosml(m+1)= cos(m*lambda);
    sinml(m+1)= sin(m*lambda);
end


%-----------------------------------------------------------------
% Initialisierung der Endsummenwerte der Doppelsumme (m = N)

ftmr =  0;		% f-tilde-N-r
ftml =  0;		% f-tilde-N-l
ftmt =  0;		% f-tilde-N-t

ftm1r =  0;		% f-tilde-(N+1)-r
ftm1l =  0;		% f-tilde-(N+1)-l
ftm1t =  0;		% f-tilde-(N+1)-t

%-----------------------------------------------------------------
% 3.2) Berechnung der partiellen Ableitungen dv/dr, dv/dphi, dv/dlambda

for m = MAXDEG:-1:0


    % Initialisierung der Anfangswerte der inneren Summe
    st2rc = 0;		% s-tilde-(N+2)-m-r-c
    st2rs = 0;		% s-tilde-(N+2)-m-r-s
    st2lc = 0;		% s-tilde-(N+2)-m-l-c
    st2ls = 0;		% s-tilde-(N+2)-m-l-s
    st2tc = 0;		% s-tilde-(N+2)-m-t-c
    st2ts = 0;		% s-tilde-(N+2)-m-t-s
    stp2tc = 0;		% s-tilde-punkt-(N+2)-m-t-c
    stp2ts = 0;		% s-tilde-punkt-(N+2)-m-t-s

    st1rc = 0;		% s-tilde-(N+1)-m-r-c
    st1rs = 0;		% s-tilde-(N+1)-m-r-s
    st1lc = 0;		% s-tilde-(N+1)-m-l-c
    st1ls = 0;		% s-tilde-(N+1)-m-l-s
    st1tc = 0;		% s-tilde-(N+1)-m-t-c
    st1ts = 0;		% s-tilde-(N+1)-m-t-s
    stp1tc = 0;		% s-tilde-punkt-(N+1)-m-t-c
    stp1ts = 0;		% s-tilde-punkt-(N+1)-m-t-s

    l = 0.5 * MAXDEG * (MAXDEG+1) + m + 1;


    % Berechnung der Endsummenwerte der inneren Summe
    % (s-tilde-m-m)

    for n = MAXDEG:-1:m

	atn1m = VATN1M(l)*q*sinp;	% a-tilde-(n+1)-m
	btn2m = VBTN2M(l)*q2;		% b-tilde-(n+2)-m
	atpn1 = VATPN1(l)*q;		% a-tilde-punkt-(n+1)-m

	cnmt = CNMQN(l);			% c-n-m-tilde 
	snmt = SNMQN(l);			% s-n-m-tilde


        % rekursive Berechnungen

	stnrc = -atn1m*st1rc - btn2m*st2rc ...
		+ (n+1)*cnmt;				% s-tilde-n-r-c	
	stnrs = -atn1m*st1rs - btn2m*st2rs ...
		+ (n+1)*snmt;				% s-tilde-n-r-s

	stnlc = -atn1m*st1lc - btn2m*st2lc + cnmt;	% s-tilde-n-l-c
	stnls = -atn1m*st1ls - btn2m*st2ls + snmt;	% s-tilde-n-l-s

	stntc = -atn1m*st1tc - btn2m*st2tc + cnmt;	% s-tilde-n-t-c
	stnts = -atn1m*st1ts - btn2m*st2ts + snmt;	% s-tilde-n-t-s

	stpntc = -atn1m*stp1tc - btn2m*stp2tc ...
		- atpn1*st1tc;				% s-tilde-punkt-
							% -n-t-c
	stpnts = -atn1m*stp1ts - btn2m*stp2ts ...
		- atpn1*st1ts;				% s-tilde-punkt-
							% -n-t-s



        % Uebergaben fuer Rekursion

	st2rc = st1rc;
	st1rc = stnrc;
	st2rs = st1rs;
	st1rs = stnrs;

	st2lc = st1lc;
	st1lc = stnlc;
	st2ls = st1ls;
	st1ls = stnls;

	st2tc = st1tc;
	st1tc = stntc;
	st2ts = st1ts;
	st1ts = stnts;

	stp2tc = stp1tc;
	stp1tc = stpntc;
	stp2ts = stp1ts;
	stp1ts = stpnts;


	l = l - n;

    end				% Ende n= MAXDEG,...,m

    %--------------------------------
    % rekursive Berechnung der Endsummenwerte
    % der aeusseren Summe : f-tilde-m-r/lambda/t, m = N,...,0

    wtmr = cosml(m+1)*stnrc + sinml(m+1)*stnrs;			%w-tilde-m-r
    wtml = m * ( cosml(m+1)*stnls - sinml(m+1)*stnlc );		%w-tilde-m-l
    wtmt = cosml(m+1)*stpntc + sinml(m+1)*stpnts ...
	   - m * scp * ( cosml(m+1)*stntc + sinml(m+1)*stnts );	%w-tilde-m-t


    ctm1 = VCTM1(m+1)*q*cosp;					% c-tilde-(m+1)


    % rekursive Berechnungen

    if m ~= MAXDEG
       ftmr = -ctm1*ftm1r + wtmr;			% f-tilde-m-r
       ftml = -ctm1*ftm1l + wtml;			% f-tilde-m-l
       ftmt = -ctm1*ftm1t + wtmt;			% f-tilde-m-t
    else
       ftmr = wtmr;				% f-tilde-m-r
       ftml = wtml;				% f-tilde-m-l
       ftmt = wtmt;				% f-tilde-m-t
    end


    % Uebergaben fuer Rekursion

    ftm1r = ftmr;				% f-tilde-(m+1)-r
    ftm1l = ftml;				% f-tilde-(m+1)-l
    ftm1t = ftmt;				% f-tilde-(m+1)-t


end				% Ende m= MAXDEG,...,0


%-----------------------------------------------------------------
% partielle Ableitungen :

dvdr = -MUE*ftmr / (r*r);		% dv/dr
dvdt = MUE*ftmt / r;			% dv/dt = dv/d(sin(phi))
dvdp = dvdt*cosp;			% dv/dphi
dvdl = MUE*ftml / r;			% dv/dlambda

%-----------------------------------------------------------------
% 3.3) Berechnung von grad(V) im lokalen kartes. System (lokS) : grvlok
%
% lokales System :
% 1-Achse nach Norden 		(in Richtung wachsendes phi)
% 2-Achse nach Osten 		(in Richtung wachsendes lambda)
% 3-Achse in radialer Richtung 	(in Richtung wachsendes r)

grvlok = [dvdp/r; dvdl/(r*cosp); dvdr];

%-----------------------------------------------------------------
% 3.4) Transformation von grad(V) vom lokS ins efS : grvef

% Aufstellen der Rotationsmatrix trgrle
% (trgrle : "Transf. des Gradienten vom lokalen ins erdfeste System")

p1 = zeros(3,3);
r2 = zeros(3,3);
r3 = zeros(3,3);
%trgrle = zeros(3,3);

p1 = rotmat(4, 0);		% rmid = 4, Spiegelung an 1-Achse
dw = pi/2 - phi;
r2 = rotmat(2, dw);		% rmid = 2, Drehwinkel: dw
r3 = rotmat(3, lambda);		% rmid = 3, Drehwinkel: lambda
%trgrle = (p1*r2*r3)';


grvef = (p1*r2*r3)' * grvlok;

%-----------------------------------------------------------------

%**************************************************
% 4.) Transformation von grad(V) vom efS ins qiS
%**************************************************
grvqi = trqief(grvef, 2, t);		% koosys=2, grvqi: 3x1
