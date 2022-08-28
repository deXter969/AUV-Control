close all; clear; clc;

%% RandomValueAlgorithm VS GeneticAlgorithm
close all; clear; clc;
id = 2;

x = RandomValueAlgorithm(id)
[y,time] = Controller(x,id);
figure(4)
subplot(2,1,1)
plot(time,y);
title('Random Value Algorithm');
xlabel('time');
ylabel('output');
xlim([-0.1 1]);
ylim([0 1.5]);

x = GeneticAlgorithm(id)
[y,time] = Controller(x,id);
subplot(2,1,2)
plot(time,y);
title('Genetic Algorithm');
xlabel('time');
ylabel('output');
xlim([-0.1 1]);
ylim([0 1.5]);

%% PID VS FOPID VS PDA

id = 1;
x = RandomValueAlgorithm(id)
[y,time] = Controller(x,id);
figure(5)
subplot(3,1,1)
plot(time,y);
title('PID');
xlabel('time');
ylabel('output');
xlim([-0.1 1]);
ylim([0 1.5]);

id = 2;
x = RandomValueAlgorithm(id)
[y,time] = Controller(x,id);
subplot(3,1,2);
plot(time,y);
title('Fractional Order PID');
xlabel('time');
ylabel('output');
xlim([-0.1 1]);
ylim([0 1.5]);

id = 3;
x = RandomValueAlgorithm(id)
[y,time] = Controller(x,id);
subplot(3,1,3)
plot(time,y);
title('Proportional Derivative Acceleration');
xlabel('time');
ylabel('output');
xlim([-0.1 1]);
ylim([0 1.5]);

%% MODEL TESTING
u = 8; tStep = 0.001; tStart = 0; tStop = 500;
psiNum = [0, 1.9, 2.8];
psiDen = [1, 4.5, 4.4] - psiNum;
thetaNum = [0, 0, 1.6, 1.8];
thetaDen = [1, 4.5, 6, 0.5] - thetaNum;
t = tStart:tStep:tStop;
psiKp = 1; psiKd = 0; psiKi = 0; psiLemda = 1; psiMeu = 1;
thetaKp = 1; thetaKd = 0; thetaKi = 0; thetaLemda = 1; thetaMeu = 1;

% Verticle Motion
ds = 10; dr = 0;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = round(size(t,1) / 6);

figure(1)
plot(x(begin:last),z(begin:last));
title('Vertical Motion');
hold on;
grid on;
xlabel('x');
ylabel('z');

ds = 25; dr = 0;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = round(size(t,1) / 6);

plot(x(begin:last),z(begin:last));
legend('ds = 10','ds = 25');

% Horizontal Motion
ds = 0; dr = 10;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = size(t,1);

figure(2)
plot(x(begin:last),y(begin:last));
title('Horizontal Motion');
hold on;
grid on;
xlabel('x');
ylabel('y');

ds = 0; dr = 25;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = size(t,1);

plot(x(begin:last),y(begin:last));
legend('dr = 10','dr = 25');

% 3D Motion

ds = 10; dr = 10;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = size(t,1);

figure(3)
plot3(x(begin:last),y(begin:last),z(begin:last));
title('Motion in 3-D');
hold on;
grid on;
xlabel('x');
ylabel('y');
zlabel('z');

ds = 25; dr = 25;

sim('AUVModel.slx');

t = ans.tout;
x = ans.simPos.Data(:,1);
y = ans.simPos.Data(:,2);
z = ans.simPos.Data(:,3);

begin = 1;
last = size(t,1);

plot3(x(begin:last),y(begin:last),z(begin:last));
legend('ds = 10 dr = 10','ds = 25 dr = 25');
