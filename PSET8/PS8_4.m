% QUestion PS8.4

clear all;

%% Simulink model

% Plant parameters
a = 1;
P_num = [1 -a];
P_den = [1 2 0];

% Weights

% w1 is defined using a Butterworth filter
r = 0.0001; % Regularization parameter, an arbitrarily small non-zero value
W2 = r;
W3 = r;
W4 = r;

% Define w1 using a Butterworth filter
% Butterworth filter parameters
cut_off_freq = 1; % cut off frequency
filter_order = 3; 

% Export parameters to Simulink model (no longer necessary)
assignin('base','a',a);
assignin('base','cut_off_freq',cut_off_freq);
assignin('base','filter_order',filter_order);
assignin('base','W2',W2);
assignin('base','W3',W3);
assignin('base','W4',W4);
assignin('base','P_num',P_num);
assignin('base','P_den',P_den);

% Extract plant model (this is simply a convenient alternative to defining
% the coefficient matrices (A_p, B_p, etc) manually
[A_p,B_p,C_p,D_p]=linmod('PS84OL') 
P = ss(A_p,B_p,C_p,D_p)

% H-infinity optimization
[K,G] = hinfsyn(P,1,1); % Number of measurement outputs from the plant (sensors) = 1 
                        % Number of control inputs to the plant (actuators) = 1

[K_num,K_den]=ss2tf(K.a,K.b,K.c,K.d);

assignin('base','K_num',K_num);
assignin('base','K_den',K_den);

[A_c,B_c,C_c,D_c] = linmod('PS84CL'); % Extract closed loop model
S = ss(A_c,B_c,C_c,D_c);

% Plot frequency response
figure
w = logspace(-2,4,500);
Sw = squeeze(freqresp(S,j*w));
%semilogx(w,20*log10(abs(1-Sw)));
semilogx(w,(abs(1-Sw)));
grid on

% bode(S)