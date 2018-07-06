function [Xk,acel] = getPos()

N = 1281;
T = 0.05;

t = (0:1:N-1)*T;

%acel(1,:) = -0.005*t.^2 +0.32*t;
acel(1,:) = zeros(1,N);
acel(1,1:280) = 0.05*ones(1,280);
acel(1,641:920) = -0.11*ones(1,280);
acel(2,:) = 0.1*sin(2*pi*t*(1/20));

acel(3,:) = 0.1*sin(2*pi*t*(1/10));


%acel(1:3,:) = zeros(3,N);



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

 
Xk(:,1) = zeros(6,1);
 
%Xk(:,1) = [rand(3,1); 0; 0; 0];

for k = 1:N-1

    Xk(:,k+1) = A*Xk(:,k) + B*acel(:,k);
end

end

