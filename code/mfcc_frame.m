
function melC = mfcc_frame(audio,fs,win_len,ovrlp)

melC = mfcc(audio,fs,'WindowLength',win_len,'OverlapLength',ovrlp,'NumCoeffs',12);



end