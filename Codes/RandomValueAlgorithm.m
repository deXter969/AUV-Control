function Y = RandomValueAlgorithm(id)
    % Optimization
    MaxIter=100;
    ik=1;
    minFit = inf;

    while(ik<=MaxIter)
       if(id==1) 
           lb = [0 0 0];
           ub = [400 400 400];
           x = lb+(ub-lb).*rand(1,3);
       elseif id == 2
           lb = [0 0 0 0 0];
           ub = [400 400 400 1 1];
           x = lb+(ub-lb).*rand(1,5); 
       else
           lb = [0 0 0];
           ub = [400 400 400];
           x = lb+(ub-lb).*rand(1,3);
       end
       fit = fitnessPID(x,id);
       if(fit <= minFit)
           minFit = fit;
           optimalX = x;
       end

       ik=ik+1;
    end
    minFit
    Y = optimalX;
end

function fit = fitnessPID(x,id)
      [y,time] = Controller(x,id);
      fit = sum(abs(1-y(11:101)).^2);
end