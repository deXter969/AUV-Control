function [Y,time] = Controller(x,id)
    s = tf('s');       
    G = tf([1.9 2.8],[1 4.5 3.5 -2.8]);
    t = (0:.01:1);
    Kp = x(1); Kd = x(2); Ki = x(3);
    
    if id == 1
        C = pid(Kp, Ki, Kd);
        T = feedback(C*G,1);
    elseif id == 2
        lemda = x(4); meu = x(5);
        [C,CTRLTYPE] = fracpid(Kp, Ki, lemda, Kd, meu);
        T = feedback(C*G,1);
    else
        Ka = Ki;
        C = Kp + Kd*s + Ka*s^2;
        T = feedback(C*G,1);
    end
    
    [Y,time] = step(T,t);
end