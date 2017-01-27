# Decision_Tree_With_Visualization
This is a simple but flexible decision tree implementation which you can see the created tree as a plot.
I also included a example run on a medical data and its results.
## Implementation details ##
I used entropy for calculating goodness of my splits and I used a threshold on support of a node (number of instances in that node) and a threshold on entropy for pre-pruning my tree. It worth mentioning that I used support threshold as a number and not as a portion of the data because I think it was better for clarification and understanding the results.
