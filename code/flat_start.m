
function phn_sgmt = flat_start(O,q)
% q = 3 for utter 'one', q = 4 for utter 'zero'

phn_sgmt = {};

E = size(O,2);

for e = 1:E
   obs = O{1,e};
   T = size(obs,1);
   K = floor(T/q);
   for j  = 1:q
      strt = K*(j-1) + 1;
      fin = strt + K -1;
      if j == q
          if fin < T
              fin = T;
          end
      end
      phn_sgmt{e,j} = obs(strt:fin,1);
   end
end
end