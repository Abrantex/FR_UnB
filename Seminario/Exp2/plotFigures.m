close all
figure(1)
plot3(xHat(1,:),xHat(2,:),xHat(3,:))
hold on
plot3(state(1,:),state(2,:),state(3,:))
hold on
plot3(0,5,0,'.','MarkerSize',30)
hold on
plot3(5,-5,0,'.','MarkerSize',30)
hold on
plot3(15,5,0,'.','MarkerSize',30)
legend('filtro','real','Sensor 1','Sensor 2','Sensor 3')
axis([-5 50 -5 50 -1 6])
grid


figure(2)
subplot(2,1,1)
plot(t,xHat(1,:),t,state(1,:))
legend('filtro','real')
ylabel('Posição em x (m)')
grid
subplot(2,1,2)
plot(t,xHat(4,:),t,state(4,:))
legend('filtro','real')
ylabel('Velocidade em x (m/s)')
grid

figure(3)
subplot(2,1,1)
plot(t,xHat(2,:),t,state(2,:))
legend('filtro','real')
ylabel('Posição em y (m)')
grid
subplot(2,1,2)
plot(t,xHat(5,:),t,state(5,:))
legend('filtro','real')
ylabel('Velocidade em y (m/2)')
grid

figure(4)
subplot(2,1,1)
plot(t,xHat(3,:),t,state(3,:))
legend('filtro','real')
ylabel('Posição em z (m)')
grid
subplot(2,1,2)
plot(t,xHat(6,:),t,state(6,:))
legend('filtro','real')
ylabel('Velocidade em z(m/s)')
grid

for k = 1:N
   varx(k) = PHat(1,1,k);
   vary(k) = PHat(2,2,k);
   varz(k) = PHat(3,3,k);
end

figure(5)
subplot(3,1,1)
plot(t,xHat(1,:)-state(1,:),'r')
hold on
plot(t,3*sqrt(varx),'b',t,-3*sqrt(varx),'b')
%legend('error','3sigma','3sigma')
title('teste 3 \sigma para posições')
ylabel('Erro em x (m)')
grid

subplot(3,1,2)
plot(t,xHat(2,:)-state(2,:),'r')
hold on
plot(t,3*sqrt(vary),'b',t,-3*sqrt(vary),'b')
%legend('error','3sigma','3sigma')
ylabel('Erro em y (m)')
grid

subplot(3,1,3)
plot(t,xHat(3,:)-state(3,:),'r')
hold on
plot(t,3*sqrt(varz),'b',t,-3*sqrt(varz),'b')
%legend('error','3sigma','3sigma')
ylabel('Erro em z(m)')
grid

for k = 1:N
   varvx(k) = PHat(4,4,k);
   varvy(k) = PHat(5,5,k);
   varvz(k) = PHat(6,6,k);
end


figure(6)
subplot(3,1,1)
plot(t,xHat(4,:)-state(4,:),'r')
hold on
plot(t,3*sqrt(varvx),'b',t,-3*sqrt(varvx),'b')
title('teste 3 \sigma para velocidades')
ylabel('Erro em x (m/s)')
grid

subplot(3,1,2)
plot(t,xHat(5,:)-state(5,:),'r')
hold on
plot(t,3*sqrt(varvy),'b',t,-3*sqrt(varvy),'b')
ylabel('Erro em y (m/s)')
grid


subplot(3,1,3)
plot(t,xHat(6,:)-state(6,:),'r')
hold on
plot(t,3*sqrt(varz),'b',t,-3*sqrt(varz),'b')
ylabel('Erro em z(m/s)')


chi2lim = chi2inv(0.95,3);
figure(7)
% subplot(3,1,1)
plot(t,d(1,:),t,chi2lim*ones(1,N))
legend('distancia M UWB','chi2')
grid
% subplot(3,1,2)
% plot(t,d(2,:),t,chi2lim*ones(1,N))
% legend('distancia','chi2')
% subplot(3,1,3)
% plot(t,d(3,:),t,chi2lim*ones(1,N))
% legend('distancia','chi2')

chi2lim = chi2inv(0.95,6);
figure(8)
plot(t,d_gps(1,:),t,chi2lim*ones(1,N))
legend('distancia M GPS','chi2')
grid


% figure
% plot(t,d(1,:),t,chi2inv(0.95,1)*ones(N))
% legend('Sensor1')
% figure
% plot(t,d(2,:),t,chi2inv(0.95,1)*ones(N))
% legend('Sensor2')
% figure
% plot(t,d(3,:),t,chi2inv(0.95,1)*ones(N))
% legend('Sensor3')
% figure
% plot(t,d_gps(1,:),t,chi2inv(0.95,1)*ones(N))
% legend('Sensor4')
% figure
% plot(t,range1)
% hold on
% plot(t,range2)
% hold on
% plot(t,range3)
% legend('1','2','3')