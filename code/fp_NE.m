
function [alpha_hat,scale,lhood] = fp_NE(obs,A,B,P)

N = size(A,1);
T = size(obs,1);
alpha = double(zeros(N,T));
alpha_hat = alpha;
scale = double(zeros(T,1));

%INITIALIZE
%alpha(1,1) = P(1,1)*B(1,obs(1,1));
for i=1:N
   
    alpha(i,1) = P(i,1)*B(i,obs(1,1));
end
scale(1,1) = sum(alpha(:,1));
if scale(1,1) == 0
    scale(1,1) = 1;
end

alpha_hat(:,1) = alpha(:,1)/scale(1,1);

% RECURSION

for t =2:T
   for j = 1:N
      temp = 0;
      for i = 1:N
         if mod(j,4) == 0 
             temp = temp + A(i,j)*alpha_hat(i,t);
         else
             temp = temp + A(i,j)*alpha_hat(i,t-1)*B(j,obs(t,1));
         end
      end
      alpha(j,t) = temp;
      alpha_hat(j,t) = temp;
   end
   scale(t,1) = sum(alpha(:,t));
   if scale(t,1) == 0
       scale(t,1) = 1;
   end
   alpha_hat(:,t) = alpha(:,t)/scale(t,1);
end
% termination
lhood = sum(alpha(:,T)); % P(O/lambda)


end