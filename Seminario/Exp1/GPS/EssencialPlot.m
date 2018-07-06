
for k = 1:N
   varInX(k) = S(1,1,k);
   varInY(k) = S(2,2,k);
   varInZ(k) = S(3,3,k);
end

figure(1) 
subplot(3,1,1)
plot(t,inovacao(1,:),'r');
hold on; plot(t,2*sqrt(varInX),'b',t,-2*sqrt(varInX),'b')
legend('termo de inovaçao','2 \sigma')
grid
xlabel('Tempo (s)')
ylabel('Inovacao em X (m)')

subplot(3,1,2)
plot(t,d(1,:),'b',t,chi2inv(0.95,6)*ones(1,N),'r');
hold on
plot(t(1,pegos),d(1,pegos),'*k')
legend('distancia','limiar chi2','outliers capturados')
grid
xlabel('Tempo (s)')
ylabel('Chi-quadrado')



subplot(3,1,3)
plot(t,xHat(1,:)-state(1,:),'b',t,xHatc2(1,:)-state(1,:),'r');
grid
xlabel('Tempo (s)')
ylabel('Erro em x (m)')
legend('Com teste chi-quadrado','Sem teste chi-quadrado')



figure(2)
subplot(3,1,1)
plot(t,inovacao(1,:),'r');
hold on; plot(t,2*sqrt(varInX),'b',t,-2*sqrt(varInX),'b')
grid
xlabel('Tempo (s)')
ylabel('Erro em X (m)')
title('Comparação de erro de inovação e distância 2 \sigma');

subplot(3,1,2)
plot(t,inovacao(2,:),'r');
hold on; plot(t,2*sqrt(varInY),'b',t,-2*sqrt(varInY),'b')
grid
xlabel('Tempo (s)')
ylabel('Erro em Y (m)')

subplot(3,1,3)
plot(t,inovacao(3,:),'r');
hold on; plot(t,2*sqrt(varInZ),'b',t,-2*sqrt(varInZ),'b')
grid
xlabel('Tempo (s)')
ylabel('Erro em Z (m)')




