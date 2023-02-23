clc 
clear
close all
rosshutdown
rosinit('http://192.168.0.100:11311') %inicializa o node matlab no ros
%soshutdown %desliga o node do matlab
%rostopic list , lista os tópicos
%exemplo rostopic info /turtle1/cmd_vel