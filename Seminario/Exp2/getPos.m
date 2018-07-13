function [resp,acel] = getPos()


T = 0.05;
Tf = 10;
t = 0:T:Tf;
N = length(t);
a0 = 0;
a1 = 0;
a2 = 0.45;
a3 = -0.03;
for i = 1:N
    p1(i) = a0 + a1*t(i) + a2*t(i)^2 + a3*(t(i)^3);
    
    k=abs(i-(N+1));
    
    p5x(k)=p1(i);
end

%************************************
x0 = 15;
x1 = 45;
Tf2 = 10;
T02 = 0;

t2 = T02:T:Tf2;

a2 = 3*(x1-x0)/(Tf2^2);
a3 = -2*(x1-x0)/(Tf2^3);

N2 = length(t2);
p4x=zeros(1,N2);

for i = 1:N2
    p2(i) = x0 + a2*t2(i)^2 + a3*(t2(i)^3);
    
    j=abs(i-(N2+1));
    
    p4x(j)=p2(i);
end





y0 = [0];
y1 = [30];
Tf = [10];
T0 = [0];

t3 = T0:T:Tf;

a2 = 3*(y1-y0)/(Tf^2);
a3 = -2*(y1-y0)/(Tf^3);

N3 = length(t2);

x=[p1 p2(1,2:N2) 45*ones(1,N3-1) p4x(1,2:N2) 15*ones(1,N3-1) p5x(1,2:N)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clc;clear all; close all
y0 = [0 0 0 30 30 0];
y1 = [0 0 30 30 0 0];
%Tf = [10 25 40 55 70 80];
%T0 = [0 10 25 40 55 70];
Tf = [10 20 30 40 50 60];
T0 = [0 10 20 30 40 50];


T = 0.05;
ty(1,:) = T0(1,1):T:Tf(1,1);
%ty2(1,:) = (T0(1,2)-T):T:Tf(1,2);
ty2(1,:) = T:T:(Tf(1,2)-T0(1,2));
ty2(2,:) = T:T:(Tf(1,3)-T0(1,3));
ty2(3,:) = T:T:(Tf(1,4)-T0(1,4));
ty2(4,:) = T:T:(Tf(1,5)-T0(1,5));
ty3(1,:) = T:T:(Tf(1,6)-T0(1,6));

a2 = 3*(y1-y0)./((Tf-T0).^2);
a3 = -2*(y1-y0)./((Tf-T0).^3);

y = [];
i = 1;
y = y0(1,i)*ty(i,:) + a2(1,i)*(ty(i,:).^2) + a3(1,i)*(ty(i,:).^3);



%
%for i = 2:(length(T0)-2)
i = 1;
for i = 1:4
    y_temp = y0(1,i+1) + a2(1,i+1)*(ty2(i,:).^2) + a3(1,i+1)*(ty2(i,:).^3);
    y = [y y_temp];
%end

end


i = 1;
y_temp = y0(1,6)*ty3(1,:) + a2(1,6)*(ty3(1,:).^2) + a3(1,6)*(ty3(1,:).^3);

y = [y y_temp];

t = 0:T:Tf(1,6);



N = length(t);
N1 = length(ty);
N2 = length(ty2);
N3 = length(ty3);

%z = 2 + 0.05*cos(5*2*pi*t);
z = 2*ones(1,length(t));

%z = [(5*ones(1,1:N1)) z (5*ones(1,(N-N3):N))];
z(1,1:N1) = 2;
z(1,(N-N3):N) = 2;


%*******************
%    SUBIDA
%*******************
TfSub = 2-T;
T = 0.05;
tSub = 0:T:TfSub;

TfDesc = Tf(1,6)+4;
TiDesc = Tf(1,6)+T+2;
tDesc = TiDesc:T:TfDesc;

zfSub = 2;

a2 = 3*(zfSub-0)/((TfSub-T)^2);
a3 = -2*(zfSub-0)/((TfSub-T)^3);

zSub = a2*tSub.^2 + a3*tSub.^3;

zDesc = zSub(1,length(zSub):-1:1);

NSub = length(tSub);

z = [zSub z zDesc];


x = [zeros(1,NSub) x zeros(1,NSub)];
y = [zeros(1,NSub) y zeros(1,NSub)];

t = [tSub (t+TfSub) tDesc];

pos = [x;y;z];
vel(1,:) = gradient(pos(1,:));
vel(2,:) = gradient(pos(2,:));
vel(3,:) = gradient(pos(3,:));
acel(1,:) = gradient(vel(1,:));
acel(2,:) = gradient(vel(2,:));
acel(3,:) = gradient(vel(3,:));
resp = [pos;vel];
end

