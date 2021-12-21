clear all
clf
format long



stepsize = 0.0001;




% KASTSIMULERINGAR---------------------------------------------------

% Stora kastbanan
[xlist,ylist,angle,etrunk,length,len_etrunk,xvel,yvel] = SM(70*pi/180,80*pi/180,stepsize,11,0);

% Lilla kastbanan
[xlist1,ylist1,angle1,etrunk1,length1,len_etrunk1] = SM(10*pi/180,20*pi/180,stepsize,11,0);

% Motvindkastbanan
[xlist2,ylist2,vel,etrunk2,curve_length1,curve_length_error1] = SM_wind(18,19,stepsize,angle,11,0);

% Störningsräkning
total_angle_interference = 0;
total_length_interference = 0;
angle_interference = [];
length_interference = [];
interferences = {'m'; 'g'; 'kx'; 'ky'; 'v';'total'};
for j = 1:5
    
    [sxlist,sylist,sangle,se_trunk,slength,slen_etrunk] = SM(70*pi/180,80*pi/180,stepsize,11,j);
    delta = abs(angle*180/pi - sangle*180/pi);
    delta1 = abs(length - slength);
    angle_interference = [angle_interference; delta];
    length_interference = [length_interference; delta1;];
    total_angle_interference = total_angle_interference + delta;
    total_length_interference = total_length_interference + delta1;
end

% Hermite-interpolation av stora kastbanan
[hxlist,hylist] = HI(xlist,ylist,xvel,yvel);



% PLOTTNING AV KRUVOR-------------------------------------------------

% stora-, lilla- och motvindkastbanan
subplot(3,1,1)
axis([0 16 0 16])
hold on
plot(xlist,ylist,'yellow')
plot(xlist1,ylist1,'blue')
plot(xlist2,ylist2,'green')
hold off

% kast med landningspunkt i varje meter
% subplot(3,1,2)
% axis([0 16 0 16])
% hold on
% distance = [];
% angle0 = [];
% angle_error0 = [];
% curve_length0 = [];
% curve_length_error0 = [];
% 
% for i = 1:11
%     
%     [ixlist,iylist,iangle,ie_trunk,ilength,ilen_etrunk] = SM(70*pi/180,80*pi/180,stepsize,i,0);
%     plot(ixlist,iylist,iangle,ie_trunk,ilength,ilen_etrunk)
%     
%     distance = [distance;i];
%     angle0 = [angle0;iangle*180/pi];
%     angle_error0 = [angle_error0;ie_trunk];
%     curve_length0 = [curve_length0;ilength];
%     curve_length_error0 = [curve_length_error0;ilen_etrunk];
%     
% end
% hold off

% Hermite-interpoleringen
subplot(3,1,3)
plot(hxlist,hylist)
axis([0 16 0 16])


% TABELLER-------------------------------------------------------------

% tabell för ett kast med landningspunkt i varje meter (ej nödvändig)
%T0 = table(distance,angle0,angle_error0,curve_length0,curve_length_error0);

% tabell för stora och lilla vinkeln
throw = {'Large angle'; 'Small angle'};
angle_error = [etrunk; etrunk1;];
angles = [angle*180/pi; angle1*180/pi;];
curve_length = [length; length1];
curve_length_error = [len_etrunk; len_etrunk1];
T = table(throw, angles, angle_error,curve_length,curve_length_error);

% tabell för motvindkastet
throw2 = {'Headwind throw'};
velocity_error = (etrunk2);
velocity = (vel);
T2 = table(throw2, velocity, velocity_error,curve_length1,curve_length_error1);

% tabell för för kast med störningstörning
angle_interference = [angle_interference; total_angle_interference];
length_interference = [length_interference; total_length_interference;];
T3 = table(interferences,angle_interference,length_interference);

% tabell för Hermite-interpolationen
T4 = table(hxlist,hylist);

% disp(T0)
disp(T)
disp(T2)
disp(T3)
disp(T4)













