clear all
close all
clc

load simresults.mat
N = 51;

scrsz = get(0,'ScreenSize');

%%
fig2 = figure(2);
set(fig2,'Position',[0 0 1.1*scrsz(3)/3 2.3*scrsz(4)/3])
subplot(3,1,1)
hold on
plot(Ts*(0:N-1),xd(1,:),'marker','p','color','k','LineWidth',1.2,'LineStyle','None')
plot(Ts*(0:N-1),xd(3,:),'marker','p','color','b','LineWidth',1.2,'LineStyle','None')
dd1 = plot(Ts*(0:N-1),stateStar(1,:),'k-','LineWidth',2);
dd2 = plot(Ts*(0:N-1),stateStar(3,:),'b-','LineWidth',2);
ig1 = plot(Ts*(0:N-1),statecl(1,:),'Color',0.7*[1 1 1],'LineStyle','--','LineWidth',2);
ig2 = plot(Ts*(0:N-1),statecl(3,:),'Color',[0.38 0.69 1],'LineStyle','--','LineWidth',2);

h = legend([ig1 ig2 dd1 dd2],{'$\bar{\xi}_{1_\kappa}$','$\dot{\bar{\xi}}_{1_\kappa}$','$\xi_{1_\kappa}$','$\dot{\xi}_{1_\kappa}$'});
set(h,'Interpreter','Latex','Orientation','vertical','Location','eastoutside','Fontsize',12)

box on;
grid on

ay = gca;
ay.TickLabelInterpreter = 'latex';
set(ay,'FontSize', 11)

xlim([0 5])
ylim([0 8])

xlabel('time [s]','FontSize',12,'Interpreter','latex')
ylabel('$\xi_{1_k}$','FontSize',12,'Interpreter','latex')

subplot(3,1,2)
hold on
plot(Ts*(0:N-1),xd(2,:),'marker','p','color','k','LineWidth',1.2,'LineStyle','None')
plot(Ts*(0:N-1),xd(4,:),'marker','p','color','b','LineWidth',1.2,'LineStyle','None')
dd1 = plot(Ts*(0:N-1),stateStar(2,:),'k-','LineWidth',2);
dd2 = plot(Ts*(0:N-1),stateStar(4,:),'b-','LineWidth',2);
ig1 = plot(Ts*(0:N-1),statecl(2,:),'Color',0.7*[1 1 1],'LineStyle','--','LineWidth',2);
ig2 = plot(Ts*(0:N-1),statecl(4,:),'Color',[0.38 0.69 1],'LineStyle','--','LineWidth',2);

h = legend([ig1 ig2 dd1 dd2],{'$\bar{\xi}_{2_\kappa}$','$\dot{\bar{\xi}}_{2_\kappa}$','$\xi_{2_\kappa}$','$\dot{\xi}_{2_\kappa}$'});
set(h,'Interpreter','Latex','Orientation','vertical','Location','eastoutside','Fontsize',12)
box on;
grid on

ay = gca;
ay.TickLabelInterpreter = 'latex';
set(ay,'FontSize', 11)

xlim([0 5])
ylim([-10 15])

xlabel('time [s]','FontSize',12,'Interpreter','latex')
ylabel('$\xi_{2_k}$','FontSize',12,'Interpreter','latex')

subplot(3,1,3)
hold on
plot(Ts*(0:N-1),xd(3,:),'marker','p','color','k','LineWidth',1.2,'LineStyle','None')
plot(Ts*(0:N-1),xd(6,:),'marker','p','color','b','LineWidth',1.2,'LineStyle','None')
dd1 = plot(Ts*(0:N-1),stateStar(3,:),'k-','LineWidth',2);
dd2 = plot(Ts*(0:N-1),stateStar(6,:),'b-','LineWidth',2);
ig1 = plot(Ts*(0:N-1),statecl(3,:),'Color',0.7*[1 1 1],'LineStyle','--','LineWidth',2);
ig2 = plot(Ts*(0:N-1),statecl(6,:),'Color',[0.38 0.69 1],'LineStyle','--','LineWidth',2);

h = legend([ig1 ig2 dd1 dd2],{'$\bar{\xi}_{3_\kappa}$','$\dot{\bar{\xi}}_{3_\kappa}$','$\xi_{3_\kappa}$','$\dot{\xi}_{3_\kappa}$'});
set(h,'Interpreter','Latex','Orientation','vertical','Location','eastoutside','Fontsize',12)
box on;
grid on

ay = gca;
ay.TickLabelInterpreter = 'latex';
set(ay,'FontSize', 11)

xlim([0 5])
ylim([-10 35])

xlabel('time [s]','FontSize',12,'Interpreter','latex')
ylabel('$\xi_{3_k}$','FontSize',12,'Interpreter','latex')

ScriptForFigToPdfFun(fig2,'fig7',0)


%%
fig3 = figure(3);
set(fig3,'Position',[0 0 1.1*scrsz(3)/3 1.5*scrsz(4)/3])
subplot(2,1,1)
hold on
inpt2 = stairs(Ts*(0:N-1),inputStar(1,:),'k-','LineWidth',2);
inpt1 = stairs(Ts*(0:N-1),inputcl(1,:),'Color',0.7*[1 1 1],'LineStyle','--','LineWidth',2);

h = legend([inpt1 inpt2],'$\bar{\nu}_{1_{\kappa}}$','$\nu_{1_{\kappa}}^\star$');
set(h,'Interpreter','Latex','Orientation','vertical','Location','eastoutside','Fontsize',12) 

box on;
grid on
ay = gca;
ay.TickLabelInterpreter = 'latex';
set(ay,'FontSize', 11)

xlim([0 5])
ylim([-80 150])

xlabel('time [s]','FontSize',12,'Interpreter','latex')
ylabel('$\nu_{1_{\kappa}}$','FontSize',12,'Interpreter','latex')

subplot(2,1,2)
hold on
inpt2 = stairs(Ts*(0:N-1),inputStar(2,:),'k-','LineWidth',2);
inpt1 = stairs(Ts*(0:N-1),inputcl(2,:),'Color',0.7*[1 1 1],'LineStyle','--','LineWidth',2);

h = legend([inpt1 inpt2],'$\bar{\nu}_{2_{\kappa}}$','$\nu_{2_{\kappa}}^\star$');
set(h,'Interpreter','Latex','Orientation','vertical','Location','eastoutside','Fontsize',12) 

box on;
grid on
ay = gca;
ay.TickLabelInterpreter = 'latex';
set(ay,'FontSize', 11)

xlim([0 5])
ylim([-160 360])

xlabel('time [s]','FontSize',12,'Interpreter','latex')
ylabel('$\nu_{2_{\kappa}}$','FontSize',12,'Interpreter','latex')

ScriptForFigToPdfFun(fig3,'fig8',0)
