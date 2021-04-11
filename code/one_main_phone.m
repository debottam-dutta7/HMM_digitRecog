
% one_main_phn, train_phn_model done!
%-----------------------------------------
close all;
% For ONE %%%%
% c1 = load('c1_coded_sep_lrg_nrm.mat');
% c1_obs = c1.c1_new;
% q = 3;
% utter = 1;

%%% For ZERO %%%%%
c0 = load('c0_coded_sep_lrg_nrm.mat');
c1_obs = c0.c0_new;
q = 4;
utter = 0;

%%% SET VALUES FOR FLAT START %%%

% q = #of phoneme in the word
% N = # of states
% M = # of discrete observations

MAXITER = 15; 
                  %%% SET  %%%VALUES  %%% HERE 

%%%% FIXED %%%%
N = 4; M = 32;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
 %T = size(c1_1,1); 

A = double(zeros(N,N));
B = double(zeros(N,M));
P = double(ones(N,1));
%P(1,1) = 1;
P = P/sum(P);
log_lh_arr = [];
A_big = {}; B_big = {};
% Initialize A
for i = 1:N-1
   A(i,i) = 0.5;
   A(i,i+1) = 0.5;
end
A(N,N) = 0;
for i = 1:q
   A_big{i,1} = A; 
end

for i = 1:N
    for j = 1:M
        B(i,j) = 1/M ; %+ rand(1);
    end
    B(i,:) = B(i,:)/ sum(B(i,:));
end
B(N,:) = 0;
for i = 1:q
   B_big{i,1} = B; 
end

phn_sgmt = flat_start(c1_obs,q);

%% TRAIN
lh_arr = zeros(q,1);
lh_mat = zeros(MAXITER,q);
%lh_mat = zeros(1,q);
for iter = 1:MAXITER
   
    for j = 1:q % q = 4 for ZERO
       phn_O = phn_sgmt(:,j)';
       [A_new,B_new,P_new,log_lh] = train_phn_model(phn_O,A_big{j,1},B_big{j,1},P);
       A_new(N-1,N) = rand; A_new(N-1,:) = A_new(N-1,:)./sum(A_new(N-1,:));
       A_new(N,:) = 0;
       
       B_new(N,:) = 0;
       A_big{j,1} = A_new; B_big{j,1} = B_new; 
       lh_arr(j,1) = log_lh;
    end
    
    [A_w,B_w,P_w] = mdl_cat(A_big,B_big,utter);
    [phn_sgmt,b,qq] = sgmt_word(c1_obs,utter,A_w,B_w);
    
    fprintf(" Iteration: %d\n",iter);
    disp(lh_arr');
    lh_mat(iter,:) = lh_arr;
    
end
%% PLOT
if q == 3
    figure();
    plot(lh_mat(:,1)); hold on;
    plot(lh_mat(:,2)); hold on;
    plot(lh_mat(:,3)); legend('/w/','/a/','/n/');
    title('Neg-Log Likelihood for different phonemes of "ONE"');
    xlabel('Iteration'); xlim([1,MAXITER]);
    hold off;
    %save('phn_hmm_one_sep_lrg_nrm.mat','A_w','B_w','lh_mat');
end
if q == 4
    figure();
    plot(lh_mat(:,1)); hold on;
    plot(lh_mat(:,2)); hold on;
    plot(lh_mat(:,3)); hold on;
    plot(lh_mat(:,4)); 
    legend('/z/','/i/','/r/','/o/');
    title('Neg-Log Likelihood for different phonemes of "ZERO"');
    xlabel('Iteration'); xlim([1,MAXITER]);
    hold off;
    
    %save('phn_hmm_zero_sep_lrg_nrm.mat','A_w','B_w','lh_mat');
end
%% TEST
hmm1 = load('phn_hmm_one_sep_lrg_nrm.mat');
A1_w = hmm1.A_w;
B1_w = hmm1.B_w;

hmm0 = load('phn_hmm_zero_sep_lrg_nrm.mat');
A0_w = hmm0.A_w;
B0_w = hmm0.B_w;

test = load('test_coded_sep_lrg_nrm.mat');
t_obs = test.test_coded;
E_t = length(t_obs);
pred = zeros(E_t,1);
lh1_arr = [];
lh0_arr = [];


P1 = zeros(12,1); P1(1,1) = 1;
P0 = zeros(16,1); P0(1,1) = 1;
%  P1 = ones(12,1); P1 = P1/sum(P1);
%  P0 = ones(16,1); P0 = P0/sum(P0);

for i = 1:E_t
    obs = t_obs{1,i};
    [alpha_hat1,~,lhood1] = fp_NE(obs,A1_w,B1_w,P1);
    [alpha_hat0,~,lhood0] = fp_NE(obs,A0_w,B0_w,P0);
    lh1_arr = [lh1_arr lhood1];
    lh0_arr = [lh0_arr lhood0];
    if lhood1 >= lhood0
        pred(i,1) = 1;
    else
        pred(i,1) = 0;
    end
    
end
label1 = ones(5,1); label0 = zeros(5,1);
label = [label1;label0];
acc = pred - label;
acc = 100*(10-sum(abs(acc)))/10;
fprintf('Accuracy = %f %',acc);






