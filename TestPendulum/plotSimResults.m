clear all
close all
clc

load simPendulum.mat

figure()
semilogy(Icost)

xfin = x0;
tott = [];
totx = [];
tend = 0;
baseLine = IBaseline{1};
N = size(baseLine,1);
n = length(x0);
for k = 1:N-1
    ustar = Iu{1};
    odefun = @(t,x) odePendulum(t,x,ustar(:,k));
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

xfin = x0;
tott = [];
totx = [];
tend = 0;
baseLine = IBaseline{end};
N = size(baseLine,1);
n = length(x0);
for k = 1:N-1
    ustar = Iu{end};
    odefun = @(t,x) odePendulum(t,x,ustar(:,k));
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