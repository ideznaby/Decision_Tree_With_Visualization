classdef Node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parameters
        parameter
        data
        splitcriteria
        left
        right
        terminal
        support_thr
        entropy_thr
        outclass
    end
    
    methods
        function obj = Node(parameters,data,sup_thr,ent_thr)
            obj.parameters = parameters;
            obj.data = data;
            obj.support_thr = sup_thr;
            obj.entropy_thr = ent_thr;
            obj.left = [];
            obj.right = [];
            if (size(data,1) <= sup_thr) || (entropy(data(:,size(data,2)))<=ent_thr)
                obj.terminal = true;
                count = zeros(1,3);
                for i=1:size(data,1)
                    count(data(i,size(data,2))) = count(data(i,size(data,2)))+1;
                end
                [~,obj.outclass] = max(count);
            else
                obj.terminal = false;
            end
        end
        function N = findparameter(N)
            min_entropy = 9999999999999999;
            min_i = 0;
            min_j = 0;
            min_leftdata =N.data;
            min_rightdata = N.data;
            for i=1:length(N.parameters)
                for j=1:length(N.parameters(i).splitpoints)
                    rightindexes = find(N.data(:,N.parameters(i).index)>N.parameters(i).splitpoints(j));
                    rightdata = N.data(rightindexes,:);
                    rightclasses = rightdata(:,size(N.data,2));
                    entright = entropy(rightclasses);
                    leftindexes = find(N.data(:,N.parameters(i).index)<=N.parameters(i).splitpoints(j));
                    leftdata = N.data(leftindexes,:);
                    leftclasses = leftdata(:,size(N.data,2));
                    entleft = entropy(leftclasses);
                    ent = (length(leftclasses)/length(N.data)) * entleft + (length(rightclasses)/length(N.data)) * entright;
                    disp(['parameter : ' , num2str(i) , ' ent : ' , num2str(ent)])
                    if ent < min_entropy
                        min_entropy = ent;
                        min_i = i;
                        min_j = j;
                        min_leftdata = leftdata;
                        min_rightdata = rightdata;
                    end
                end
            end
            N.parameter = N.parameters(min_i);
            N.splitcriteria = min_j;
            leftparameters = N.parameters;
            rightparameters = N.parameters;
            leftparameter = N.parameter;
            if min_j-1 < 1
                leftparameter.splitpoints = [];
            else
                leftparameter.splitpoints = leftparameter.splitpoints(1:min_j-1);
            end
            rightparameter = N.parameter;
            if min_j+1 > length(rightparameter.splitpoints)
                rightparameter.splitpoints = [];
            else
                rightparameter.splitpoints = rightparameter.splitpoints(min_j+1:end);
            end
            leftparameters(min_i) = leftparameter;
            rightparameters(min_i) = rightparameter;
            N.left = Node(leftparameters,min_leftdata,N.support_thr,N.entropy_thr);
            N.right = Node(rightparameters,min_rightdata,N.support_thr,N.entropy_thr);
        end
    end
end

