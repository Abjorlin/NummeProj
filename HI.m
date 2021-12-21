function [hxlist,hylist] = HI(xlist,ylist,x_vellist,y_vellist)

    
    
    % Hermite_interpolation
    
    hxlist = [];
    hylist = [];

    for k = 0:11
        m = 1;
        while xlist(m) <= k
            m = m + 1;
        end
 
        hi = xlist(m+1) - xlist(m);
        delta_y = ylist(m+1) - ylist(m);
        gi = hi*y_vellist(m)/x_vellist(m) - delta_y;
        ci = 2*delta_y - hi*(y_vellist(m)/x_vellist(m) + y_vellist(m+1)/x_vellist(m+1));
        t = (k - xlist(m))/hi;

        x2 = k;
        y2 = ylist(m) + t*delta_y + t*(1-t)*gi + t^2*(1-t)*ci;

        hxlist = [hxlist;x2];
        hylist = [hylist;y2];

    end
    
end

