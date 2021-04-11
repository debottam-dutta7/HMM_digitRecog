
function [denom_A,numer_A,denom_B,numer_B,gamma_1,log_prob] = reestimate_model_N(obs,A,B,alpha_hat,beta_hat,scale)

N = size(A,1); T = size(obs,1); M = 32;
zeta = double(zeros(N,N,T));
gamma = double(zeros(N,T));
A_new = double(zeros(size(A)));
B_new = double(zeros(size(B)));
P_new = double(zeros(N,1));

denom_A = double(zeros(N,1));
denom_B = double(zeros(N,1));
numer_A = double(zeros(N,N));
numer_B = double(zeros(N,M));

for t  = 1:T-1 % changed it from T to T-1
   for i = 1:N
       for j = 1:N
          zeta(i,j,t) = alpha_hat(i,t)*A(i,j)*B(j,obs(t+1,1))*beta_hat(j,t+1)/scale(t+1,1); % changed: t to t+1
       end
   end
end

for t = 1:T
   for i = 1:N
      gamma(i,t) = alpha_hat(i,t) * beta_hat(i,t); 
   end
end
gamma_1= gamma(:,1);
%%%% P           % added later
% for i = 1:N
%     P_new(i,1) = gamma(i,1);
% end
% P_new = P_new/sum(P_new);

%%% A_new   %%%% USE indexing method if runs slow
for i = 1:N
   %denom = 0;
   for t = 1:T-1
      denom_A(i,1) = denom_A(i,1) + gamma(i,t); 
   end
   for j = 1:N
      %numer_A(i,j) = 0;
      for t = 1:T-1
         numer_A(i,j) = numer_A(i,j) + zeta(i,j,t); 
      end
      %A_new(i,j) = numer/denom;
   end
end
%%% B_new

for i = 1:N
   %denom = 0;
   for t = 1:T
      denom_B(i,1) = denom_B(i,1) + gamma(i,t); 
   end
   
   for j = 1:M
      %numer = 0;
      for t = 1:T
         if obs(t) == j
             numer_B(i,j) = numer_B(i,j) + gamma(i,t);
         end
      end
      %B_new(i,j) = numer/denom;
   end
   
end

%%% log_likelihood
log_prob = -sum(log(scale));

end