
function beta_hat = bp_NE(obs,A,B,P,scale)

N = size(A,1);
T = size(obs,1);
beta = double(zeros(N,T));
beta_hat = beta;

beta(N,T) = 1;
for i = 1:N-1
   beta(i,T) = A(i,N); 
end
beta_hat(:,T) = beta(:,T);
for t = T-1:-1:1
   for j = N-1:-1:1
      temp = 0;
      for i = 1:N
         if mod(i,4) == 0
             temp = temp + A(j,i)*beta_hat(i,t);
         else
            temp = temp + A(j,i)*beta_hat(i,t+1)*B(i,obs(t+1,1));
         end
             
      end
      beta(j,t) = temp;
      beta_hat(j,t) = temp;
   end
   beta_hat(:,t) = beta(:,t)/scale(t+1,1);
end

end