

function [A_new,B_new,P_new,log_lh] = train_phn_model(O,A,B,P)

E = size(O,2); N = size(A,1); M = 32;
denom_A_arr = double(zeros(N,1));
numer_A_arr = double(zeros(N,N));
denom_B_arr = double(zeros(N,1));
numer_B_arr = double(zeros(N,M));
gamma_1_arr = double(zeros(N,1));
log_lh = 0;

A_new = double(zeros(N,N));
B_new = double(zeros(N,M));

for e = 1:E 
    obs = O{1,e};
    %%%%%%    
    %%%%%
    
    
%     [alpha_hat,scale_new] = forward_prob(obs,A,B,P);
%     beta_hat = backward_prob(obs,A,B,P,scale_new);
    
    [alpha_hat,scale_new,~] = fp_NE(obs,A,B,P);
    beta_hat = bp_NE(obs,A,B,P,scale_new);
    
    [denom_A,numer_A,denom_B,numer_B,gamma_1,log_prob] = reestimate_phn_model(obs,A,B,alpha_hat,beta_hat,scale_new);
    denom_A_arr = denom_A_arr+ denom_A;
    numer_A_arr = numer_A_arr + numer_A;
    denom_B_arr = denom_B_arr + denom_B;
    numer_B_arr = numer_B_arr + numer_B;
    gamma_1_arr = gamma_1_arr + gamma_1;
    
    log_lh = log_lh + log_prob;

end

for i = 1:N % changed: N to N-1
   A_new(i,:) = numer_A_arr(i,:)/denom_A_arr(i,1); 
   B_new(i,:) = numer_B_arr(i,:)/denom_B_arr(i,1);
end
P_new = gamma_1_arr/sum(gamma_1_arr);


end