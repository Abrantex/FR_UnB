%close all
figure(12)
plot3(xHat(1,:),xHat(2,:),xHat(3,:))
hold on
plot3(state(1,:),state(2,:),state(3,:))
legend('filtro','real')
grid


figure(11)
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

figure(10)
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

figure(9)
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

figure(12)
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


figure(13)
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




