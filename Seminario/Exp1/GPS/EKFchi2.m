function [xHat,PHat,d,pegou,S,inovaGPS] = EKF(x0,P0,imu,gps)


Gama = 2;

pegou = [];

xHat(:,1) = x0;
PHat(:,:,1) = P0;

u =imu;

N = length(imu);


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
 
 
Q = [0.1^2 0 0 0 0 0;
     0 0.1^2 0 0 0 0;
     0 0 0.03^2 0 0 0;
     0 0 0 0.01^2 0 0;
     0 0 0 0 0.01^2 0;
     0 0 0 0 0 0.01^2];
 
Q = Gama*Q;

 
R = [0.2^2 0 0 0 0 0;
     0 0.2^2 0 0 0 0;
     0 0 0.2^2 0 0 0;
     0 0 0 0.1^2 0 0;
     0 0 0 0 0.1^2 0;
     0 0 0 0 0 0.1^2];
  
R = Gama*R;
  

     
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
    H = eye(6);
    S(:,:,k+1) = H*Ppred(:,:,k+1)*H'+R;
    K = Ppred(:,:,k+1)*H'*inv(S(:,:,k+1));

    inovaGPS(:,k+1) = gps(:,k+1) - xPred(:,k+1);

    xHatk1 = xPred(:,k+1)+ K*(inovaGPS(:,k+1));
    Pk1= Ppred(:,:,k+1) - K*H*Ppred(:,:,k+1);



    d(1,k+1) = transpose(inovaGPS(:,k+1))*inv(S(:,:,k+1))*(inovaGPS(:,k+1));



    xHat(:,k+1)= xHatk1;
    PHat(:,:,k+1)= Pk1;
     if d(1,k+1)  > chi2inv(0.95,6)
 
         xHat(:,k+1) = xPred(:,k+1);
         PHat(:,:,k+1)= Ppred(:,:,k+1);
         pegou = [pegou k+1];
     end 
     
end

end



    