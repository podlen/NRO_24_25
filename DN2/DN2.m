clc;
clear all;

% uvoz podatkov

x_iskana = 0.403;
y_iskana = 0.503;

data = readmatrix("vozlisca_temperature_dn2.txt", "NumHeaderLines",4);
x = data(:,1);
y = data(:,2);
T = data(:,3);

cells = readmatrix("celice_dn2.txt", "NumHeaderLines",2);

%graf
figure;
scatter(x,y,10,T, "filled");
colorbar;
hold on;
plot(x_iskana,y_iskana, "ro");

%uporaba scatteredInterpolant
tic;
F1 = scatteredInterpolant(x,y,T, "linear");
T1 = F1(x_iskana,y_iskana);
time1 = toc;

%uporaba griddedInterpolant
x_unique = unique(x);
y_unique = unique(y);
[X,Y] = ndgrid(x_unique, y_unique); 
Tr = reshape(T, length(x_unique), length(y_unique));
tic;
F2 = griddedInterpolant(X,Y,Tr, "linear");
T2 = F2(x_iskana, y_iskana); 
time2 = toc;


%lastna metoda - bilinearna interpolacija

tic;
%iskanje celice v kateri je podatek
for i = 1:size(cells,1)
    % get cell id
    pt1 = cells(i,1);
    pt2 = cells(i,2);
    pt3 = cells(i,3);
    pt4 = cells(i,4);

    %x,y,T v točkah
    x1 = x(pt1);
    y1 = y(pt1);
    T11 = T(pt1);

    x2 = x(pt2);
    y2 = y(pt2);
    T21 = T(pt2);

    x3 = x(pt3);
    y3 = y(pt3);
    T22 = T(pt3);

    x4 = x(pt4);
    y4 = y(pt4);
    T12 = T(pt4);

    % check if point in cell
    if x_iskana >= x1 && x_iskana <= x2 && y_iskana >= y1 && y_iskana <= y3
        K1 = (x2 - x_iskana)/(x2 - x1)*T11 + (x_iskana - x1)/(x2-x1)*T21;
        K2 = (x2 - x_iskana)/(x2 - x1)*T12 + (x_iskana - x1)/(x2-x1)*T22;
        T3 = (y3 - y_iskana)/(y3-y1)*K1 + (y_iskana - y1)/(y3 - y1)*K2;
        break;
    end
    
end
time3 = toc;

%največja temperatura:

T_max = max(T);
index = find(T==T_max);
x_max = x(index);
y_max = y(index);


%primerjava rezultatov

fprintf("\nPrimerjava metod:\n");
fprintf("Metoda                       Temperatura[°C]       Čas[s]\n");
fprintf("-----------------------------------------------------------\n");
fprintf("scatteredInterpolant          %.5f             %.5f\n", T1, time1);
fprintf("griddedInterpolant            %.5f             %.5f\n", T2, time2);
fprintf("Bilinearna aproksimacija      %.5f             %.5f\n\n\n", T3, time3);
fprintf("Najvišja temperatura je %.3f °C v točki (%.2f , %.2f)\n", T_max, x_max, y_max);



