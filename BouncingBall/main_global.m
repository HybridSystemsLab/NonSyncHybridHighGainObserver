
close all
clear all                                                               
clc     
                                                   
%system parameters
gr = 9.81; % gravity constant
tau_m = 1.5; % plant dwell-time
epsilon = 0.01; % distance to the point (0,0) (leading to discrete trajectories) -> jump condition : x1 = 0 , x2 <-epsilon

% initial conditions                                                    
% x0 = [4; -2]; 
% xHat0 = [0;0.1];  % example with warning state on during preliminary observer
x0 = [1; -2.5]; 
xHat0 = [0.4;-5]; % example without warning state on during preliminary observer
stateHat0 = [xHat0;0;3;0]; % init with preliminary CT observer (for globality) : q=3 and warning = 0

% simulation horizon                                                    
T = 10;                                                                 
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
ll = 5; % high-gain
Lc = [ll;ll^2];
delta0 = 1; % delta_0
delta1 = 0.5; % delta_1
Delta = 0.5; 

% Preliminary CT high-gain observer
ll_init = 20;
Lc_init = [ll_init;ll_init^2];
tau_1 = tau_m/3;
tau_2 = tau_m/2;


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
%axis([0 T -20 10])

error = x-xHat;

% plot estimation error
figure(3) 
clf
plotHarc([t,t],[jRes,jRes],[error(:,1),error(:,2)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
hold on;grid on
leg2=legend('$\hat{x}_1-x_1$','$\hat{x}_2-x_2$');
set(leg2, 'Interpreter', 'latex','Fontsize',20)
%title('Estimation error')
xlabel('Time', 'Interpreter', 'latex','Fontsize',15)
%axis([0 90 -2000 500])
%axis([0 90 -90 20])
grid on

figure(4)
clf
plotHarc([tHat,tHat],[jHat,jHat],[stateHat(:,4),stateHat(:,5)],[],modificatorF,modificatorJ);
set(gca,'FontSize',15)
grid on
leg4 = legend('Mode','Warning $q_w$');
set(leg4, 'Interpreter', 'latex','Fontsize',20)
xlabel('Time', 'Interpreter', 'latex','Fontsize',15)




