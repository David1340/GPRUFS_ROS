clear
close all

%% Ligando matlab ao ROS
rosshutdown %Encerra qualquer conexão anterior com o ROS
rosinit('http://192.168.0.101:11311') %Conecta ao Raspberry
%% acessando tópico robot/cmd_vel
topico = 'robot/cmd_vel';
tipo_de_mensagem = 'geometry_msgs/Twist';
[pub_velocidades,velocidades] = rospublisher(topico,tipo_de_mensagem);
%% acessando tópico robot/vel
topico = 'robot/encoder';
tipo_de_mensagem = 'std_msgs/Int16MultiArray';
sub_encoder = rossubscriber(topico,tipo_de_mensagem,@call_back_encoder);
%% acessando tópico robot/camera
topico = 'robot/camera';
tipo_de_mensagem = 'sensor_msgs/Image';
sub_image = rossubscriber(topico,tipo_de_mensagem,@call_back_camera);
%% acessando tópico robot/lidar
topico = 'robot/lidar';
tipo_de_mensagem = 'std_msgs/Float32MultiArray';
sub_lidarx2 = rossubscriber(topico,tipo_de_mensagem,@call_back_lidar);
%% Ajustando taxa de envio
taxa_desejada = 60; 
rate = robotics.Rate(taxa_desejada);
rate.OverrunAction = 'drop';
reset(rate)

%% Funções de call_back
function call_back_encoder(~,msg)
global pose_atual A
pose_atual = msg.Data;
A = true;
end

function call_back_lidar(~,msg)
global lidar_atual B p1
lidar_atual = msg.Data;
n = length(lidar_atual)/2;
angles = lidar_atual(1:n);
dists = lidar_atual(n+1:end);
set(p1,'Xdata',angles,'Ydata',dists);
B = true;
end

function call_back_camera(~,msg)
global imagem_atual C
imagem_atual = readImage(msg);
C = true;
end