% Метод случайного баланса - ранжирование факторов

clear
global m n a

X=[157.1 0.05 0.27 0.66 0.062 0.65;
    52.3 0.31 0.12 -0.96 0.025 0.41];
B=[1  1  1 -1  1 -1;
  -1  1  1  1  1  1;
   1 -1  1  1  1 -1;
  -1 -1  1  1 -1 -1;
   1  1 -1  1 -1  1;
  -1  1 -1 -1 -1 -1;
   1 -1 -1 -1  1  1;
  -1 -1 -1 -1 -1  1;
   1 -1  1 -1 -1 -1;
   1 -1 -1  1 -1 -1];

a=0.95; % уровень доверительной вероятности
m=length(B(:,1)); %количество строк В
n=length(B(1,:)); %количество столбцов В

% Определение численных значений целевой функции Y и вывод их на экран

for i=1:m
    for j=1:n
        switch B(i, j)
            case 1
                M(i,j)=X(1,j);
            case -1
                M(i,j)=X(2,j);
        end
    end
end

for i=1:length(M(:, 1))
    X=M(i, :);
    Y(i, 1)=(X(1)*(X(5)*cos(X(2))+X(3)*cos(X(2)+X(4)))*X(3)*X(1)*cos(X(2)+X(4))+X(6)*(1-sin(X(2))))/(X(1)*X(3)*(1+sin(X(2)))*cos(X(2)+X(4))+X(6)*(cos(X(2)))^2);
end

%Расчет медианы каждого фактора

[idx, Eff1, Eff2]=fun(B, Y)

%1 Корректировка значений целевой функции с учетом влияния эффектов факторов

for i=1:m
    if B(i, idx(1))==1 && B(i, idx(2))==1
        Yk(i)=Y(i)-Eff1-Eff2;
    elseif B(i, idx(1))==1 && B(i, idx(2))==-1
        Yk(i)=Y(i)-Eff1;
    elseif B(i, idx(1))==-1 && B(i, idx(2))==1
        Yk(i)=Y(i)-Eff2;
    else
        Yk(i)=Y(i);
    end
end

Yk=Yk'

%Расчет медианы каждого фактора c учетом отброшенных первых двух значимых
%факторов
%Определение 3 и 4 фактора 
[idx2, Effk1, Effk2]=fun(B, Yk)

%Определение 5 и 6 фактора 
[Effk3, Effk4]=effun(B, Yk, idx2)

%Построение диаграммы распределения факторов в заисимости от величины
%эффектов

b=abs([Eff1, Eff2, Effk1, Effk2, Effk3, Effk4]);
x=[idx(1), idx(2), idx2(1), idx2(2), idx2(3), idx2(4)];

figure
for i=1:n
    str_k=['X',num2str(x(i))];
    bar(i, abs(b(i)), 'r' )
    text(i, 0.5+b(i), str_k, 'FontSize', 10)
    hold on;
    grid on;
    %set(gca,'XTickMode','Auto')
end
title('Диаграмма распределения факторов в зависимости от величины эффекта') 
xlabel('Факторы')
ylabel('Величина эффектов факторов')


                %Функции расчета:

function [idx, Eff1, Eff2]=fun(B, Y)
%Расчет медианы каждого фактора
global n m a

figure
for j=1:n
    A1=[]; A2=[];
    for i=1:m
        if B(i, j)==1
            A1(end+1)=Y(i);
            
        else
            A2(end+1)=Y(i);
        end
    end
    A(j)=abs(mean(A1)-mean(A2)); %вычисление медианы каждого j фактора

    subplot(2,1,1) 
    plot(j-0.2, A1, 'ok', j-0.2, mean(A1), '>r', j+0.2, mean(A2), '<k', j+0.2, A2, 'or');
    %MarkerSize=15; %Размер узлов-маркеров
    xtickformat('X%,.0f')
    hold on;   grid on;
        
    subplot(2,1,2) 
    bar(j, A(j), 'b' )
    set(gca,'XTickMode','Auto')
    xtickformat('X%,.0f')
    hold on;  grid on;
   
end

subplot(2,1,1)
title('Диаграмма рассеивания результатов опыта по уровням факторов') 
xlabel('Факторы')
ylabel('Целевая функция Y')
xlim([0.2 n+0.8])

subplot(2,1,2)
title('Диаграмма распределения эффектов') 
xlabel('Факторы')
ylabel('Величина эффектов')
xlim([0.2 n+0.8])

hold off

% Выделение двух факторов наибольших по влиянию (по медиане)
[~, idx]=sort(A,'descend');

Tab1=[]; Tab2=[]; Tab3=[]; Tab4=[];

for i=1:m
    if B(i, idx(1))==1 && B(i, idx(2))==1
        Tab1(end+1)=Y(i);
    elseif B(i, idx(1))==-1 && B(i, idx(2))==1
        Tab2(end+1)=Y(i);
    elseif B(i, idx(1))==1 && B(i, idx(2))==-1
        Tab3(end+1)=Y(i);
    else 
        Tab4(end+1)=Y(i);
    end
end
%Вычисление эффектов факторов
Eff1=(mean(Tab1)+mean(Tab3))/2-(mean(Tab2)+mean(Tab4))/2;
Eff2=(mean(Tab1)+mean(Tab2))/2-(mean(Tab3)+mean(Tab4))/2;

        %Проверка значимости факторов по критерию Стьюдента

%Вычисление среднеквадратической ошибки Sr 
Tab=Tab1;
c=length(Tab); 
Sr(1, 1)=(sum(Tab.^2)/(c-1)-((sum(Tab)^2)/(c*(c-1))))/c;

Tab=Tab2;
c=length(Tab);
Sr(2, 1)=(sum(Tab.^2)/(c-1)-((sum(Tab)^2)/(c*(c-1))))/c;

Tab=Tab3;
c=length(Tab);
Sr(3, 1)=(sum(Tab.^2)/(c-1)-((sum(Tab)^2)/(c*(c-1))))/c;    

Tab=Tab4;
c=length(Tab);
Sr(4, 1)=(sum(Tab.^2)/(c-1)-((sum(Tab)^2)/(c*(c-1))))/c;

%Расчетное значение критерия Стьюдента для 1 и 2 значимого  фактора
t1=((mean(Tab1)+mean(Tab3))-(mean(Tab2)+mean(Tab4)))/sqrt(sum(Sr));
t2=((mean(Tab1)+mean(Tab2))-(mean(Tab3)+mean(Tab4)))/sqrt(sum(Sr));

%Вычисление числа степени свободы
f=length([Tab1 Tab2 Tab3 Tab4])-4; % где 4 - число клеток в таблице 3

%Tабличное значение критерия Стьюдента
ts=tinv((1+a)/2, f); 

%Вывод на экран результатов проверки значимости факторов
if abs(t1)>abs(ts) 
    fprintf('Фактор X%d значим при доверительной вероятности %.2f \n', idx(1), a)
    fprintf('т.к. tрасч=|%f|> tтеор=%f \n', t1, ts)
else
    fprintf('Фактор X%d незначим при доверительной вероятности %.2f \n', idx(1), a)
    fprintf('т.к. tрасч=|%f| < tтеор=%f \n', t1, ts)
end

if abs(t2)>abs(ts)
    fprintf('Фактор X%d значим при доверительной вероятности %.2f \n', idx(2), a)
    fprintf('т.к. tрасч=|%f| > tтеор=%f \n', t2, ts)
else
    fprintf('Фактор X%d незначим при доверительной вероятности %.2f \n', idx(2), a)
    fprintf('т.к. tрасч=|%f| < tтеор=%f \n', t2, ts)
end

end

function [Eff3, Eff4]=effun(B, Yk, idx2)
%Вычисление эффектов 5 и 6 факторов

global m
Tab1=[]; Tab2=[]; Tab3=[]; Tab4=[];

for i=1:m
    if B(i, idx2(3))==1 && B(i, idx2(4))==1
        Tab1(end+1)=Yk(i);
    elseif B(i, idx2(3))==-1 && B(i, idx2(4))==1
        Tab2(end+1)=Yk(i);
    elseif B(i, idx2(3))==1 && B(i, idx2(4))==-1
        Tab3(end+1)=Yk(i);
    else 
        Tab4(end+1)=Yk(i);
    end
end
%Вычисление эффектов факторов
Eff3=(mean(Tab1)+mean(Tab3))/2-(mean(Tab2)+mean(Tab4))/2;
Eff4=(mean(Tab1)+mean(Tab2))/2-(mean(Tab3)+mean(Tab4))/2;
end