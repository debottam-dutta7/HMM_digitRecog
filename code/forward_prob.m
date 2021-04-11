
function [alpha_hat,scale] = forward_prob(obs,A,B,P)

N = size(A,1);
T = size(obs,1);
alpha = double(zeros(N,T));
alpha_hat = alpha;
scale = double(zeros(T,1));

%%% INITIALIZE
for i=1:N
   
    alpha(i,1) = P(i,1)*B(i,obs(1,1));
end
scale(1,1) = sum(alpha(:,1)); % scale : T*1
alpha_hat(:,1) = alpha(:,1)/scale(1,1);

%%% RECURSION

for t = 2:T
    for j = 1:N
        temp = 0;
       for i = 1:N
           temp = temp + alpha_hat(i,t-1)*A(i,j);
       end
       alpha(j,t) = temp*B(j,obs(t,1));
    end
    scale(t,1) = sum(alpha(:,t));  %%% change to 1 if scale = 0
    alpha_hat(:,t) = alpha(:,t)/scale(t,1);
end

end