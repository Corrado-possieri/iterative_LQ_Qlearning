clear all
close all
clc

set(groot,'DefaultAxesTickLabelInterpreter','latex');
load simresults.mat 

scrsz = get(0,'ScreenSize');


N = length(xd);

fig = figure('Position',[0 0 1.1*scrsz(3)/3 1.5*scrsz(4)/3]);
s1 = subplot(3,1,1);
plot(Ts*(0:N-1),xd(1,:),'bp')
hold on
box on
grid on
plot(Ts*(0:N-1),xd(4,:),'kp')
plot(Ts*(0:N-1),statecl(1,:),'b','linewidth',2)
plot(Ts*(0:N-1),statecl(4,:),'k','linewidth',2)
plot(Ts*(0:N-1),stateStar(1,:),':','Color',[0.38 0.69 1],'linewidth',2)
plot(Ts*(0:N-1),stateStar(4,:),':','color',[0.7 0.7 0.7],'linewidth',2)
l1 = legend('$x_1^\diamond$','$\dot{x}_1^\diamond$',...
    '$x_1$','$\dot{x}_1$',...
    '$x_1^\star$','$\dot{x}_1^\star$','interpreter','latex',...
    'location','eastoutside','fontsize',12);
set(gca,'YTick',[-5,0,5,10])
set(gca,'XTickLabel',[])
set(gca,'fontsize',12)
ylim([-7,13])

s2 = subplot(3,1,2);
plot(Ts*(0:N-1),xd(2,:),'bp')
hold on
box on
grid on
plot(Ts*(0:N-1),xd(5,:),'kp')
plot(Ts*(0:N-1),statecl(2,:),'b','linewidth',2)
plot(Ts*(0:N-1),statecl(5,:),'k','linewidth',2)
plot(Ts*(0:N-1),stateStar(2,:),':','Color',[0.38 0.69 1],'linewidth',2)
plot(Ts*(0:N-1),stateStar(5,:),':','color',[0.7 0.7 0.7],'linewidth',2)
legend('$x_2^\diamond$','$\dot{x}_2^\diamond$',...
    '$x_2$','$\dot{x}_2$',...
    '$x_2^\star$','$\dot{x}_2^\star$','interpreter','latex',...
    'location','eastoutside','fontsize',12)
set(gca,'XTickLabel',[])
ylim([-3 7])
set(gca,'fontsize',12)

s3 = subplot(3,1,3);
plot(Ts*(0:N-1),xd(3,:),'bp')
hold on
box on
grid on
plot(Ts*(0:N-1),xd(6,:),'kp')
plot(Ts*(0:N-1),statecl(3,:),'b','linewidth',2)
plot(Ts*(0:N-1),statecl(6,:),'k','linewidth',2)
plot(Ts*(0:N-1),stateStar(3,:),':','Color',[0.38 0.69 1],'linewidth',2)
plot(Ts*(0:N-1),stateStar(6,:),':','color',[0.7 0.7 0.7],'linewidth',2)
l3 = legend('$x_3^\diamond$','$\dot{x}_3^\diamond$',...
    '$x_3$','$\dot{x}_3$',...
    '$x_3^\star$','$\dot{x}_3^\star$','interpreter','latex',...
    'location','eastoutside','fontsize',12);
set(gca,'YTick',[0,10,20,30])
xlabel('time\,[$\mathrm{s}$]','interpreter','latex',...
    'fontsize',12)
ylim([-10,34])
set(gca,'fontsize',12)

p1 = get(s1,'Position');
p2 = get(s2,'Position');
p3 = get(s3,'Position');

%%
top = p1(2) + p1(4);
bot = p3(2);
hei = (top-bot)/3;

p1(3) = p3(3);
p2(3) = p3(3);

p3n = p3;
p3n(4) = hei;
p2n = p2;
p2n(2) = hei+bot;
p2n(4) = hei;
p1n = p1;
p1n(2) = 2*hei+bot;
p1n(4) = hei;

set(s1,'Position',p1n);
set(s2,'Position',p2n);
set(s3,'Position',p3n);
%%
pl1 = get(l1,'Position');
pl3 = get(l3,'Position');

npl3 = pl3;
npl3(1) = pl1(1);
npl3(3) = pl1(3);
set(l3,'Position',npl3)

%%
fig2 = figure('Position',[0 0 1.1*scrsz(3)/3 1.2*scrsz(4)/3]);
s1 = subplot(2,1,1);
stairs(Ts*(0:N-1),inputcl(1,:)','b','linewidth',2)
hold on
grid on 
box on
stairs(Ts*(0:N-1),inputStar(1,:)',':','Color',[0.38 0.69 1],'linewidth',2)
set(gca,'XTickLabel',[])
l1 = legend('$u_1$','$u_1^\star$','interpreter','latex',...
    'location','eastoutside','fontsize',12);
set(gca,'YTick',[-50,0,50,100])
set(gca,'fontsize',12)
ylim([-70,130])

s2 = subplot(2,1,2);
stairs(Ts*(0:N-1),inputcl(2,:)','b','linewidth',2)
hold on
grid on 
box on
stairs(Ts*(0:N-1),inputStar(2,:)',':','Color',[0.38 0.69 1],'linewidth',2)
l2 = legend('$u_2$','$u_2^\star$','interpreter','latex',...
    'location','eastoutside','fontsize',12);
set(gca,'YTick',[-100,0,100,200,300])
xlabel('time\,[$\mathrm{s}$]','interpreter','latex',...
    'fontsize',12)
set(gca,'fontsize',12)

p1 = get(s1,'Position');
p2 = get(s2,'Position');

%%
p1(3) = p2(3);

top = p1(2) + p1(4);
bot = p2(2);
hei = (top-bot)/2;

p2n = p2;
p2n(2) = bot;
p2n(4) = hei;
p1n = p1;
p1n(2) = hei+bot;
p1n(4) = hei;

set(s1,'Position',p1n);
set(s2,'Position',p2n);

pl1 = get(l1,'Position');
pl2 = get(l2,'Position');

npl2 = pl2;
npl2(1) = pl1(1);
npl2(3) = pl1(3);
set(l2,'Position',npl2)

saveas(fig,'fig7.eps','epsc')
saveas(fig2,'fig8.eps','epsc')