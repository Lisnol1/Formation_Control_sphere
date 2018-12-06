function draw_sphere()
global globalpara
% globalpara.center_radius = 30;
% globalpara.center_position = [35 50  26];
[x,y,z] = sphere(22);
x = globalpara.center_radius*x + globalpara.center_position(1).*ones(size(x)); 
y = globalpara.center_radius*y + globalpara.center_position(2).*ones(size(y)); 
z = globalpara.center_radius*z + globalpara.center_position(3).*ones(size(z)); 
plot3(x, y, z,'color',[96 96 96]/255); 
hold on
plot3(x',y',z','color',[96 96 96]/255);
grid on
hold on



