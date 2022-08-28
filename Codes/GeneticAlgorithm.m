function Y = GeneticAlgorithm(id)
    p = 20; % Population size
    c = 5; % number of pairs of chromosomes to be crossovered
    m = 5; % number chromosomes to be mutated
    tg = 20; % Total number of generations

    P = population(p,id);
    K=0;
    [x1,y1]=size(P);

    for i=1:tg   
        Cr = crossover(P,c);
        Mu = mutation(P,m);
        P(p+1:p+2*c,:) = Cr;
        P(p+2*c+1:p+2*c+m,:) = Mu;
        E = evaluation(P,id);
        [P,S] = selection(P,E,p);
        K(i,1) = sum(S)/p;
        K(i,2) = S(1); % best
    end
    
 minFit = max(K(:,2))
 P2 = P(1,:); % Best chromosome
% Convert binary to real numbers
if id == 1
    nVar = 3; %number of variables for PID
else
    nVar = 5; %number of variables for FOPID
end
Max = 10^2; %defined in population function
Kp = bi2de(P(1,1:y1/nVar)) / Max;
Kd = bi2de(P(1,y1/nVar+1:2*y1/nVar)) / Max;
Ki = bi2de(P(1,2*y1/nVar+1:3*y1/nVar)) / Max;
Kp(Kp > 400) = 400;
Kd(Kd > 400) = 400;
Ki(Ki > 400) = 400;
x = [Kp Kd Ki];
if nVar == 5
    lemda = bi2de(P(1,3*y1/nVar+1:4*y1/nVar+1)) / Max;
    meu = bi2de(P(1,4*y1/nVar+1:5*y1/nVar)) / Max;
    lemda(lemda > 1) = 1;
    meu(meu > 1) = 1;
    x = [x lemda meu];
end

Y = x;

end

function Y = population(n,id)
    maxValue = 400;
    minValue = 0;
    p = 2;  % number of digits after decimals
    m = ceil((log((maxValue - minValue)*10^p))/(log(2)));
     
    i = 1;
    while i<=n
        if id == 1 
           lb = [minValue minValue minValue];
           ub = [maxValue maxValue maxValue];
           x = lb+(ub-lb).*rand(1,3);
           x = round(x*100);
           P(i,:) = [de2bi(x(1,1),m) de2bi(x(1,2),m) de2bi(x(1,3),m)];
        elseif id == 2
           lb = [minValue minValue minValue 0 0];
           ub = [maxValue maxValue maxValue 1 1];
           x = lb+(ub-lb).*rand(1,5);
           x = round(x*100);
           P(i,:) = [de2bi(x(1,1),m) de2bi(x(1,2),m) de2bi(x(1,3),m) de2bi(x(1,4),m) de2bi(x(1,5),m)];
        else
           lb = [minValue minValue minValue 0 0];
           ub = [maxValue maxValue maxValue 1 1];
           x = lb+(ub-lb).*rand(1,3);
           x = round(x*100);
           P(i,:) = [de2bi(x(1,1),m) de2bi(x(1,2),m) de2bi(x(1,3),m)];
        end
        i = i+1;
    end
     Y = P;
end

function Y = crossover(P,c)
    [x1,y1]=size(P);
    Z=zeros(2*c,y1); 
    for i = 1:c
        r1 = randi(x1,1,2);
        while r1(1) == r1(2)
            r1 = randi(x1,1,2);
        end
        A1 = P(r1(1),:); % parent 1
        A2 = P(r1(2),:); % parent 2
        r2 = 1 + randi(y1-1); % random cutting point
        B1 = A1(1,r2:y1);
        A1(1,r2:y1) = A2(1,r2:y1);
        A2(1,r2:y1) = B1;
        Z(2*i-1,:) = A1; % child 1
        Z(2*i,:) = A2; % child 2
    end
    Y=Z;
end

function Y = mutation(P,m)
[x1,y1]=size(P);
Z=zeros(m,y1);
for i = 1:m
    r1 = randi(x1);
    A1 = P(r1,:); % random parent
    r2 = randi(y1);
    if A1(1,r2) == 1
        A1(1,r2) = 0; % flick the bit
    else
        A1(1,r2) = 1;
    end
    Z(i,:)=A1;
end
Y=Z;
end

function Y = evaluation(P,id)
    [x1,y1]=size(P);
    H=zeros(1,x1);
    p = 2;
    
    if id == 2
        nVar = 5; %number of variables for FOPID
    else
        nVar = 3; %number of variables for PID and PDA
    end
    for i = 1:x1
        Kp = (bi2de(P(i,1:y1/nVar)) / 10^p);
        Kd = (bi2de(P(i,y1/nVar+1:2*y1/nVar)) / 10^p);
        Ki = (bi2de(P(i,2*y1/nVar+1:3*y1/nVar)) / 10^p);
        Kp(Kp > 400) = 400;
        Kd(Kd > 400) = 400;
        Ki(Ki > 400) = 400;
        
        x = [Kp Kd Ki];
        if id == 2
            lemda = (bi2de(P(i,3*y1/nVar+1:4*y1/nVar)) / 10^p);
            meu = (bi2de(P(i,4*y1/nVar+1:5*y1/nVar)) / 10^p);
            lemda(lemda > 1) = 1;
            meu(meu > 1) = 1;
            x = [x lemda meu];
        end
        [y,time] = Controller(x,id);
        H(1,i)= sum(abs(1-y(11:101)).^2);
    end
    Y=H;
end

function [YY1,YY2] = selection(P,F,p)
[x1,y1] = size(P);
Y1 = zeros(p,y1);
e=3;    % To find out elite members
for i = 1:e
    c1 = find(F == min(F));
    Y1(i,:) = P(min(c1),:); 
    P(min(c1),:) = [];
    Fn(i) = F(min(c1));
    F(:,min(c1)) = [];
end

Dd = max(F) - F; % To reverse the weights of error
D = Dd/sum(Dd); % Determine selection probability
E = cumsum(D); % Determine cumulative probability 
N = rand(1); % Generate a vector constaining normalised random numbers
d1 = 1;
d2 = e;

while d2 <= p-e
    if N <= E(d1)
       Y1(d2+1,:)= P(d1,:); 
       Fn(d2+1) = F(d1);
       N = rand(1);
       d2 = d2 + 1;
       d1 = 1;
     else
        d1 = d1 + 1;
    end
end
YY1 = Y1;
YY2 = Fn;
end
