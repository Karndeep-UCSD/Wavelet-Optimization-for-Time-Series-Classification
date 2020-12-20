
fileList = dir('C:\Users\19095\Documents\ECE251C\ECG_data\*.atr');

% Wavelet Filters
[LoD,HiD,LoR,HiR] = wfilters('bior6.8');

for i = 1%:length(fileList)
    
    recordName = fileList(i).name(1:end-4);
    
    % Read in Data
    [ann,type]=rdann( recordName , 'atr' ) ;
    [signal,Fs,t]=rdsamp( recordName , 1 ) ;

    %{
    ann = index of a beat
    type = categorize that beat
    signal = EEG signal
    t = time variable for EEG signal
    Fs = sampling rate
    %}
    
    % Preallocate space
    beats = zeros(252,length(ann));
    
    % Segment out signals
    for i = 3:length(ann)-2
        ind = ann(i);
        s = signal(ind-89:ind+162);
        beats(:,i) = s;
    end

    % Test beat
    [c1,c2,c3,c4,c5,c6,c7,c8] = WMRA_bior6_8(beats(:,100), true);

    % Level 1
    cD1 = filter(HiD,1,beats,[],1);
    cD1 = downsample(cD1,2);
    LP1 = filter(LoD,1,beats,[],1);
    LP1 = downsample(LP1,2);
    % level 2
    cD2 = filter(HiD,1,LP1,[],1);
    cD2 = downsample(cD2,2);
    LP2 = filter(LoD,1,LP1,[],1);
    LP2 = downsample(LP2,2);
    % level 3
    cD3 = filter(HiD,1,LP2,[],1);
    cD3 = downsample(cD3,2);
    LP3 = filter(LoD,1,LP2,[],1);
    LP3 = downsample(LP3,2);
    % level 4
    cD4 = filter(HiD,1,LP3,[],1);
    cD4 = downsample(cD4,2);
    LP4 = filter(LoD,1,LP3,[],1);
    LP4 = downsample(LP4,2);
    % level 5
    cD5 = filter(HiD,1,LP4,[],1);
    cD5 = downsample(cD5,2);
    LP5 = filter(LoD,1,LP4,[],1);
    LP5 = downsample(LP5,2);
    % level 6
    cD6 = filter(HiD,1,LP5,[],1);
    cD6 = downsample(cD6,2);
    LP6 = filter(LoD,1,LP5,[],1);
    LP6 = downsample(LP6,2);
    % level 7
    cD7 = filter(HiD,1,LP6,[],1);
    cD7 = downsample(cD7,2);
    LP7 = filter(LoD,1,LP6,[],1);
    LP7 = downsample(LP7,2);
    % level 8
    cD8 = filter(HiD,1,LP7,[],1);
    cD8 = downsample(cD8,2);
    LP8 = filter(LoD,1,LP7,[],1);
    LP8 = downsample(LP8,2);

    % Combine into wavelet
    wav_out = [cD1; cD2; cD3; cD4; cD5; cD6; cD7; cD8];

    % Save Data
    filenameWMRA = 'C:\Users\19095\Documents\ECE251C\ECG_data\WMRA\' + string(recordName) + '_WMRA.mat';
%     filenameANNO = 'C:\Users\19095\Documents\ECE251C\ECG_data\WMRA\' + string(recordName) + '_ANNO.mat';
%     save(filenameWMRA, 'wav_out', 'type');

end




