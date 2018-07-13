function [xHat,PHat,d,d_gps] = EKF(x0,P0,imu,range1,range2,range3,gps)

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
 
 
Q = [0.2^2 0 0 0 0 0;
     0 0.2^2 0 0 0 0;
     0 0 0.1^2 0 0 0;
     0 0 0 0.01^2 0 0;
     0 0 0 0 0.01^2 0;
     0 0 0 0 0 0.01^2];

Rgps = [0.9^2 0 0 0 0 0;
        0 0.9^2 0 0 0 0;
        0 0 0.3^2 0 0 0;
        0 0 0 0.8^2 0 0;
        0 0 0 0 0.8^2 0;
        0 0 0 0 0 0.8^2]; %ver depois 
 
R1 = [0.1^2 0 0; % R for range;
      0  0.1^2 0;
      0  0 0.1^2];
  
%coordenadas fisicas dos sensores 
%        r1r2r3
ranges = [0,5,15; %x
          5,-5,5; %y 
          0,0,0];%z
     
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
     
    S1 = H1*Ppred(:,:,k+1)*H1'+ R1;
    K1 = Ppred(:,:,k+1)*H1'*inv(S1);

    inovacao1 = [range1(1,k+1) - h1;
                 range2(1,k+1) - h2;
                 range3(1,k+1) - h3];

    xHat3 = xPred(:,k+1) + K1*( inovacao1 );
    P3= (eye(6)- K1*H1)*Ppred(:,:,k+1);
    
    d(1,k+1) = transpose(inovacao1)*inv(S1)*(inovacao1);
%     if d(1,k+1)  > chi2inv(0.95,3)
% 
%         xHat3 = xPred(:,k+1);
%         P3= Ppred(:,:,k+1);
%     end 
    
    
    %***************************************************
    % ultimo sensor - gps

%     xHat3 = xPred(:,k);
%     P3 = Ppred(:,:,k);

    %gps da forma [x y z vx vy vz]


    H4 = eye(6);
    S4 = H4*P3*H4'+Rgps;
    K4 = P3*H4'*inv(S4);

    inovaGPS = gps(:,k+1) - xHat3;

    xHat4 = xHat3+ K4*(inovaGPS);
    P4= P3 - K4*H4*P3;



    d_gps(1,k+1) = transpose(inovaGPS)*inv(S4)*(inovaGPS);



    xHat(:,k+1)= xHat4;
    PHat(:,:,k+1)= P4;
%      if d_gps(1,k+1)  > chi2inv(0.95,6)
%  
%          xHat(:,k+1) = xHat3;
%          PHat(:,:,k+1)= P3;
%      end
     
    %xHat(:,k+1)= xHat3;
    %PHat(:,:,k+1)= P3;
    %xHat(:,k+1) = xPred(:,k+1);
    %PHat(:,:,k+1) = Ppred(:,:,k+1);
     
     
end

end



    
