%Die zu lösenden Modellgleichungen befinden sich in der Datei "F.m“
function res=F(X_var, X_para)
 
%Rückbenennung aller zu bestimmenden Prozessgrößen vom Typ „Variable“
M1 = X_var(1);
x1s = X_var (2);
x1w = X_var (3);
x1v = X_var (4);
 
M2 = X_var (5);
x2w = X_var (6);
x2v = X_var (7);
 
M5 = X_var (8);
x5w = X_var (9);
 
M3 = X_var (10);
x3s = X_var (11);
 
M6 = X_var (12);
x6w = X_var (13);
x6v = X_var (14);
 
M4 = X_var (15);
x4s = X_var (16);
x4w = X_var (17);
x4v = X_var (18);
 
M7 = X_var (19);
x7s = X_var (20);
x7w = X_var (21);
x7v = X_var (22);

%Rückbenennung aller Prozessgrößen vom Typ „Parameter“
M0 = X_para(1);
x0s = X_para(2);
x0w = X_para(3);
x0v = X_para(4);
x2s = X_para(5);
x5s = X_para(6);
x5v = X_para(7);
x3w = X_para(8);
x3v = X_para(9);
x6s = X_para(10);
alpha = X_para(11);

 
%Modellgleichungen
%S_MB_M
res(1) = M0*x0s + M7*x7s - M1*x1s;
%W_MB_M
res(2) = M0*x0w + M7*x7w - M1*x1w;
%V_MB_M
res(3) = M0*x0v + M7*x7v - M1*x1v;
%S_MB_K
res(4) = M1*x1s - M2*x2s - M5*x5s;
%W_MB_K
res(5) = M1*x1w - M2*x2w - M5*x5w;
%V_MB_K
res(6) = M1*x1v - M2*x2v - M5*x5v;
%S_MB_F
res(7) = M2*x2s - M3*x3s - M6*x6s;

%W_MB_F
res(8) = M2*x2w - M3*x3w - M6*x6w;
%V_MB_F
res(9) = M2*x2v - M3*x3v - M6*x6v;
%S_MB_T
res(10) = M6*x6s - M4*x4s - M7*x7s;
%W_MB_T
res(11) = M6*x6w - M4*x4w - M7*x7w;
%V_MB_T
res(12) = M6*x6v - M4*x4v - M7*x7v;
%DEF_alpha
res(13) = alpha*M6 - M4;
%SUM_x_1
res(14) = 1 - (x1s + x1w + x1v);
%SUM_x_2
res(15) = 1 - (x2s + x2w + x2v);
%SUM_x_3
res(16) = 1 - (x3s + x3w + x3v);
%SUM_x_4
res(17) = 1 - (x4s + x4w + x4v);
%SUM_x_5
res(18) = 1 - (x5s + x5w + x5v);
%SUM_x_6
res(19) = 1 - (x6s + x6w + x6v);
%SUM_x_7
res(20) = 1 - (x7s + x7w + x7v);
%SPLIT_S
res(21) = x7s - x4s;
%SPLIT_W
res(22) = x7w - x4w;
end

%ENDE "F.m“
