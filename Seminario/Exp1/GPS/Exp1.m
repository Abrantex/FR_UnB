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

% *******************************************************
%     IMPORTANTE!!!!!!!
%     MORE_FIGURES = 1 PARA FIGURAS NAO ESSENCIAIS
more_figures = 0;
% *******************************************************


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


[gps,u] = getMeasurement(state,statenr,acel);



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

[xHat,PHat] = EKF(x0,P0,u,gps);
[xHatc2,PHatc2,d,pegos,S,inovacao] = EKFchi2(x0,P0,u,gps);




% *********************************
%         PLOT
% *********************************

EssencialPlot

if more_figures == 1
    plotFigures
    plotFiguresNochi
end


%length(pegos)


errorNochi = state - xHat; 
errorChi = state - xHatc2;
for i =1:6
    errorNochi(i,:) = errorNochi(i,:).^2;
    errorChi(i,:) = errorChi(i,:).^2;


    RMSEnochi(i,:) = sqrt(sum(errorNochi(i,:)))/N;
    RMSEchi(i,:) = sqrt(sum(errorChi(i,:)))/N;
end
RMSEnochi
RMSEchi







