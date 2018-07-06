function [gps,u] = getMeasurements(state,statenr,acel);

% DEFINICOES

   ColocaOut = 1;

   %desvio padrao - aceleracao 
   var_Aproc = [0.1^2 0 0;0 0.1^2 0 ;0 0 0.1^2];
   var_Amed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];
   
   %desvio de medicao - posicao
   var_Pmed = [0.2^2 0 0;0 0.2^2 0;0 0 0.2^2];
   
   %desvio de medicao - velocidade
   var_Vmed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];


% **************************
%         OUTLIERS
% **************************

outValue = 2.0;
x(1,:)=state(1,:);
y(1,:)=state(2,:);
z(1,:)=state(3,:);
N=length(x(1,:));
outlier = zeros(3,N);


indices = round(1280*rand(1,64));

for i = 1:64
    
   outlier(:,indices(1,i)+1) = [1;1;1];
   %outlier(2,indices(2,i)+1) = sig_R2med;
   %outlier(3,indices(3,i)+1) = sig_R3med;
    
end







 % ACELEROMETRO
 
 u = acel + (chol(var_Aproc')*randn(3,N)) + ((var_Amed')*randn(3,N));
 
 %GPS 

 gps(1:3,:) = statenr(1:3,:) + (chol(var_Pmed')*randn(3,N));

 if ColocaOut == 1
    gps(1:3,:) = gps(1:3,:) +[outlier(1,:);outlier(2,:);outlier(3,:)];
 end

 gps(4:6,:) = statenr(4:6,:) + (chol(var_Vmed')*randn(3,N));


end