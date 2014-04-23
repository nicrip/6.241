% Problem Set 8, Question 4, auxilary function
% Nicholas Rypkema (rypkema@mit.edu)

function maxval = PS_8_4(bw, a)

P0 = tf([1 -a], [1 2 0]);
[Ah, Bh] = butter(3, bw, 'low', 's');
H = tf(Ah, Bh);
W1 = H;
W2 = 0.0001;
r = 0.0001;
P = [W1 -r*W1*P0 -W1*P0; 
    0 r*W2*P0 W2*P0; 
    0 r*0 r; 
    1 -r*P0 -P0];
P_ = minreal(ss(P),[],false);
[K, G] = hinfsyn(P_,1,1);

[K_num, K_den]=ss2tf(K.a,K.b,K.c,K.d);

S_ = P0*tf(K_num,K_den);
S = minreal(S_/(1+S_),[],false);

w = logspace(-2,4,1000);
Sw = squeeze(freqresp(S,j*w));
Sens = (abs(1-Sw));
maxval = max(Sens);
