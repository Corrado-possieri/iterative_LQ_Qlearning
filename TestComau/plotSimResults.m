clear all
close all
clc

load simCOMAU_.mat

figure()
semilogy(Icost)

xfin = x0;
tott = [];
totx1 = [];
tend = 0;
baseLine = IBaseline{1};
N = size(baseLine,1);
n = length(x0);
for k = 1:N-1
    ustar = Iu{1};
    odefun = @(t,x) odeCOMAU(t,x,ustar(:,k));
    [t,x] = ode45(odefun,[0,T],xfin);
    tott = [tott; t + tend];
    totx1 = [totx1; x];
    tend = tott(end);
    xfin = x(end,:)';
end

figure()
subplot(2,1,1)
plot(tott,totx1)
hold on
plot(T*(0:N-1),xstar,'*')

subplot(2,1,2)
stairs(0:N-1,baseLine(:,n+1:end))

xfin = x0;
tott = [];
totx = [];
tend = 0;
baseLine = IBaseline{end};
N = size(baseLine,1);
n = length(x0);
for k = 1:N-1
    ustar = Iu{end};
    odefun = @(t,x) odeCOMAU(t,x,ustar(:,k));
    [t,x] = ode45(odefun,[0,T],xfin);
    tott = [tott; t + tend];
    totx = [totx; x];
    tend = tott(end);
    xfin = x(end,:)';
end

figure()
subplot(2,1,1)
plot(tott,totx)
hold on
plot(T*(0:N-1),xstar,'*')

subplot(2,1,2)
stairs(0:N-1,baseLine(:,n+1:end))

%%
figure()
plot3(totx(:,1),totx(:,2),totx(:,3),'b');
hold on
plot3(totx1(:,1),totx1(:,2),totx1(:,3),'r');
plot3(xstar(1,end),xstar(2,end),xstar(3,end),'xk')
grid on
box on


figure()
plot3(totx(:,4),totx(:,5),totx(:,6),'b');
hold on
plot3(totx1(:,4),totx1(:,5),totx1(:,6),'r');
plot3(xstar(4,end),xstar(5,end),xstar(6,end),'xk')
grid on
box on