% *****************************************************
%         SEMINARIO DE FUNDAMENTOS DE ROBOTICAS
%                   1ª simulação
%             Validação do teste chi2 
%             para rejeição a outliers
%        
%         Bruno Martins Calazans Silva - 18/0007181
%         Matheus Abrantes Cerqueira - 13/0144291
%         
% *****************************************************

close all;clear all;clc

%%%CONFIGURATIONS
N = 1281;
T=0.05; %sampling period
t = (1:N)*T;

% 
% *********************************
%         POSICAO
% *********************************



[statenr,acel] = getPosExp1(); % in the form [x;y;z;vx;vy;vz;];


%%% add process noise to state
sigPos = [0.1;0.1;0.03];
sigVel = [0.01;0.01;0.01];
sigProcess = [sigPos;sigVel];

state = getProNoise(statenr,sigProcess);
%state = statenr;

% *********************************
%         MEDICAO
% *********************************


[range1,range2,range3,u] = getMeasurement(state,statenr,acel);



% *********************************
%         EKF
% *********************************

%P0,x0;
% Variancia inicial - chute
varPos0 = [0.1;0.1;0.1]; %posicao
varV0 = [0.1;0.1;0.1]; %velocidade
P0 = zeros(6,6);
P0(1,1)= varPos0(1,1); P0(2,2)= varPos0(2,1);P0(3,3)= varPos0(3,1);
P0(4,4)= varV0(1,1); P0(5,5)= varV0(2,1);P0(6,6)= varV0(3,1);

x0 = zeros(6,1);

[xHat,PHat] = EKF(x0,P0,u,range1,range2,range3);
[xHatc2,PHatc2,d,pegos] = EKFchi2(x0,P0,u,range1,range2,range3);




% *********************************
%         PLOT
% *********************************



plotFigures
plotFiguresNochi

figure(14)
plot(t,xHat(1,:)-state(1,:),t,xHatc2(1,:)-state(1,:))




% figure
% plot(t,range1,t,ranget1,'--')
% hold on
% plot(t,range2,t,ranget2,'--')
% plot(t,range3,t,ranget3,'--')







