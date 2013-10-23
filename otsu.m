% Otsu Threshold

numPass = 3;
numPassTrain = 2;
numFail = 40;
numFailTrain = 39;
slices = (60:170);

numFailTest = numFail - numFailTrain;
numPassTest = numPass - numPassTrain;
[backgroundFailTrainAll,backgroundFailTest] = loadData('Fail','Back',numFail,numFailTrain,slices);

%%

for j = 1:39
backgroundFailTrain = backgroundFailTrainAll(j,:);

[n,x] = hist(backgroundFailTrain',256);
[W,L] = size(n);
sumN = repmat(sum(n,2),1,L);
n = n./sumN;


for k = 1:61

    thresholdIndex = 0:20:1200;
    threshold = thresholdIndex(k);
    
    tmp = abs(x-threshold);
    [idx idx] = min(tmp);
    
    uT = sum(n.*x);
    
    padding = [ones(1,idx) zeros(1,L-idx)];
    temp = n.*padding;
    u(k,j) = sum(temp.*x);
    w(k,j) = sum(temp);

    sigB(k,j) = (uT*w(k,j)-u(k,j))^2/(w(k,j)*(1-w(k,j)));

end
end

normalizer = repmat(max(sigB),61,1);
sigB = sigB./normalizer;

%%
close all

figure
h1 = plot(0:20:1200,sigB(:,1));
hold on
for p = 2:39
h3 = plot(0:20:1200,sigB(:,p));
hold on
end

h2 = plot(0:20:1200,mean(sigB,2),'r','linewidth',3);
axis([0 1200 0 1.05])

title('Otsu Threshold Detection','FontSize',25)
xlabel('Threshold','FontSize',20)
ylabel('SigmaB^2','FontSize',20)
set(gca,'fontsize',17)