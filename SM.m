function [og_xlist,og_ylist,og_angle,etrunk,og_length,len_etrunk,og_xvel,og_yvel] = SM(g1,g2,stepsize,desired_lp,interference)

    anglelist = [];
    lengthlist = [];
    headwind = 0;
    
    
    for i = 1:2
        
        k = 1;
        length = 0;
        step = stepsize*i;
        t = 1;

        % startvinklar för sekantmetoden
        x0 = g1;
        x1 = g2;
        fel0 = 0;
        
        % sekantmetoden
        while abs(t) > 1e-5

            [xlist,ylist,fel2,xvel,yvel] = RK4(x1,step,headwind,17,desired_lp,interference);
            t = fel2*(x1-x0)/(fel2-fel0);
            x0 = x1;
            fel0 = fel2;
            x1 = x1-t;
            angle = x1;
            
        end

        % Beräknar båglängden
        while ylist(k) >= 0
            
            length = length + sqrt((xlist(k+1) - xlist(k))^2 + (ylist(k+1) - ylist(k))^2);
            k = k + 1;
            
        end
        
        % returnerar listorna med korrekt steglängden
        if i == 1
            og_xlist = xlist;
            og_ylist = ylist;
            og_xvel = xvel;
            og_yvel = yvel;
            og_angle = angle;
            og_length = length;
        end

        anglelist = [anglelist,angle];
        lengthlist = [lengthlist,length];
        
    end
  
    etrunk = abs(anglelist(1)-anglelist(2));
    len_etrunk = abs(lengthlist(1)-lengthlist(2));
    

end

