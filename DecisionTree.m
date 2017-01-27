classdef DecisionTree
    %DECISIONTREE is the main class for decision tree which can learn
    %display and classify based on the decision tree
    
    properties
        root %root of the tree
        plottablenodes
        nodes
        parameters % all the parameters we have in the data
        support_thr % support threshold for the tree
        entropy_thr % entropy threshold for the tree
    end
    
    methods
        function obj = DecisionTree(supp_thr,ent_thr)
            obj.support_thr = supp_thr;
            obj.entropy_thr = ent_thr;
        end
        function DT = train(DT,data)
            % trains the tree based on given data
            % it uses buildtree to structure the data recursively
            for i=1:size(data,2)-1
                p = Parameter();
                p.index = i;
                %if data(1,i) == 1 || data(1,i) == 0
                 %  p.isbinary = true;
                %else
                    p.isbinary = false;
                %end
                p = p.calcsplitpoints(data);
                parameters(i) = p;
            end
            root = Node(parameters,data,DT.support_thr,DT.entropy_thr);
            DT.parameters= parameters;
            DT.root = DT.buildtree(root);
            [DT,~,nodes] = DT.createviewabletree(DT.root,0,1,[]);
            DT.nodes = nodes;
        end
        function root = buildtree(DT,root)
            if root.terminal == 0
                root = root.findparameter;
                root.left = DT.buildtree(root.left);
                root.right = DT.buildtree(root.right);
            end
        end
        function [DT,idx,A] = createviewabletree(DT,curnode,parent,idx,A)
            % converts tree to a plottable tree for Matlab
            DT.plottablenodes(idx) = parent;
            A(idx) = curnode;
            parent = idx;
            if ~isempty(curnode.left)
                idx = idx + 1;
                [DT,idx,A] = createviewabletree(DT,curnode.left,parent,idx,A);
            end
            if ~isempty(curnode.right)
                idx = idx + 1;
                [DT,idx,A] = createviewabletree(DT,curnode.right,parent,idx,A);
            end
        end
        function outclass = runforrow(DT,row)
            % finds a class based on the values of a given row
            % it uses recrun to recursively find the outputclass
            outclass = DT.recrun(row,DT.root);
        end
        function outclass = recrun(DT,row,node)
            % recursively find the outputclass of a row
            if node.terminal
                outclass = node.outclass;
            else
                P = node.parameter;
                Val = row(P.index);
                if Val > P.splitpoints(node.splitcriteria)
                    outclass = DT.recrun(row,node.right);
                else
                    outclass = DT.recrun(row,node.left);
                end
            end
        end
        function showtree(DT)
            % plots the tree
            treeplot(DT.plottablenodes);
            [x,y] = treelayout(DT.plottablenodes);
            for i=1:length(DT.nodes)
                if DT.nodes(i).terminal
                    text(x(i),y(i),['class', num2str(DT.nodes(i).outclass)]);
                else
                    if DT.nodes(i).parameter.isbinary
                        text(x(i),y(i),['x',num2str(DT.nodes(i).parameter.index), '=1']);
                    else
                        text(x(i),y(i),['x',num2str(DT.nodes(i).parameter.index), '<',num2str(DT.nodes(i).parameter.splitpoints(DT.nodes(i).splitcriteria))]);
                    end
                end
            end
        end
        function [classes,accuracy,classaccuracies] = classify(DT,testdata)
            % classifies given data and outputs accuracy, classbased
            % accuracy and found classes
            counttrue = 0;
            classes = zeros(1,size(testdata,1));
            classaccuracies = zeros(1,3);
            classcounts = zeros(1,3);
            for i=1:size(testdata,1)
                classes(i) = DT.runforrow(testdata(i,1:size(testdata,2)-1));
                classcounts(testdata(i,size(testdata,2))) = classcounts(testdata(i,size(testdata,2))) + 1;
                if classes(i) == testdata(i,size(testdata,2))
                    counttrue = counttrue + 1;
                    classaccuracies(testdata(i,size(testdata,2))) = classaccuracies(testdata(i,size(testdata,2)))+1;
                end
            end
            for i=1:3
                classaccuracies(i) = classaccuracies(i) / classcounts(i);
            end
            accuracy = counttrue / size(testdata,1);
        end
        function DT = selectparameters(DT,traindata,possible_support_thresholds, possible_entropy_thresholds)
            % goes over all given support thresholds and entropy thresholds
            % and selects the best based on overall accuracy
            indexes = DT.crossfold(traindata,3);
            bestST = 0;
            bestET = 0;
            bestaccuracy = 0;
            for PS = possible_support_thresholds
                for PE = possible_entropy_thresholds
                    accuracy = zeros(1,3);
                    for i=1:3
                        test = traindata(indexes(:,i),:);
                        if i==1
                            trainind = indexes(:,[2 3]);
                            train = traindata(trainind(:),:);
                        else if i==2
                                trainind = indexes(:,[1 3]);
                                train = traindata(trainind(:),:);
                            else
                                trainind = indexes(:,[1 2]);
                                train = traindata(trainind(:),:);
                            end
                        end
                        DT.support_thr = PS;
                        DT.entropy_thr = PE;
                        DT = DT.train(train);
                        [~,accuracy(i)] = DT.classify(test);
                    end
                    acc = mean(accuracy);
                    disp(['PS : ',num2str(PS),' PE ',num2str(PE),' acc ', num2str(acc)])
                    if acc >= bestaccuracy
                        bestaccuracy = acc;
                        bestST = PS;
                        bestET = PE;
                    end
                end
            end
            disp(bestaccuracy)
            DT.support_thr = bestST;
            DT.entropy_thr = bestET;
        end
        function indexes = crossfold(DT,data,numoffolds)
            % creates folds of the data and outputs their indexes
            % numberoffolds determines how many folds we want
            numofdataperfold = round(size(data,1)/numoffolds);
            indexes = zeros(numofdataperfold,numoffolds);
            randindexes = randperm(size(data,1));
            for NF=1:numoffolds
                indexes(:,NF) = randindexes(((NF-1) * numofdataperfold) + 1: NF * numofdataperfold);
            end
        end
    end
    
end

