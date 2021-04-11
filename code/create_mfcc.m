close all;

path = 'C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\train_sample\';
list = dir('C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\train_sample\*.wav');

[~,fs] = audioread([path list(1).name]) ;
win_len = floor(0.02*fs);
ovrlp = floor(0.015*fs);
C1_obs = {};
C0_obs = {};


for i = 1:10
    audio1 = audioread([path list(i+10).name]);% ONE
   [audio2,fs] = audioread([path list(i).name]) ; % ZERO
   melC1 = mfcc_frame(audio1,fs,win_len,ovrlp); % frame for one
   melC2 = mfcc_frame(audio2,fs,win_len,ovrlp);
   
   C1_obs{1,i} = melC1';
   C0_obs{1,i} = melC2';
   
end
test_path = 'C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\test_sample\';
test_list = dir('C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\test_sample\*.wav');

t_obs = {};
for i = 1:length(test_list)
    audio_t = audioread([test_path test_list(i).name]);
    
   melC_t = mfcc_frame(audio_t,fs,win_len,ovrlp); 
   
   
   t_obs{1,i} = melC_t';
   
   
end



 save('C1_obs_n','C1_obs');
 save('C0_obs_n','C0_obs');
 save('test_obs_n.mat','t_obs');
%%
M = 32; % # of clusters

rng(1); % So that Test and train features are clustered with the same centroids 
train_path = 'C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\train_sample\';
test_path = 'C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\test_sample\';

train_list = dir('C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\train_sample\*.wav');
test_list = dir('C:\Users\dudebo_07\Documents\MATLAB\SIP\HW6\train_test.tar\Data_processed\test_sample\*.wav');

test = load('test_obs_n.mat');
test_feat = test.t_obs;
t = [];



for i = 1:10
   t = [t test_feat{1,i}]; 
end
t = normalize(t,2);
[idx_t,cent] = kmeans(t',M);
test_len_arr = [];
for i=1:10
   
    test_len_arr = [test_len_arr size(test.t_obs{1,i},2)];
    
end
test_len_arr = [0 test_len_arr];
test_coded = {};
for i = 2:11
   from1 = 1+test_len_arr(i-1);
   to1 = from1 + test_len_arr(i)-1;
   test_coded{1,i-1} = idx_t(from1:to1,1);
       
end
%save('test_coded_sep_lrg_nrm.mat','test_coded');


%%% TRAIN DATA

c1 = load('C1_obs_n','C1_obs');
c0 = load('C0_obs_n','C0_obs');
c11 = c1.C1_obs;
c00 = c0.C0_obs;
%c = [cell2mat(c1.C1_obs) cell2mat(c0.C0_obs)];
c11_arr = cell2mat(c11);
c11_arr = normalize(c11_arr,2);
c00_arr = cell2mat(c00);
c00_arr = normalize(c00_arr,2);

[idx1,centroid1] = kmeans(c11_arr',M); % 32 clusters
[idx0,centroid0] = kmeans(c00_arr',M);
%c1 = c;
% for i = 1:length(idx)
%    
%     c(:,i) = centroid(idx(i),:);
% end

%num_c1_frames = size(cell2mat(c1.C1_obs),2);
c1_coded = idx1;%idx(1:num_c1_frames,1);     %c(:,1:num_c1_frames);
c0_coded = idx0;%idx(num_c1_frames+1:end,1); % c(:,num_c1_frames+1:end);
c1_len = []; c0_len = [];

for i=1:10
   
    c1_len = [c1_len size(c1.C1_obs{1,i},2)];
    c0_len = [c0_len size(c0.C0_obs{1,i},2)];
end
c1_len = [0,c1_len]; c0_len = [0 c0_len];

c1_new = {}; c0_new = {};
for i = 2:11
   from1 = 1+c1_len(i-1);
   to1 = from1 + c1_len(i)-1;
   from0 = 1+c0_len(i-1);
   to0 = from0 + c0_len(i)-1;
   c1_new{1,i-1} = c1_coded(from1:to1,1);
   c0_new{1,i-1} = c0_coded(from0:to0,1);
      
end
%  save('c1_coded_sep_lrg_nrm.mat','c1_new');
%  save('c0_coded_sep_lrg_nrm.mat','c0_new');

%%  K-means for both the train classes together
% % CODE IT TO 32 VECTORS USING K-MEANS
% c1 = load('C1_obs','C1_obs');
% c0 = load('C0_obs','C0_obs');
% c = [cell2mat(c1.C1_obs) cell2mat(c0.C0_obs)];
% 
% [idx,centroid] = kmeans(c',32); % 32 clusters
% %c1 = c;
% for i = 1:length(idx)
%    
%     c(:,i) = centroid(idx(i),:);
% end
% 
% num_c1_frames = size(cell2mat(c1.C1_obs),2);
% c1_coded = idx(1:num_c1_frames,1);     %c(:,1:num_c1_frames);
% c0_coded = idx(num_c1_frames+1:end,1); % c(:,num_c1_frames+1:end);
% c1_len = []; c0_len = [];
% 
% for i=1:10
%    
%     c1_len = [c1_len size(c1.C1_obs{1,i},2)];
%     c0_len = [c0_len size(c0.C0_obs{1,i},2)];
% end
% c1_len = [0,c1_len]; c0_len = [0 c0_len];
% 
% c1_new = {}; c0_new = {};
% for i = 2:11
%    from1 = 1+c1_len(i-1);
%    to1 = from1 + c1_len(i)-1;
%    from0 = 1+c0_len(i-1);
%    to0 = from0 + c0_len(i)-1;
%    c1_new{1,i-1} = c1_coded(from1:to1,1);
%    c0_new{1,i-1} = c0_coded(from0:to0,1);
%       
% end
% save('c1_coded.mat','c1_new');
% save('c0_coded.mat','c0_new');
% 
