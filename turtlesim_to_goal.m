clc 
clear
close all
%% Ligando matlab ao ROS
rosshutdown
rosinit('http://192.168.0.100:11311') %inicializa o node matlab no ros
%rostopic list %lista os tópicos disponíveis
%rostopic info /turtle1/cmd_vel %ver informações a respeito do tópico
%% acessando tópico turtle1/cmd_vel para envio de velocidades para o turtle
topico = 'turtle1/cmd_vel';
tipo_de_mensagem = 'geometry_msgs/Twist';
[pub_velocidades,velocidades] = rospublisher(topico,tipo_de_mensagem);
% velocidades = rosmessage(pub_velocidades);
%% acessando tópico turtle1/
topico = 'turtle1/pose';
tipo_de_mensagem = 'turtlesim/Pose';
sub_pose = rossubscriber(topico,tipo_de_mensagem,'BufferSize',1);
%% Ajustando taxa de envio
taxa_desejada = 30; %FPS, testando vi que o máximo é 120 (8.33 ms)
rate = robotics.Rate(taxa_desejada);
rate.OverrunAction = 'drop';
%% Posição de Destino
destino = [7;7];
%% Controle do robô
kv = 0.5;
kw = 2;
reset(rate)
while rate.TotalElapsedTime < 60 %tempo (s)
  pose_atual = receive(sub_pose) %trava o código até receber
  v = destino - [pose_atual.X;pose_atual.Y];
  d = norm(v);
  if((d < 10^-1) & (pose_atual.LinearVelocity < -10^2)), break; end
  th = atan2(v(2),v(1)) - pose_atual.Theta;
  
  if th > pi, th = th - 2*pi; end
  if th < -pi, th = th + 2*pi; end
  
  velocidades.Linear.X = kv*d;
  velocidades.Angular.Z = kw*th;
  send(pub_velocidades,velocidades);
  waitfor(rate);
end
pose_atual = receive(sub_pose)