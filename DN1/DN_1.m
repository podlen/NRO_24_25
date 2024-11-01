%extract data form naloga1_1.txt

delimiterIn="";
headerlinesIn = 2;
data = importdata("naloga1_1.txt",delimiterIn, headerlinesIn);
t = data.data(); %podatki shranjeni v vektor

%2. del shrani podatke brez uporabe importdata

fid = fopen("naloga1_2.txt", "r");

first_line = fgetl(fid);
text_num = strsplit(first_line, ": ");
num_str = text_num(2);
num = str2double(num_str);

P = zeros(0, num);
for i = 1:1:num
    line = fgetl(fid);
    P(i) = str2double(line);
end

%graf P(t)

plot(t, P)
title ("graf P(t)")
xlabel("t[s]")
ylabel("P[W]")



% 3. naloga - izracun integala

test_result = trapz(t, P);


result = 0;
for i = 1:1:(num-1)
    dt = t(i+1) - t(i); 
    s = dt/2 * (P(i) + P(i+1));
    result = result + s;
end

diff = result - test_result;


