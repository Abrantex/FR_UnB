function [range1,range2,range3,u] = getMeasurements(state,statenr,acel);

% DEFINICOES

   ColocaOut = 1;

   %desvio padrao - aceleracao 
   var_Aproc = [0.1^2 0 0;0 0.1^2 0 ;0 0 0.1^2];
   var_Amed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];
   
   %desvio de medicao - ranges
   sig_R1med = 0.06;
   sig_R2med = 0.05;
   sig_R3med = 0.04;

   %coordenadas dos sensores
   ranges = [0,5,15; %x
            5,-5,5; %y 
            -0.3,0.5,0.13];%z
        
   ranges = [0,5,17; %x
            5,-6,0; %y 
            -3,7,5];%z


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
    
   outlier(:,indices(1,i)+1) = [1;0;0];
   %outlier(2,indices(2,i)+1) = sig_R2med;
   %outlier(3,indices(3,i)+1) = sig_R3med;
    
end







 % ACELEROMETRO
 
 u = acel + (chol(var_Aproc')*randn(3,N)) + ((var_Amed')*randn(3,N));
 
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