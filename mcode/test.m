
recordName = '100';

[ann,type]=rdann( recordName , 'atr' ) ;

[signal,Fs,t]=rdsamp( recordName , 1 ) ; 

% ann = index of a beat
% type = categorize that beat

beats = zeros(101,length(ann));

for i = 3:4%length(ann)
    ind = ann(i);
    s = signal(ind-50:ind+50);
    figure(); plot(s)
    beats(:,i) = s;
end