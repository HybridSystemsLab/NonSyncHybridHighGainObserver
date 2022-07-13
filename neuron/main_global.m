
close all
clear all                                                               
clc     

%system parameters
Iext=10;a=0.02;b=0.2;c=-55;d=4;
tau_m = 25; % system dwell-time

% initial conditions                                                    
% x0 = [-55; -6]; % jump before tau_1 -> switch at tau_m
% xHat0 = [27;0]; 
% x0 = [-55; -6]; % jump before tau_1 -> switch at tau_m
% xHat0 = [24;0];
% x0 = [-55;-4]; % jump between tau_1 and tau_2 -> warning and switch at tau_m
% xHat0 = [27;0];
x0 = [-55;-3.8]; % jump between tau_2 and tau_m -> switch right before the plant's jump
xHat0 = [27;0];
zHat0 = compute_z(xHat0,Iext);
stateHat0 = [zHat0;xHat0;0;3;0]; % init with preliminary CT observer (for globality) : q=3 and warning = 0

% simulation horizon                                                    
T = 120;                                                                 
J = 30;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-6;
MaxStep = 1;

% Measurement
noise = 0;

% Local hybrid observer 
ll = 6;
delta0 = 5; % delta_0
delta1 = 3; % delta_1
Delta = 3; 

% Initial high-gain CT observer
tau_1 = tau_m/4;
tau_2 = tau_m/3;


%% simu

sim('HGvw_non_synchronized_global');

%% Post-processing

% construction of resulting jump vector
jRes = zeros(size(j));
for ind=2:length(jRes)
    if j(ind)~=j(ind-1) || jHat(ind)~=jHat(ind-1)
        jRes(ind) = jRes(ind-1)+1;
    else 
        jRes(ind) = jRes(ind-1);
    end
end

modificatorF{1} = '-';
modificatorF{2} = 'LineWidth';
modificatorF{3} = 2;
modificatorJ{1} = '--';
modificatorJ{2} = 'LineWidth';
modificatorJ{3} = 1.2;

% plot system solution
figure(1)
clf
plotHarc([t,t],[j,j],[x(:,1),x(:,2)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
grid on
leg3 = legend('$x_1$','$x_2$');
set(leg3, 'Interpreter', 'latex','Fontsize',20)

% plot system solution and observer estimate
figure(2) 
clf
subplot(2,1,1), plotHarc([t,tHat],[j,jHat],[x(:,1),xHat(:,1)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
grid on
leg11 = legend('$x_1$','$\hat{x}_1$');
set(leg11, 'Interpreter', 'latex','Fontsize',20)
subplot(2,1,2), plotHarc([t,tHat],[j,jHat],[x(:,2),xHat(:,2)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
grid on
leg12 = legend('$x_2$','$\hat{x}_2$');
set(leg12, 'Interpreter', 'latex','Fontsize',20)
axis([0 T -20 10])

error = x-xHat;

% plot error
figure(3) % position
clf
plotHarc([t,t],[jRes,jRes],[error(:,1),error(:,2)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
hold on;grid on
leg2=legend('$\hat{x}_1-x_1$','$\hat{x}_2-x_2$');
set(leg2, 'Interpreter', 'latex','Fontsize',20)
%title('Estimation error')
xlabel('Time', 'Interpreter', 'latex','Fontsize',15)
%axis([0 T -2000 500])
axis([0 T -20 20])
grid on

% % plot solution 2D
% v=x(:,1);
% w=x(:,2);    
% vHat=xHat(:,1);
% wHat=xHat(:,2);  
% figure(3);
% modificator{1} = 'r';   % red line for plant
% modificator{2} = 'LineWidth';
% modificator{3} = 2;
% plotHarc(v,j,w,[],modificator);
% hold on;grid on;
% modificator{1} = 'b';   % blue line for observer
% plotHarc(vHat,jHat,wHat,[],modificator);
% xlabel('v (mV)');
% ylabel('w');
% grid on;box on; 
% hold on;

figure(4)
clf
plotHarc([tHat,tHat],[jHat,jHat],[stateHat(:,6),stateHat(:,7)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
grid on
leg4 = legend('Mode','Warning $q_w$');
set(leg4, 'Interpreter', 'latex','Fontsize',20)
xlabel('Time', 'Interpreter', 'latex','Fontsize',15)

% % Comparison in presence of output noise
% figure
% t = t_tau1;
% jRes = jRes_tau1;
% error = error_tau1;
% plotHarc([t,t],[jRes,jRes],[error(:,1),error(:,2)],[],modificatorF,modificatorJ);
% hold on
% t = t_tau2;
% jRes = jRes_tau2;
% error = error_tau2;
% plotHarc([t,t],[jRes,jRes],[error(:,1),error(:,2)],[],modificatorF,modificatorJ);
% hold on
% t = t_tau3;
% jRes = jRes_tau3;
% error = error_tau3;
% plotHarc([t,t],[jRes,jRes],[error(:,1),error(:,2)],[],modificatorF,modificatorJ);
% axis([0 T -20 20])
% grid on
% xlabel('Time', 'Interpreter', 'latex','Fontsize',15)
% 

