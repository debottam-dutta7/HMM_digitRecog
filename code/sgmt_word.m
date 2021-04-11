
function [phn_sgmt,b,qq] = sgmt_word(O,utter,A_w,B_w)
% O = whole word utterance cell 1*E cell
phn_sgmt = {}; N = 4;
E = size(O,2);
if utter == 1
    p = 3;
elseif utter == 0
    p = 4;
end

for i = 1:E
    obs = O{1,i};
    T = size(obs,1);
    [del_hat,qq,ptr] = log_viterbi_NE(obs,A_w,B_w);
    b = find(mod(qq,N)==0);
    b = [0;b;T];
    %K = floor(T/q);
    
    for j = 1:p
        strt = b(j,1)+1;
        fin = b(j+1,1);
        if fin > T
            fin = T;
        end
        phn_sgmt{i,j} = obs(strt:fin,1);
    end
end
end