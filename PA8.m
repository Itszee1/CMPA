
%Given Parameters
Is = 0.01e-12; %Forward Bias Saturation Current (A)
Ib = 0.1e-12; %Breakdown Saturation Current (A)
Vb = 1.3; %Breakdown Voltage (V)
Gp1 = 0.1; % Parasitic Parallel Conductance(Ω−1)


%PART 1
V = linspace(-1.95,0.7,200);   %V vector creation

ID = (Is*(exp(V*1.2/0.025)-1)) + (Gp1*V) - (Ib*(exp(-1.2*(V+Vb)/0.025)-1));

randvector = (1.2-0.5).*rand(size(ID)) + 0.5;

newI = randvector.*ID;

figure(1)
subplot(2,1,1)
plot(V,ID,V,newI)
title('Plot of vector V and I')

subplot(2,1,2)
semilogy(V,abs(ID),V,abs(newI))

%PART 2
P4 = polyfit(V,ID,4); %4th Order Polynomial
Po4 = polyval(P4,V); 

P8 = polyfit(V,ID,8); %8th Order Polynomial 
Po8 = polyval(P8,V);

figure(2)
subplot(2,2,1)
plot(V,ID,'b',V,Po4,'y')

subplot(2,2,2)
plot(V,ID,'b',V,Po8,'y')

po4 = polyfit(V,newI,4); 
a = polyval(po4,V);
subplot(2,2,3)
semilogy(V,abs(ID),'b',V,abs(a),'y')


pol8 = polyfit(V,newI,8);
b = polyval(pol8,V);
subplot(2,2,4)
semilogy(V,abs(ID),'b',V,abs(b),'y')

%PART 3 
fo1 = fittype('A*(exp(1.2*x/0.025)-1) + (0.1*x) - (C*(exp(-1.2*(x+1.3)/0.025)-1))');
ff1 = fit(V',ID',fo1);
If1 = ff1(V);

figure(3)
subplot(3,1,1)
semilogy(V,abs(If1'),'b',V,abs(newI),'y')

fo2 = fittype('A*(exp(1.2*x/0.025)-1) + (B*x) - (C*(exp(-1.2*(x+1.3)/0.025)-1))');
ff2 = fit(V',ID',fo2);
If2 = ff2(V);

subplot(3,1,2)
semilogy(V,abs(If2'),'b',V,abs(newI),'y')

fo3 = fittype('A*(exp(1.2*x/0.025)-1) + (B*x) - (C*(exp(-1.2*(x+D)/0.025)-1))');
ff3 = fit(V',ID',fo3);
If3 = ff3(V);

subplot(3,1,3)
semilogy(V,abs(If3'),'b',V,abs(newI),'y')

%PART 4 
inputs = V.';
targets = ID.';
LayerSize = 10;
net = fitnet(LayerSize); 
net.divideParam.trainRatio = 70/100; 
net.divideParam.valRatio = 15/100; 
net.divideParam.testRatio = 15/100; 
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets); 
performance = perform(net,targets,outputs); 
view(net)
Inn = outputs;

figure(4)
plot(inputs,Inn,'b',inputs,newI,'y')