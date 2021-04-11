
function beta_hat = backward_prob(obs,A,B,P,scale)

N = size(A,1);
T = size(obs,1);
beta = double(zeros(N,T));
beta_hat = beta;
%%% INITIALIZE

for i = 1:N
   beta(i,T) = 1; 
end
beta_hat(:,T) = beta(:,T);

for t = T-1:-1:1
   for j=1:N
       temp = 0;
      for i=1:N
          temp = temp + beta_hat(i,t+1)*A(j,i)*B(i,obs(t+1,1));
      end
      beta(j,t) = temp;
   end
   beta_hat(:,t) = beta(:,t)/scale(t+1,1); % changed: t to t+1; same scale factors as in alpha are used
end

end