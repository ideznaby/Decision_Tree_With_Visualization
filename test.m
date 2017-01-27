trainaccuracy = [];
testaccuracy = [];
classaccuracies = zeros(11,11,3);
for sth=0:10:100
    for eth = 0:0.1:1
        DT = DecisionTree(sth,eth);
        DT = DT.train(traindata);
        disp(['sth : ' , num2str(sth+1) , ' eth : ', num2str(eth)])
        [~, trainaccuracy(round(sth/10+1),round(eth*10+1)),classaccuracies(sth/10+1,round(eth*10+1),:)] = DT.classify(traindata);
        [~, testaccuracy(round(sth/10+1),round(eth*10+1)),classaccuracies(sth/10+1,round(eth*10+1),:)] = DT.classify(testdata);
    end
end
figure;
plot(trainaccuracy)
figure;
plot(testaccuracy)