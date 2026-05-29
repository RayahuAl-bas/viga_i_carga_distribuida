clc;
clear;
close all;

fprintf('====================================================\n');
fprintf(' ANÁLISE DE VIGA BIAPOIADA - CARGA CONCENTRADA\n');
fprintf('====================================================\n');

% 1. DADOS DA VIGA

L = 6.50;          % Comprimento da viga (m)
P = 3.40;          % Carga concentrada (kN)

% Posição da carga (centro da viga)
a = L/2;
% 2. REAÇÕES DE APOIO

RA = P/2;
RB = P/2;

fprintf('\nREAÇÕES DE APOIO:\n');
fprintf('RA = %.3f kN\n',RA);
fprintf('RB = %.3f kN\n',RB);


% 3. MÉTODO DAS SEÇÕES
x = linspace(0,L,1000);
% Vetores
V = zeros(size(x));
M = zeros(size(x));

for i = 1:length(x)
    % TRECHO 1 -> antes da carga
    if x(i) < a

        V(i) = RA;

        M(i) = RA*x(i);
    % TRECHO 2 -> depois da carga
    else

        V(i) = RA - P;

        M(i) = RA*x(i) - P*(x(i)-a);

    end
end

% 4. MOMENTO FLETOR MÁXIMO

[Mmax,indice] = max(M);

x_Mmax = x(indice);

fprintf('\nMOMENTO FLETOR MÁXIMO:\n');
fprintf('Mmax = %.3f kN.m\n',Mmax);
fprintf('Posição = %.3f m\n',x_Mmax);

% 5. MOMENTO DE INÉRCIA DA VIGA
% PERFIL TEÓRICO W460x52

bf = 0.152;     % largura da mesa (m)
tf = 0.0108;    % espessura da mesa (m)
tw = 0.0076;    % espessura da alma (m)
h  = 0.45;      % altura total (m)

% Altura útil da alma
hw = h - 2*tf;

% MOMENTO DE INÉRCIA DA ALMA
% ------------------------------------------------------

I_alma = (tw * hw^3)/12;

% ------------------------------------------------------
% MOMENTO DE INÉRCIA DAS MESAS
% ------------------------------------------------------

d = (h/2) - (tf/2);

I_mesa = (bf*tf^3)/12 + (bf*tf)*(d^2);

% Duas mesas
I_total = I_alma + 2*I_mesa;

fprintf('\nMOMENTO DE INÉRCIA:\n');
fprintf('Ix = %.8f m^4\n',I_total);

%% =====================================================
% 6. TENSÃO NORMAL MÁXIMA
% ======================================================

c = h/2;

% Converte kN.m para N.m
Mmax_Nm = Mmax * 1000;

sigma_max = (Mmax_Nm * c)/I_total;

fprintf('\nTENSÃO NORMAL MÁXIMA:\n');
fprintf('sigma_max = %.2f MPa\n',sigma_max/1e6);


% 7. DIAGRAMA DE FORÇA CORTANTE


figure('Name','Diagramas da Viga','Position',[100 100 900 700]);

subplot(2,1,1)

plot(x,V,'b','LineWidth',2);
hold on;

area(x,V,'FaceColor',[0.5 0.7 1], ...
         'FaceAlpha',0.3);

yline(0,'k','LineWidth',1);

grid on;

title('Diagrama de Força Cortante V(x)','FontSize',12);
xlabel('Posição x (m)','FontWeight','bold');
ylabel('V(x) [kN]','FontWeight','bold');

%% =====================================================
% 8. DIAGRAMA DE MOMENTO FLETOR
% ======================================================

subplot(2,1,2)

plot(x,M,'r','LineWidth',2);
hold on;

area(x,M,'FaceColor',[1 0.5 0.5], ...
         'FaceAlpha',0.3);

plot(x_Mmax,Mmax,'ko','MarkerFaceColor','k');

text(x_Mmax,Mmax,...
    sprintf('  M_{max}=%.2f kN.m',Mmax),...
    'FontSize',10);

yline(0,'k','LineWidth',1);

grid on;

title('Diagrama de Momento Fletor M(x)','FontSize',12);
xlabel('Posição x (m)','FontWeight','bold');
ylabel('M(x) [kN.m]','FontWeight','bold');

%% =====================================================
% 9. DESENHO DA VIGA
% ======================================================

figure('Name','Modelo da Viga','Position',[200 200 1000 250]);

hold on;
grid on;

% Viga
plot([0 L],[0 0],'Color',[0.4 0.4 0.4],'LineWidth',4);

% Apoios
plot(0,0,'g^','MarkerSize',12,'MarkerFaceColor','g');
plot(L,0,'g^','MarkerSize',12,'MarkerFaceColor','g');

% ------------------------------------------------------
% CARGA CONCENTRADA
% ------------------------------------------------------

quiver(a,0.45,0,-0.35,...
    'b','LineWidth',2,...
    'MaxHeadSize',1);

text(a,0.52,...
    sprintf('P = %.2f kN',P),...
    'HorizontalAlignment','center',...
    'FontSize',12,...
    'Color','b');

% ------------------------------------------------------
% REAÇÕES
% ------------------------------------------------------

quiver(0,-0.35,0,0.25,...
    'r','LineWidth',2,...
    'MaxHeadSize',0.7);

quiver(L,-0.35,0,0.25,...
    'r','LineWidth',2,...
    'MaxHeadSize',0.7);

text(0,-0.45,...
    sprintf('RA = %.2f kN',RA),...
    'Color','r');

text(L-0.7,-0.45,...
    sprintf('RB = %.2f kN',RB),...
    'Color','r');

title('Viga Biapoiada com Carga Concentrada');

xlabel('Comprimento da Viga (m)');

ylim([-0.7 0.7]);

axis equal;

hold off;

fprintf('\n====================================================\n');
fprintf(' PROCESSAMENTO CONCLUÍDO COM SUCESSO!\n');
fprintf('====================================================\n\n');