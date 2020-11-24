[LoD,HiD,LoR,HiR] = wfilters('bior6.8');

% X some input
X = M(1:200,2);

% level 1
cD1 = filter(HiD,1,X);
cD1 = downsample(cD1,2);
LP1 = filter(LoD,1,X);
LP1 = downsample(LP1,2);

% level 2
cD2 = filter(HiD,1,LP1);
cD2 = downsample(cD2,2);
LP2 = filter(LoD,1,LP1);
LP2 = downsample(LP2,2);

% level 3
cD3 = filter(HiD,1,LP2);
cD3 = downsample(cD3,2);
LP3 = filter(LoD,1,LP2);
LP3 = downsample(LP3,2);

% level 4
cD4 = filter(HiD,1,LP3);
cD4 = downsample(cD4,2);
LP4 = filter(LoD,1,LP3);
LP4 = downsample(LP4,2);

% level 5
cD5 = filter(HiD,1,LP4);
cD5 = downsample(cD5,2);
LP5 = filter(LoD,1,LP4);
LP5 = downsample(LP5,2);

% level 6
cD6 = filter(HiD,1,LP5);
cD6 = downsample(cD6,2);
LP6 = filter(LoD,1,LP5);
LP6 = downsample(LP6,2);

% level 7
cD7 = filter(HiD,1,LP6);
cD7 = downsample(cD7,2);
LP7 = filter(LoD,1,LP6);
LP7 = downsample(LP7,2);

% level 8
cD8 = filter(HiD,1,LP7);
cD8 = downsample(cD8,2);
LP8 = filter(LoD,1,LP7);
LP8 = downsample(LP8,2);


figure(),
plot(X), hold on
plot(cD1),
plot(cD2),
plot(cD3),
plot(cD4),
plot(cD5),
plot(cD6),
plot(cD7),
plot(cD8),
