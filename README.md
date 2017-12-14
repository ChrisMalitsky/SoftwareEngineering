Software Engineering

Project: ASRC Machine Learning

Version 1.5

Our System creates bins of 0's, 1's and 2's corresponding to each decay coefficient based on each value's relation to Q1 and Q3 (0 being below Q1, 1 being between Q1 and Q3, and 2 being above Q3) and machine learns, using Bagged Trees, on sponsor given data and then predicts the outcome of whether the decay coefficients are "Fine", "On the Way", or "In Danger". Our system finds each feature's importance relating to the tests that were run on the training data. 

Input: Data (.txt)

Output: # of correct Compressor decay predictions, # of correct Turbine decay predictions, % Compressor correct, % Turbine correct, Pie charts to display these values, Confusion Matrices, Predictor Importance for each coefficient and respective Bar Graph
