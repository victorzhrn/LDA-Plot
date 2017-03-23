## LDA Plot 

### Description
##### LDA and plot
Linear discriminant analysis(LDA) is a method used in statistics, pattern recognition and machine learning to find a linear combination of features that characterizes or separates two or more classes of objects or event. The idea of LDA is to find a linear combination of variables to model the difference between the classes of a particular set of variable (usually categorical variables). Since LDA and PCA (both finds a linear combination of variables) are similar techniques, LDA can be visualized as well through plotting the variables on dimensions of linear coefficients just as biplot for PCA.

##### Advantage of using LDA plot for consulting purpose
Based on the properties and functionality of LDA explained above, LDA plot can be a useful technique to visualize discriminance between factor levels with in a category. For example, on the default dataset, customers ranked different features on multiple brands. LDA plot helps to visualize difference of rankings between brands on those features.

### App Details
The details of the app can be find [here](https://zhangruinan.shinyapps.io/LDA_plot/)

#### Functionality
- Import File
	* this feature allows users to upload their own dataset
- Visualization choices
	* this feature allows users to choose the objects plotted on the graph, including: all the observations, brands as centroids, questions/features
- Unstack keywords
	* this is a special features proposed by Smari Inc. due to its input data format. The app is able to unstack multiple response variables. The questions/features are identified by matching provided substrings. Please note the number of questions matched by multiple substrings has to be exactly same for the unstack process to work.
- Information on Default dataset:
	* Unfortuantely, the details on brands and questions from default dataset can not be revealed as it is provided by Smari Inc.



