
function [A_w,B_w,P_w] = mdl_cat(A_big,B_big,utter)

N = 4; M = 32;
if utter == 1
    q = 3;
elseif utter == 0
    q = 4;
end
P_w = zeros(4*q,1);
P_w(1,1) = 1;
A_w = double(zeros(q*N,q*N));
B_w = double(zeros(q*N,M));

for i  = 1:q
   strt = N*(i-1)+1;
   fin = strt + N-1;
   A_w(strt:fin,strt:fin) = A_big{i,1};
   B_w(strt:fin,:) = B_big{i,1};
end
%replace zeros of B by row  min value
for i = 1:N*q
    if mod(i,4) ~= 0
        row = B_w(i,:);
        nz_row = row(row ~= 0);
        epsilon = min(nz_row);
        for j = 1:M
            if B_w(i,j) == 0
                B_w(i,j) = epsilon;
            end
        end
        B_w(i,:) = B_w(i,:)/sum(B_w(i,:));
    end
    
end


for i = 1:N*q-1
   if mod(i,N) == 0
      A_w(i,i+1) = 1; 
   end
end
for i = 1:N*q
   if mod(i,N) == 0 &&  A_w(i-1,i-1) == 1
       A_w(i-1,i-1) = 0.5;
       A_w(i-1,i) = 0.5;
     
   end
end

end