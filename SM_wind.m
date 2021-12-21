function [og_xlist,og_ylist,og_velocity,etrunk,og_length,len_etrunk] = SM_wind(g1,g2,stepsize,angle,desired_lp,interference)

    velocitylist = [];
    lengthlist = [];
    headwind = 6;
    
    for i = 1:2
        
        k = 1;
        length = 0;
        step = stepsize*i;
        t = 1;

        % starthastighet för sekantmetoden
        x0 = g1;
        x1 = g2;
        fel0 = 0;
        
        % sekantmetoden
        while abs(t) > 1e-5

            [xlist,ylist,fel2] = RK4(angle,step,headwind,x1,desired_lp,interference);
            t = fel2*(x1-x0)/(fel2-fel0);
            x0 = x1;
            fel0 = fel2;
            x1 = x1-t;
            velocity = x1;
            
        end
        
        % Beräknar båglängden
        while ylist(k) >= 0
            
            length = length + sqrt((xlist(k+1) - xlist(k))^2 + (ylist(k+1) - ylist(k))^2);
            k = k + 1;
            
        end
        
        % returnerar listan med korrekta steglängden
        if i == 1
            og_xlist = xlist;
            og_ylist = ylist;
            og_velocity = velocity;
            og_length = length;
        end
        

        
        velocitylist = [velocitylist,velocity];
        lengthlist = [lengthlist,length];
        
    end
  
    etrunk = abs(velocitylist(1)-velocitylist(2));
    len_etrunk = abs(lengthlist(1)-lengthlist(2));

end

