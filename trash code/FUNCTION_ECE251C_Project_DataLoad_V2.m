%% import data
clc; clear all; close all;

p = 1; %set file

for i = 100:236
    dataPath = strcat(pwd, '/ECG_data/Raw_Beat_CSV/', int2str(i), '_seg.mat'); %get path
    
    if (exist(dataPath,  'file') == 2)
        % load File, Labels, Data
        dataStruct = load(dataPath); 
        labels_temp = dataStruct.type; 
        data_temp = dataStruct.beats; 
        
        %remove unwanted data points
        classToSave = {'L', 'R', 'V', 'A', 'N'}; 
        %classToSave = {'L', 'N', 'P'}; 
        classToRmv = setdiff(unique(labels_temp), classToSave); 
        for j = 1:size(classToRmv,1) 
            % get Char corresponding to class and remove from data/labels
            char = classToRmv{j,1}; 
            rmvIndex = find(labels_temp == char); 
            labels_temp(rmvIndex) = [];
            data_temp(rmvIndex,:) = [];
        end
        
        key = strcat('key', string(p));
        labels.(key) = labels_temp;
        data.(key) = data_temp;
        p = p + 1;
    end
end

clear classToRmv char key data_temp labels_temp dataStruct rmvIndex p


%% Define testing and training data for each of the 10 folds

%define testing datasets for each of the 10-fold cross val
fold.fold1 = [1, 2, 10, 18, 37];
fold.fold2 = [6, 7, 8, 11, 23];
fold.fold3 = [5, 12, 13, 14, 29];
fold.fold4 = [3, 16, 17, 33, 35, ];
fold.fold5 = [8, 10, 21, 22, 45];
fold.fold6 = [11, 26, 27, 37, 46];
fold.fold7 = [3, 18, 29, 31, 32];
fold.fold8 = [5, 23, 35, 36, 38];
fold.fold9 = [10, 29, 37, 41];
fold.fold10= [3, 11, 33, 47];

for i = 1:10
    numData = 48; %p-1
    allData = 1:numData;
    key = strcat('fold', string(i));
    testingIndex = fold.(key); %get testing data peices
    trainingIndex = setdiff(allData, testingIndex); 
    %train on all data except testing data
    
    
    %folds = 1:numData;
    %folds = folds(randperm(numData));

    %test/train split, set up to easily loop through 10 fold val if need be
    % loop through for 10-fold cross val. For now we do a simple split

    %testStart = 1; %we can vary this in a loop in order to do cross-Val
    %testingIndex = sort( folds(testStart:testStart+4) ); %get testing data peices
    %trainingIndex = union( folds(1:testStart-1), folds(testStart+5:numData) );
    %testingIndex = testStart:1:testStart+4; %get testing data peices
    %trainingIndex = union(1:1:testStart-1, testStart+5:1:numData);
    %get training data peices

    %define arrays for testing and training data
    trainData = [];
    trainLabels =[];
    testData = [];
    testLabels = [];

    for j = 1:numData %loop through all data, allocating to array as necessary
        key = strcat('key', string(j));
        labels_temp = labels.(key); %get relevant data peice
        data_temp = data.(key); %get corresponging labels
        if ismember(j, trainingIndex) == 1 %if its training data
            trainData = [trainData; data_temp]; %add to training matrix
            trainLabels = [trainLabels; labels_temp];
        else
            testData = [testData; data_temp]; %else add to test matrix
            testLabels = [testLabels; labels_temp];
        end
    end
    
    %reduce training size here
    trainDataCut = [];
    trainLabelsCut = [];
    for k = classToSave
        class = k{1,1}; %current class
        selectIndex = find(trainLabels == class); %get all indice for class
        numSelect = 2000; %how many of each class we want
        if class == 'N' %want more of 'N' class than others
            numSelect = 4000;
        end
        if length(selectIndex) > 0 %as long as indices exist
            %randomly select entries from the list of indicies
            keepIndex = randi(length(selectIndex), numSelect, 1);
            %add in data and labels at those indices
            trainDataCut = [trainDataCut; trainData(selectIndex(keepIndex), :)];
            trainLabelsCut = [trainLabelsCut; trainLabels(selectIndex(keepIndex), :)];
        end
    end
    
    %store training and testing in respective structures
    key = strcat('fold', string(i));
%     trainDataStruct.(key) = trainDataCut;
%     trainLabelStruct.(key) = trainLabelsCut;
    
    trainDataStruct.(key) = trainData;
    trainLabelStruct.(key) = trainLabels;
    
    testDataStruct.(key) = testData;
    testLabelStruct.(key) = testLabels;
end

%% wavelet optimization

nothing =0;
% [LoD,HiD,LoR,HiR] = wfilters('bior6.8');
fun = @(T)evalWavelet(T,trainDataStruct,trainLabelStruct,testDataStruct, testLabelStruct);
lb = [0,0];
ub = [2*pi,2*pi];
nvars = 2;
options = optimoptions(@particleswarm,'Display','iter');

x = particleswarm(fun,nvars,lb,ub);


%changed function arguments 
function error = evalWavelet(T,trainDataStruct,trainLabelStruct,testDataStruct, testLabelStruct)
    % make wavelets
    [HiD, LoD] = myWaveletGenerator(T);
    
    %define varibale to save score
    scoreTotal = 0;
    for i = 1%:10
        
        %fetch data for this round of cross validation
        key = strcat('fold', string(i));
        trainData = trainDataStruct.(key);
        trainLabels = trainLabelStruct.(key);
        testData = testDataStruct.(key);
        testLabels = testLabelStruct.(key);
        
        
        % wavelet transform
        wavTrainData = myWMRA(trainData', HiD, LoD);
        wavTestData = myWMRA(testData', HiD, LoD);


        % PCA dimension reduction
        % only use most significant principle components
        numDims = 12;
        coeff = pca(wavTrainData); 
        coeff = coeff(:,1:numDims); 
        redTrainData = wavTrainData * coeff; %reduced train data
        redTestData = wavTestData * coeff; %reduce test data


        % SVM
        % train
        t = templateSVM('KernelFunction','linear');
        model = fitcecoc(redTrainData,trainLabels,'Learners',t);
        
        % predict and get score
        pred = predict(model, redTestData);
        
        score = 0;
        for i = 1:length(pred)
            score = score + strcmp(pred(i), testLabels(i));
        end
        score = score/length(pred);
        
        %sum scores over the 10 cross-validations
        scoreTotal = scoreTotal + score;
    end
    
        
    score = scoreTotal;%/10;
    error = 1-score;
    
    disp(T)
    disp(score)
    
    % save data for later
%     s = [T ,score];
%     dlmwrite('optimization_record.csv',s,'-append','delimiter',',')
    
end
    

% Functions
function wave_beats = myWMRA(beats, HiD, LoD)
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

    wave_beats = [cD1;cD2;cD3;cD4;cD5;cD6;cD7;cD8]';

end










