
function [del_hat,q,ptr] = log_viterbi_NE(obs,A_w,B_w)

N = size(A_w,1);
T = size(obs,1);
del_hat = double(zeros(N,T));
del_hat(:) = -Inf;

ptr = zeros(N,T);
q = zeros(T,1);
A_hat = log(A_w);
B_hat = log(B_w);
P = double(zeros(N,1));
P(1,1) = 1;
P_hat = log(P);

% INITIALIZE
for i = 1:N
    del_hat(i,1) = P_hat(i,1) + B_hat(i,obs(1,1)); % logP(1,1) = 0;
end
ptr(1,1) = 1;

for t = 2:T
   for j = 1:N
      maxm = -Inf;
      for i = 1:N
         if mod(j,4) == 0
             temp = A_hat(i,j)+ del_hat(i,t);
             if temp > maxm
                 maxm = temp;
                 ptr(j,t) = i;
             end
         else
             temp  = A_hat(i,j)+ del_hat(i,t-1)+ B_hat(j,obs(t,1));
             if temp > maxm
                 maxm = temp;
                 ptr(j,t) = i;
             end
         end
      end
      del_hat(j,t) = maxm;
   end

end
q(T,1) = ptr(N,T); 
for i = T-1:-1:1
    q(i,1) = ptr(q(i+1,1),i+1);
end

end