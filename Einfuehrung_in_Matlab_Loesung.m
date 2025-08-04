%% Task 1
clear;
close;
clc;

%% Task 2
a=1;
b=2;
c=5;

A=[1 3 7; 0 b c];
v=[1 2 3 4 5]';
w=(0:0.01:20);

I=eye(3,3);

%% Task 3
B=b*A
C=A*transpose(A)
D=A*I

%% Task 4
for i=1:1:length(v)
    v(i)
end

%% Task 5
for i=1:1:length(v)
    if v(i)>1 && v(i)<5
        v(i)
    end
end

%% Task 6
[mittelwert,summe]=Funktion(a,b,c);

%% Task 7
x=sin(w)+sqrt(w);
figure(1)
plot(w,x)
xlabel('w')
ylabel('x')
title('Plot')

%% single-degree-of-freedom oscillator
%% Task 1: defining parameters
m=1;
c=100;
d=1;
f=0;

%% Task 3: call function "Zustandsform"
SolverOptionen=odeset('RelTol',1e-5,'AbsTol',1e-5);

[T,Y]=ode45(@Zustandsform,[0,10],[0.01;0],SolverOptionen,m,d,c,f);

%% Task 4
figure(2)
plot(T,Y(:,1),'b')
hold on
plot(T,Y(:,2),'r'); 
xlabel('x-Achse')
ylabel('y-Achse')
title('Titel')

%% Task 5
m_vector=(1:1:10);
t_vector=(0:0.1:10);
M=NaN(size(m_vector,2),size(t_vector,2)+1);

for i=1:1:length(m_vector)
    m=m_vector(i);
    [T,Y]=ode45(@Zustandsform,t_vector,[0.01;0],SolverOptionen,m,d,c,f);
    M(i,:)=[m,Y(:,1)'];
end