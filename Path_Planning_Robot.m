%% Path planning Robot Arm
clc
clear all
close all

t1 = 0;
t2 = 8;
t3 = 16;
t4 = 24;
t5 = 32;

x = [2000 2000 1600 1600 2000];
y = [500 -500 500 0 500];
z = [1600 1600 900 900 1600];
t = [t1 t2 t3 t4 t5];

AA = zeros(18,18);
BB = zeros(18,3);

AA(1,1:5) = F4(t(1)); BB(1,1) = x(1); BB(1,2) = y(1); BB(1,3) = z(1);

AA(2,1:5) = F4Dot(t(1));

AA(3,1:5) = F4DDot(t(1));

AA(4,1:5) = F4(t(2)); BB(4,1) = x(2); BB(4,2) = y(2); BB(4,3) = z(2);

AA(5,1:5) = F4(t(2)); AA(5,6:9) = -F3(t(2));

AA(6,1:5) = F4Dot(t(2)); AA(6,6:9) = -F3Dot(t(2));

AA(7,1:5) = F4DDot(t(2)); AA(7,6:9) = -F3DDot(t(2));

AA(8,6:9) = F3(t(3)); BB(8,1) = x(3); BB(8,2) = y(3); BB(8,3) = z(3);

AA(9,6:9) = F3(t(3)); AA(9,10:13) = -F3(t(3));

AA(10,6:9) = F3Dot(t(3)); AA(10,10:13) = -F3Dot(t(3));

AA(11,6:9) = F3DDot(t(3)); AA(11,10:13) = -F3DDot(t(3));

AA(12,10:13) = F3(t(4)); BB(12,1) = x(4); BB(12,2) = y(4); BB(12,3) = z(4);

AA(13,10:13) = F3(t(4)); AA(13,14:18) = -F4(t(4));

AA(14,10:13) = F3Dot(t(4)); AA(14,14:18) = -F4Dot(t(4));

AA(15,10:13) = F3DDot(t(4)); AA(15,14:18) = -F4DDot(t(4));

AA(16,14:18) = F4(t(5)); BB(16,1) = x(5); BB(16,2) = y(5); BB(16,3) = z(5);

AA(17,14:18) = F4Dot(t(5));

AA(18,14:18) = F4DDot(t(5));

coeff = AA\BB;

aX = coeff(1:5,1);   bX = coeff(6:9,1);   cX = coeff(10:13,1);   dX = coeff(14:18,1);
aY = coeff(1:5,2);   bY = coeff(6:9,2);   cY = coeff(10:13,2);   dY = coeff(14:18,2);
aZ = coeff(1:5,3);   bZ = coeff(6:9,3);   cZ = coeff(10:13,3);   dZ = coeff(14:18,3);

tsamp1 = linspace(t(1),t(2),100);
tsamp2 = linspace(t(2),t(3),100);
tsamp3 = linspace(t(3),t(4),100);
tsamp4 = linspace(t(4),t(5),100);

%%
for i = 1:length(tsamp1)
    xsamp1(i) = F4(tsamp1(i))*aX;
    vxsamp1(i) = F4Dot(tsamp1(i))*aX;
    axsamp1(i) = F4DDot(tsamp1(i))*aX;
end

for i = 1:length(tsamp2)
    xsamp2(i) = F3(tsamp2(i))*bX;
    vxsamp2(i) = F3Dot(tsamp2(i))*bX;
    axsamp2(i) = F3DDot(tsamp2(i))*bX;
end

for i = 1:length(tsamp3)
    xsamp3(i) = F3(tsamp3(i))*cX;
    vxsamp3(i) = F3Dot(tsamp3(i))*cX;
    axsamp3(i) = F3DDot(tsamp3(i))*cX;
end

for i = 1:length(tsamp4)
    xsamp4(i) = F4(tsamp4(i))*dX;
    vxsamp4(i) = F4Dot(tsamp4(i))*dX;
    axsamp4(i) = F4DDot(tsamp4(i))*dX;
end

%%
for i = 1:length(tsamp1)
    ysamp1(i) = F4(tsamp1(i))*aY;
    vysamp1(i) = F4Dot(tsamp1(i))*aY;
    aysamp1(i) = F4DDot(tsamp1(i))*aY;
end

for i = 1:length(tsamp2)
    ysamp2(i) = F3(tsamp2(i))*bY;
    vysamp2(i) = F3Dot(tsamp2(i))*bY;
    aysamp2(i) = F3DDot(tsamp2(i))*bY;
end

for i = 1:length(tsamp3)
    ysamp3(i) = F3(tsamp3(i))*cY;
    vysamp3(i) = F3Dot(tsamp3(i))*cY;
    aysamp3(i) = F3DDot(tsamp3(i))*cY;
end

for i = 1:length(tsamp4)
    ysamp4(i) = F4(tsamp4(i))*dY;
    vysamp4(i) = F4Dot(tsamp4(i))*dY;
    aysamp4(i) = F4DDot(tsamp4(i))*dY;
end

%%
for i = 1:length(tsamp1)
    zsamp1(i) = F4(tsamp1(i))*aZ;
    vzsamp1(i) = F4Dot(tsamp1(i))*aZ;
    azsamp1(i) = F4DDot(tsamp1(i))*aZ;
end

for i = 1:length(tsamp2)
    zsamp2(i) = F3(tsamp2(i))*bZ;
    vzsamp2(i) = F3Dot(tsamp2(i))*bZ;
    azsamp2(i) = F3DDot(tsamp2(i))*bZ;
end

for i = 1:length(tsamp3)
    zsamp3(i) = F3(tsamp3(i))*cZ;
    vzsamp3(i) = F3Dot(tsamp3(i))*cZ;
    azsamp3(i) = F3DDot(tsamp3(i))*cZ;
end

for i = 1:length(tsamp4)
    zsamp4(i) = F4(tsamp4(i))*dZ;
    vzsamp4(i) = F4Dot(tsamp4(i))*dZ;
    azsamp4(i) = F4DDot(tsamp4(i))*dZ;
end


%%
figure;
plot(t,x,'o')
hold on
plot(tsamp1,xsamp1,'--')
plot(tsamp2,xsamp2,'--')
plot(tsamp3,xsamp3,'--')
plot(tsamp4,xsamp4,'--')
title("x-position vs. time")
xlabel("Time [s]")
ylabel("x-position [mm]")

figure;
plot(tsamp1,vxsamp1,'--')
hold on
plot(tsamp2,vxsamp2,'--')
plot(tsamp3,vxsamp3,'--')
plot(tsamp4,vxsamp4,'--')

plot(tsamp1,axsamp1,'*')
plot(tsamp2,axsamp2,'*')
plot(tsamp3,axsamp3,'*')
plot(tsamp4,axsamp4,'*')
title("x-velocity (--) and x-acceleration (*) vs. time")
xlabel("Time [s]")
ylabel("x-velocity [mm/s] (--) x-acceleration [mm/s^2] (*)")

%%
figure;
plot(t,y,'o')
hold on
plot(tsamp1,ysamp1,'--')
plot(tsamp2,ysamp2,'--')
plot(tsamp3,ysamp3,'--')
plot(tsamp4,ysamp4,'--')
title("y-position vs. time")
xlabel("Time [s]")
ylabel("y-position [mm]")

figure;
plot(tsamp1,vysamp1,'--')
hold on
plot(tsamp2,vysamp2,'--')
plot(tsamp3,vysamp3,'--')
plot(tsamp4,vysamp4,'--')

plot(tsamp1,aysamp1,'*')
plot(tsamp2,aysamp2,'*')
plot(tsamp3,aysamp3,'*')
plot(tsamp4,aysamp4,'*')
title("y-velocity (--) and y-acceleration (*) vs. time")
xlabel("Time [s]")
ylabel("y-velocity [mm/s] (--) y-acceleration [mm/s^2] (*)")

%%
figure;
plot(t,z,'o')
hold on
plot(tsamp1,zsamp1,'--')
plot(tsamp2,zsamp2,'--')
plot(tsamp3,zsamp3,'--')
plot(tsamp4,zsamp4,'--')
title("z-position vs. time")
xlabel("Time [s]")
ylabel("z-position [mm]")

figure;
plot(tsamp1,vzsamp1,'--')
hold on
plot(tsamp2,vzsamp2,'--')
plot(tsamp3,vzsamp3,'--')
plot(tsamp4,vzsamp4,'--')

plot(tsamp1,azsamp1,'*')
plot(tsamp2,azsamp2,'*')
plot(tsamp3,azsamp3,'*')
plot(tsamp4,azsamp4,'*')
title("z-velocity (--) and z-acceleration (*) vs. time")
xlabel("Time [s]")
ylabel("z-velocity [mm/s] (--) z-acceleration [mm/s^2] (*)")

xtraj = [xsamp1 xsamp2 xsamp3 xsamp4];
ytraj = [ysamp1 ysamp2 ysamp3 ysamp4];
ztraj = [zsamp1 zsamp2 zsamp3 zsamp4];

figure;
plot3(xtraj, ytraj, ztraj, 'b-', 'LineWidth', 1.5)
hold on
plot3(x, y, z, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7)

text(x(1), y(1), z(1), ' P1')
text(x(2), y(2), z(2), ' P2')
text(x(3), y(3), z(3), ' P3')
text(x(4), y(4), z(4), ' P4')
text(x(5), y(5), z(5), ' P5')

grid on
xlabel('x [mm]')
ylabel('y [mm]')
zlabel('z [mm]')
title('3D path with waypoints P1-P5')
legend('Trajectory', 'P1-P5', 'Location', 'best')

% Koeffisienter til Simulink
trajCoeff = coeff;

% Tidsgrenser
trajTime = t;

function [out] = F4(t)
out = [1 t t.^2 t.^3 t.^4];
end

function [out] = F4Dot(t)
out = [0 1 2*t 3*t.^2 4*t.^3];
end

function [out] = F4DDot(t)
out = [0 0 2 6*t 12*t.^2];
end

function [out] = F3(t)
out = [1 t t.^2 t.^3];
end

function [out] = F3Dot(t)
out = [0 1 2*t 3*t.^2];
end

function [out] = F3DDot(t)
out = [0 0 2 6*t];
end


% %% Til funksjonsblokken i simuleringen 
% function [x, y, z] = trajectory(t, trajCoeff, trajTime)
% 
% % Begrens tiden til trajektoriens tidsintervall
% t = max(trajTime(1), min(t, trajTime(5)));
% 
% % Velg riktig polynom for hvert tidsintervall
% if t <= trajTime(2)
%     C = trajCoeff(1:5,:);
%     F = F4(t);
% 
% elseif t <= trajTime(3)
%     C = trajCoeff(6:9,:);
%     F = F3(t);
% 
% elseif t <= trajTime(4)
%     C = trajCoeff(10:13,:);
%     F = F3(t);
% 
% else
%     C = trajCoeff(14:18,:);
%     F = F4(t);
% end
% 
% % Beregn posisjonene
% pos = F*C;
% 
% % Konverter fra mm til meter
% x = pos(1)/1000;
% y = pos(2)/1000;
% z = pos(3)/1000;
% 
% end
% 
% 
% %% Lokale funksjoner
% 
% function out = F4(t)
% out = [1 t t^2 t^3 t^4];
% end
% 
% function out = F3(t)
% out = [1 t t^2 t^3];
% end
