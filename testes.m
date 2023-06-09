iniciar_ros

global A B C pose_atual lidar_atual imagem_atual  p1
clc
plot(0,0)
p1 = polarplot(0,0,'.');
rlim([0,10000]);
%% Ajustando taxa de envio
% rostopic hz [topic]
taxa_desejada = 60; %FPS, testando vi que o máximo é 120 (8.33 ms)
rate = robotics.Rate(taxa_desejada);
rate.OverrunAction = 'drop';
t = [];
velocidades.Linear.X = 5.3;
velocidades.Angular.Z = 0.0;
A = 0;
B = 0;
C = 0;

reset(rate)
t = 0;
% while rate.TotalElapsedTime < 1*30 %tempo (s) 
while length(t) < 1000 %tempo (s) 
  %% Leitura de velocidade
  
  A = 0;
  B = 0;
  C = 0;
  
  send(pub_velocidades,velocidades);
  tic
  while(~all([A,B,C]))
    pause(0.005);
%     pause(0.01);
  end
  t = [t toc];
  length(t)
end
1/mean(t)
sum(t)
% imshow(imagem_atual)
