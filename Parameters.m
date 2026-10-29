clear; clc; close all;

%% Basic parameters
g = 9.81;


%% Creating parts from part template
partTemplate = struct('m', [], 'Ix', [], 'Iy', [], 'Iz', []);

blueBlock = partTemplate;
blueBeam = partTemplate;
greenBlock = partTemplate;
greenBeam = partTemplate;
red = partTemplate;
white = partTemplate;
cyan = partTemplate;
grey = partTemplate;
black = partTemplate;
lightBlue = partTemplate;

%% Setting parameters
blueBlock.Ix = 50; % kg*m^2
blueBlock.Iy = 50; % kg*m^2
blueBlock.Iz = 50; % kg*m^2
blueBlock.m = 750; % kg

blueBeam.Ix = 0; % kg*m^2
blueBeam.Iy = 0; % kg*m^2
blueBeam.Iz = 0; % kg*m^2
blueBeam.m = 0; % kg

red.Ix = 1; % kg*m^2
red.Iy = 20; % kg*m^2
red.Iz = 20; % kg*m^2
red.m = 250; % kg

greenBeam.Ix = 0.5; % kg*m^2
greenBeam.Iy = 8; % kg*m^2
greenBeam.Iz = 8; % kg*m^2
greenBeam.m = 150; % kg

greenBlock.Ix = 10; % kg*m^2
greenBlock.Iy = 10; % kg*m^2
greenBlock.Iz = 10; % kg*m^2
greenBlock.m = 500; % kg

white.Ix = 0.2; % kg*m^2
white.Iy = 1; % kg*m^2
white.Iz = 1; % kg*m^2
white.m = 50; % kg

cyan.Ix = 2; % kg*m^2
cyan.Iy = 3; % kg*m^2
cyan.Iz = 2; % kg*m^2
cyan.m = 150; % kg

grey.Ix = 1; % kg*m^2
grey.Iy = 18; % kg*m^2
grey.Iz = 18; % kg*m^2
grey.m = 200; % kg

black.Ix = 0.5; % kg*m^2
black.Iy = 2; % kg*m^2
black.Iz = 2; % kg*m^2
black.m = 100; % kg

lightBlue.Ix = 1; % kg*m^2
lightBlue.Iy = 1; % kg*m^2
lightBlue.Iz = 1; % kg*m^2
lightBlue.m = 50; % kg

%% Lengths
LB1 = 0.8; % m
LB2 = 0.3; % m
LB3 = 0.24; % m
LR1 = 1.05; % m
LG1 = 0.3; % m
LG2 = 0.8; % m
LG3 = 0.4; % m
LW1 = 1.05; % m
LC1 = 0.4; % m
LC2 = 0.225; % m
Lgrey1 = 1.175; % m
Lblack1 = 0.2; % m
LLB1 = 0.248; % m
LLB2 = 0.235; % m
L0_spring = 0.75; % m Undeformed length of spring
w = 0.1; % m Width of beams


% Spring constants
k_spring = 100 * 1e3; % N/m


%% Motor torque constants [Nm/A]
KmA = 1.5;
KmB1 = 1.5;
KmB2 = 1.5;
KmG = 0.5;
KmH = 1;
KmI = 0.5;

%% Gear ratios [-]
nA = 200;
nB1 = 200;
nB2 = 200;
nG = 20;
nH = 100;
nI = 20;

%% Current limits for motors [A]
IMax = 16;
IMin = -16; 

%% Motor mass moment of inertia [kg*m^2]
JM = 0.002;


%% Controller parameters
KpA_pos = 150;
KiA_pos = 2;
KdA_pos = 1;
omegaFilterA_pos = 60;
KpA_vel = 30;
KiA_vel = 5;
KdA_vel = 0;
omegaFilterA_vel = 60;

KpB1_pos = 200;
KiB1_pos = 30;
KdB1_pos = 1;
omegaFilterB1_pos = 60;
KpB1_vel = 30;
KiB1_vel = 10;
KdB1_vel = 0;
omegaFilterB1_vel = 60;

KpB2_pos = 150;
KiB2_pos = 20;
KdB2_pos = 1;
omegaFilterB2_pos = 60;
KpB2_vel = 30;
KiB2_vel = 5;
KdB2_vel = 0;
omegaFilterB2_vel = 60;

KpG_pos = 100;
KiG_pos = 30;
KdG_pos = 1;
omegaFilterG_pos = 60;
KpG_vel = 50;
KiG_vel = 5;
KdG_vel = 0;
omegaFilterG_vel = 60;

KpH_pos = 100;
KiH_pos = 10;
KdH_pos = 1;
omegaFilterH_pos = 60;
KpH_vel = 20;
KiH_vel = 0;
KdH_vel = 0;
omegaFilterH_vel = 60;

KpI_pos = 50;
KiI_pos = 0;
KdI_pos = 1;
omegaFilterI_pos = 60;
KpI_vel = 20;
KiI_vel = 0;
KdI_vel = 0;
omegaFilterI_vel = 60;



% %% Controller parameters
% KpA_pos = 150;
% KiA_pos = 2;
% KdA_pos = 1;
% omegaFilterA_pos = 60;
% KpA_vel = 30;
% KiA_vel = 5;
% KdA_vel = 0;
% omegaFilterA_vel = 60;
% 
% KpB1_pos = 200;
% KiB1_pos = 30;
% KdB1_pos = 1;
% omegaFilterB1_pos = 60;
% KpB1_vel = 30;
% KiB1_vel = 10;
% KdB1_vel = 0;
% omegaFilterB1_vel = 60;
% 
% KpB2_pos = 150;
% KiB2_pos = 20;
% KdB2_pos = 1;
% omegaFilterB2_pos = 60;
% KpB2_vel = 30;
% KiB2_vel = 5;
% KdB2_vel = 0;
% omegaFilterB2_vel = 60;
% 
% KpG_pos = 100;
% KiG_pos = 20;
% KdG_pos = 1;
% omegaFilterG_pos = 60;
% KpG_vel = 10;
% KiG_vel = 5;
% KdG_vel = 0;
% omegaFilterG_vel = 60;
% 
% KpH_pos = 100;
% KiH_pos = 10;
% KdH_pos = 1;
% omegaFilterH_pos = 60;
% KpH_vel = 20;
% KiH_vel = 0;
% KdH_vel = 0;
% omegaFilterH_vel = 60;
% 
% KpI_pos = 50;
% KiI_pos = 0;
% KdI_pos = 1;
% omegaFilterI_pos = 60;
% KpI_vel = 20;
% KiI_vel = 0;
% KdI_vel = 0;
% omegaFilterI_vel = 60;



%% Path planning
t1 = 0;
t2 = 2;
t3 = 4;
t4 = 6;
t5 = 8;


% Start conditions
A0 = 0.310447780017169;
B10 = -0.192075602039053;
B20 = -0.011912003704451;
G0 = -1.061422531644424;
H0 = -0.357470264672538;
I0 = -1.033155420835947;


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


