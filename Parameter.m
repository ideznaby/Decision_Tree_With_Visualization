classdef Parameter
    %PARAMETER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        index
        isbinary
        splitpoints
    end
    
    methods
        function P = calcsplitpoints(P,data)
            % calculates spit points of a parameter
            if(~P.isbinary)
                P.splitpoints = [];
                [~, order] = sort(data(:,P.index));
                sorteddata = data(order,:);
                flag = false;
                for i=1:size(sorteddata,1)-1
                    if (sorteddata(i,size(sorteddata,2)) ~= sorteddata(i+1,size(sorteddata,2)) || flag) &&  sorteddata(i,P.index) ~= sorteddata(i+1,P.index)
                        P.splitpoints = [P.splitpoints ((sorteddata(i,P.index) + sorteddata(i+1,P.index))/2)];
                        flag = false;
                    end
                    if sorteddata(i,P.index) == sorteddata(i+1,P.index) && sorteddata(i,size(sorteddata,2)) ~= sorteddata(i+1,size(sorteddata,2))
                        flag = true;
                    end
                end
            else
                % if its a binary it has a splitpoint which is 0.5
                P.splitpoints = 0.5;
            end
        end
    end
end

