% Problem Set 8, Question 5
% Nicholas Rypkema (rypkema@mit.edu)

w0_vals = [];
H2_vals = [];

for w0 = 0:0.1:10
  A = [0 -w0^2; 
      1 0];
  B1 = [1 0;
      0 0];
  B2 = [0;
      0];
  B = [B1 B2];

  C1 = [0 1];
  C2 = [0 1];
  C = [C1;
      C2];

  D11 = [0 0];
  D12 = -1;
  D21 = [0 1];
  D22 = 0;
  D = [D11 D12; D21 D22];

  L = [-1; -1];

  Af = A + L * C2;
  Bf = -L;
  Cf = C2;
  Df = 0;
  [num_H0, den_H0] = ss2tf(Af, Bf, Cf, Df);
  H0 = tf(num_H0, den_H0);

  As = A + L*C2;

  Bs1 = B1 + L*D21;
  Bs2 = B2;
  Bs = [Bs1 Bs2];

  Cs1 = C1;
  Cs2 = C2;
  Cs = [Cs1; Cs2];

  Ds11 = D11;
  Ds12 = D12;
  Ds21 = D21;
  Ds22 = D22;
  Ds = [Ds11 Ds12; Ds21 Ds22];

  P = ss(As, Bs, Cs, Ds);

  K = h2syn(P,1,1);
  [num_K, den_K] = ss2tf(K.a,K.b,K.c,K.d);
  Hs = minreal(tf(num_K, den_K));
  
  P0 = minreal(tf(1, [1 0 w0^2]));
  H = minreal(H0+Hs*(1-H0));
  G = minreal([P0-P0*tf(minreal(H)) -tf(minreal(H))]);
  G = tf(minreal(ss(G)));
  H2 = norm(G,2);
  
  w0_vals = [w0_vals, w0];
  H2_vals = [H2_vals, H2];
end

figure()
plot(w0_vals, H2_vals);