
function [del,q,ptr] = viterbi_NE(obs,A_w,B_w)

N = size(A_w,1);
T = size(obs,1);
del = double(zeros(N,T));
ptr = zeros(N,T);
q = zeros(T,1);

% INITIALIZE
del(1,1) = 1;
ptr(1,1) = 1;

for t = 2:T
   for j = 1:N
      maxm = 0;
      for i = 1:N
         if mod(j,4) == 0
             temp = A_w(i,j)*del(i,t);
             if temp > maxm
                 maxm = temp;
                 ptr(j,t) = i;
             end
         else
             temp  = A_w(i,j)*del(i,t-1)*B_w(j,obs(t,1));
             if temp > maxm
                 maxm = temp;
                 ptr(j,t) = i;
             end
         end
      end
      del(j,t) = maxm;
   end

end
q(T,1) = ptr(N,T); 
for i = T-1:-1:1
    q(i,1) = ptr(q(i+1,1),i+1);
end

end