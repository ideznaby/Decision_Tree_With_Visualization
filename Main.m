%%reading data
clear all;
clc;
%read train data
fileID = fopen('ann-train.data.txt');
traindata = textscan(fileID,repmat('%f ',1,22));
traindata = cell2mat(traindata);
%read test data
fileID = fopen('ann-test.data.txt');
testdata = textscan(fileID,repmat('%f ',1,22));
testdata = cell2mat(testdata);
%% train and test
%train decision tree unbalanced
DT = DecisionTree(0,0);
%find the best parameters that give the most accuracy
DT = DT.selectparameters(traindata,0:10:200,0.1);
%train the tree using the best parameters found
DT = DT.train(traindata);
%show the tree
figure;
DT.showtree
%classify the train data and output the accuracies
[trainout, accuracy,classbasedaccuracy] = DT.classify(traindata);
disp(classbasedaccuracy)
%show the confusion matrix for training data
confusionmat(traindata(:,size(traindata,2)),trainout)
%classify the test data
[testout, accuracy,classbasedaccuracy] = DT.classify(testdata);
disp(classbasedaccuracy)
%show the confusion matrix for test data
confusionmat(testdata(:,size(testdata,2)),testout)
%% train decision tree balanced
%balance data
balanceddata = balancedata(traindata);
DT = DecisionTree(30,0.1);
%find the best parameters that give the most accuracy
DT = DT.selectparameters(traindata,0:10:200,0:0.05:1);
%train the tree using the best parameters found
DT = DT.train(balanceddata);
%show the tree
figure;
DT.showtree
%classify the train data and output the accuracies
[trainout, accuracy,classbasedaccuracy] = DT.classify(balanceddata);
disp(classbasedaccuracy)
%show the confusion matrix for training data
confusionmat(balanceddata(:,size(balanceddata,2)),trainout)
%classify the test data
[testout, accuracy,classbasedaccuracy] = DT.classify(testdata);
disp(classbasedaccuracy)
%show the confusion matrix for test data
confusionmat(testdata(:,size(testdata,2)),testout)
%% plotting accuracy based on threshold
trainaccuracy = [];
testaccuracy = [];
classaccuracies = zeros(11,11,3);
for sth=0:20:400
    for eth = 0:0.1:1
        DT = DecisionTree(sth,eth);
        DT = DT.train(traindata);
        disp(['sth : ' , num2str(sth+1) , ' eth : ', num2str(eth)])
        [~, trainaccuracy(round(sth/20+1),round(eth*10+1)),classaccuracies(sth/20+1,round(eth*10+1),:)] = DT.classify(traindata);
        [~, testaccuracy(round(sth/20+1),round(eth*10+1)),classaccuracies(sth/20+1,round(eth*10+1),:)] = DT.classify(testdata);
    end
end
figure;
subplot(2,2,1);
plot(0:0.1:1,classaccuracies(1,:,1));
subplot(2,2,2);
plot(0:0.1:1,classaccuracies(1,:,2));
subplot(2,2,3);
plot(0:0.1:1,classaccuracies(1,:,3));
figure;
subplot(2,2,1);
plot(0:20:400,classaccuracies(:,1,1));
subplot(2,2,2);
plot(0:20:400,classaccuracies(:,1,2));
subplot(2,2,3);
plot(0:20:400,classaccuracies(:,1,3));
figure;
surf(0:0.1:1,0:20:400,testaccuracy)
figure;
subplot(2,2,1)
surf(0:0.1:1,0:20:400,classaccuracies(:,:,1));
subplot(2,2,2)
surf(0:0.1:1,0:20:400,classaccuracies(:,:,2));
subplot(2,2,3)
surf(0:0.1:1,0:20:400,classaccuracies(:,:,3));