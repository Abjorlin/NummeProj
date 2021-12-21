function [xlist,ylist,fel,x_vellist,y_vellist] = RK4(angle,stepsize,headwind,startvelocity,desired_lp,interference)
    
    %VARIABLER
    phi = angle;
    h = stepsize;
    t0 = 0;
    x0 = 0;
    y0 = 1.6;
    fel = 0;
    
    v = headwind;
    m = 0.860;
    g = 9.81;
    k_x = 0.033;
    k_y = 0.074;
    

    
    % Störning av variabler
    switch interference
        case 0
            
        case 1
            m = m*0.99;
        case 2
            g = g*0.99;
        case 3
            k_x = k_x*0.99;
        case 4
            k_y = k_y*0.99;
        case 5
            startvelocity = startvelocity*0.99;
    end

    x_vel = startvelocity * cos(phi);
    y_vel = startvelocity * sin(phi);
    
    xlist = (x0);
    ylist = (y0);
    x_vellist = (x_vel);
    y_vellist = (y_vel);
    tlist = (t0);
    
    
    for i = 0:4/h
        
        V = @(x_vel, y_vel) sqrt((x_vel + v)^2+(y_vel)^2);

        % x - System
        x = @(t0,x_vel,x0) x_vel;
        x_dot = @(t0,x_vel,x0) -(k_x/m)*(x_vel + v)*V(x_vel,y_vel);

        % y - System
        y = @(t0,y_vel,y0) y_vel;
        y_dot = @(t0,y_vel,y0) -g - (k_y/m)*y_vel*V(x_vel,y_vel);

        % Runge-Kutta
        % x
        xk1 = x(t0, x_vel, x0);
        xk2 = x(t0 + (h/2), x_vel + ((xk1*h)/2), x0 + ((xk1*h)/2));
        xk3 = x(t0 + (h/2), x_vel + ((xk2*h)/2), x0 + ((xk2*h)/2));
        xk4 = x(t0 + h, x_vel + h*xk3, x0 + h*xk3);

        xK = (xk1 + 2*xk2 + 2*xk3 + xk4)/6;

        % x_dot
        x_dotk1 = x_dot(t0, x_vel, x0);
        x_dotk2 = x_dot(t0 + (h/2), x_vel + ((x_dotk1*h)/2), x0 + ((x_dotk1*h)/2));
        x_dotk3 = x_dot(t0 + (h/2), x_vel + ((x_dotk2*h)/2), x0 + ((x_dotk2*h)/2));
        x_dotk4 = x_dot(t0 + h, x_vel + h*x_dotk3, x0 + h*x_dotk3);

        x_dotK = (x_dotk1 + 2*x_dotk2 + 2*x_dotk3 + x_dotk4)/6;


        % y
        yk1 = y(t0, y_vel, y0);
        yk2 = y(t0 + (h/2), y_vel + ((yk1*h)/2), y0 + ((yk1*h)/2));
        yk3 = y(t0 + (h/2), y_vel + ((yk2*h)/2), y0 + ((yk2*h)/2));
        yk4 = y(t0 + h, y_vel + h*yk3, y0 + h*yk3);

        yK = (yk1 + 2*yk2 + 2*yk3 + yk4)/6;

        % y_dot
        y_dotk1 = y_dot(t0, y_vel, y0);
        y_dotk2 = y_dot(t0 + (h/2), y_vel + ((y_dotk1*h)/2), y0 + ((y_dotk1*h)/2));
        y_dotk3 = y_dot(t0 + (h/2), y_vel + ((y_dotk2*h)/2), y0 + ((y_dotk2*h)/2));
        y_dotk4 = y_dot(t0 + h, y_vel + h*y_dotk3, y0 + h*y_dotk3);

        y_dotK = (y_dotk1 + 2*y_dotk2 + 2*y_dotk3 + y_dotk4)/6;

        % Skriver över tal och lägger till i listor
        x0 = x0 + h * xK;
        xlist(end+1) = x0;

        x_vel = x_vel + h*x_dotK;
        x_vellist(end+1) = x_vel;

        y0 = y0 + h * yK;
        ylist(end+1) = y0;

        y_vel = y_vel + h*y_dotK;
        y_vellist(end+1) = y_vel;

        t0 = t0 + h;
        tlist(end+1) = t0;

    end
    
    % Söker efter felet till landningspunkten
    for j = 1:i
        if ylist(j) < 0

            x0 = xlist(j-1);
            x1 = xlist(j);
            y0 = ylist(j-1);
            y1 = ylist(j);
            break
        end
         
    end
    
    % linjärinterpolation
    k = (y1-y0)/(x1-x0);
    m = y1-k*x1;
    lp = -m/k;
    fel = lp - desired_lp;
    
end











