function [xHat,PHat,d,pegou,S1,inovacao1] = EKF(x0,P0,imu,range1,range2,range3)


Gama = 1;

pegou = [];

xHat(:,1) = x0;
PHat(:,:,1) = P0;

u =imu;

N = length(range1);


med = [range1;range2;range3];


T = 0.05;

A = [1 0 0 T 0 0;
     0 1 0 0 T 0;
     0 0 1 0 0 T;
     0 0 0 1 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1;];

 
%u = [ax;ay;az];
B = [0.5*T^2 0 0;
     0 0.5*T^2 0;
     0 0 0.5*T^2;
     T 0 0;
     0 T 0;
     0 0 T;];
 
 var_Aproc = [0.1^2 0 0;0 0.1^2 0 ;0 0 0.1^2];
 var_Amed = [0.1^2 0 0;0 0.1^2 0;0 0 0.1^2];
 
Qimu = var_Aproc+var_Amed;

 
Q = [0.1^2 0 0 0 0 0;
     0 0.1^2 0 0 0 0;
     0 0 0.03^2 0 0 0;
     0 0 0 0.04^2 0 0;
     0 0 0 0 0.04^2 0;
     0 0 0 0 0 0.04^2];

Q = Q + B*(Qimu)*B';
 
Q = Gama*Q;

 
R1 = [0.06 0 0; % R for range;
      0  0.05 0;
      0  0 0.04];
  
R1 = Gama*R1;
  
%coordenadas fisicas dos sensores 
%        r1r2r3
ranges = [0,5,15; %x
          5,-5,5; %y 
          -0.3,0.5,0.13];%z
     
      ranges = [0,5,17; %x
            5,-6,0; %y 
            -3,7,5];%z
for k = 1:N-1

    % *******************
    %     PREDICTION
    % *******************
    xPred(:,k+1) = A*xHat(:,k) + B*u(:,k);

    Ppred(:,:,k+1) = A*PHat(:,:,k)*A'+ Q;

    % *******************
    %     UPDATE
    % *******************

   %***************************************************
    % primeiro sensor - range1
    
    difX1 = (xPred(1,k+1) - ranges(1,1)); % em x
    difY1 = (xPred(2,k+1) - ranges(2,1)); % em y
    difZ1 = (xPred(3,k+1) - ranges(3,1)); % em z
    
    difX2 = (xPred(1,k+1) - ranges(1,2)); % em x
    difY2 = (xPred(2,k+1) - ranges(2,2)); % em y
    difZ2 = (xPred(3,k+1) - ranges(3,2)); % em z
    
    difX3 = (xPred(1,k+1) - ranges(1,3)); % em x
    difY3 = (xPred(2,k+1) - ranges(2,3)); % em y
    difZ3 = (xPred(3,k+1) - ranges(3,3)); % em z
    
    
    h1 = sqrt(difX1^2 + difY1^2 + difZ1^2);
    h2 = sqrt(difX2^2 + difY2^2 + difZ2^2);
    h3 = sqrt(difX3^2 + difY3^2 + difZ3^2);
    
    H1 = [ (difX1/h1) (difY1/h1) (difZ1/h1) 0 0 0;
          (difX2/h2) (difY2/h2) (difZ2/h2) 0 0 0;
          (difX3/h3) (difY3/h3) (difZ3/h3) 0 0 0;];
     
    S1(:,:,k+1) = H1*Ppred(:,:,k+1)*H1'+ R1;
    K1 = Ppred(:,:,k+1)*H1'*inv(S1(:,:,k+1));

    inovacao1(:,k+1) = [range1(1,k+1) - h1;
                        range2(1,k+1) - h2;
                        range3(1,k+1) - h3;];

    xHat(:,k+1) = xPred(:,k+1) + K1*(inovacao1(:,k+1));
    PHat(:,:,k+1)= (eye(6)- K1*H1)*Ppred(:,:,k+1);
    
    d(1,k+1) = transpose(inovacao1(:,k+1))*inv(S1(:,:,k+1))*(inovacao1(:,k+1));
    %pegou(1,k+1) = 0;
    if d(1,k+1)  > chi2inv(0.95,3)

        xHat(:,k+1) = xPred(:,k+1);
        PHat(:,:,k+1)= Ppred(:,:,k+1);
        %pegou(1,k+1) = 1;
        pegou = [pegou k+1];
    end
    
   
     
     
end

end



    