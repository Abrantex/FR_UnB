function [gps,range1,range2,range3,u] = getMeasurements(state,statenr,acel);

% DEFINICOES

   ColocaOut = 1;

   %desvio padrao - aceleracao 
   var_Aproc = [0.1^2 0 0;0 0.1^2 0 ;0 0 0.1^2];
   var_Amed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];
   
   %desvio de medicao - posicao
   var_Pmed = [0.2^2 0 0;0 0.2^2 0;0 0 0.2^2];
   
   %desvio de medicao - velocidade
   var_Vmed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];
   
   %desvio de medicao - ranges
   sig_R1med = 0.07;
   sig_R2med = 0.07;
   sig_R3med = 0.07;

   %coordenadas dos sensores
   ranges = [0,5,15; %x
            5,-5,5; %y 
            0,0,0];%z


% **************************
%         OUTLIERS
% **************************


outValueGps = 6;
outValue = 2.7;
x(1,:)=statenr(1,:);
y(1,:)=state(2,:);
z(1,:)=state(3,:);
N=length(x(1,:));
outlier = zeros(4,N);
for k=1:N
    
 if (x(1,k)<=8)
     %outlier no gps
     outlier(4,k) = outValueGps;
 elseif  (x(1,k)>8 && x(1,k)<=15) 
     %outlier(1,k) = outValue;
     %outlier(3:4,k) = [outValue;outValue];
 elseif (x(1,k) >15)
     outlier(1:3,k)=[outValue;outValue;outValue];
     
 end
end
x(1,:)=state(1,:);
 % ACELEROMETRO
 
 u = acel + (chol(var_Aproc')*randn(3,N)) + ((var_Amed')*randn(3,N));
 

 %GPS 
 
 gps(1:3,:) = statenr(1:3,:) + (chol(var_Pmed')*randn(3,N));
 
 if ColocaOut == 1
    gps(1:3,:) = gps(1:3,:) +[outlier(4,:);outlier(4,:);outlier(4,:)];
 end
 
 gps(4:6,:) = statenr(4:6,:) + (chol(var_Vmed')*randn(3,N));
 %gps(4:6,:) = gps(4:6,:) +[outlier(4,:);outlier(4,:);outlier(4,:)];

for k=1:N
         
 %first landmark
 
 range1(1,k) = sqrt((ranges(1,1)-x(1,k))^2 + (ranges(2,1)-y(1,k))^2 + (ranges(3,1)-z(1,k))^2);
 range1(1,k) = range1(1,k)+ sig_R1med*randn;
     
 %second landmark
 range2(1,k) = sqrt((ranges(1,2)-x(1,k))^2 + (ranges(2,2)-y(1,k))^2 + (ranges(3,2)-z(1,k))^2);
 range2(1,k) = range2(1,k)+ sig_R2med*randn;
 
 %
 range3(1,k) = sqrt((ranges(1,3)-x(1,k))^2 + (ranges(2,3)-y(1,k))^2 + (ranges(3,3)-z(1,k))^2);
 range3(1,k) = range3(1,k)+ sig_R3med*randn;
 
 if ColocaOut == 1
    range1(1,k) = range1(1,k)+outlier(1,k);
    range2(1,k) = range2(1,k)+outlier(2,k);
    range3(1,k) = range3(1,k)+outlier(3,k);
 end


end 


end