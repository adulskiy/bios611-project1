# Table of Contents

1. [Q1](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#org0f04966)
2. [Q2](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#org6a81eeb)
3. [Q3](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#org51a4194)
4. [Q4](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#org61f5d14)
5. [Q5](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#orgb73f6b4)
6. [Q6](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#org870b507)
7. [Q7](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw5.md#orge0cfd1d)



# Q1

With the data set given here:

https://raw.githubusercontent.com/Vincent-Toups/bios611-project1/master/source_data/datasets_26073_33239_weight-height.csv

Repeat your GBM model. Contrast your results with the results for the previous exercise.

```R
library(tidyverse)
library(caret)
library(gbm)
library(factoextra)


data <- read_csv("homeworks/hw5data.csv")

# Question 1: GBM
library(gbm)

# Convert Gender to binary.
data$Gender[data$Gender == 'Female'] = 0
data$Gender[data$Gender == 'Male'] = 1
data$Gender = as.integer(data$Gender)

# Define train/test split.
split = 0.80
trainIndex <- createDataPartition(data$Gender, p = split, list = FALSE)
train <- data[trainIndex,]
test <- data[-trainIndex,]

# Run the model.
model <- gbm(Gender ~ Height +
               Weight, distribution = "bernoulli",
             data = train,
             n.trees = 100,
             interaction.depth = 2,
             shrinkage = 0.1)
pred <- predict(model, test, type = "response")
sum((pred > 0.5) == test$Gender)/nrow(test)
```

The accuracy of the model this time was 0.908, so much better than the result of 0.48 for the previous model in HW4.

# Q2

Using the data set available here:

https://github.com/Vincent-Toups/bios611-project1/blob/master/source_data/datasets_38396_60978_charcters_stats.csv

1. Examine the dataset for any irregularities. Make the case for filtering out a subset of rows (or for not doing so).

   1. ```R
      herodata <- read_csv("homeworks/characterstats.csv")
      
      # check for nulls
      sum(is.na(herodata))
      
      herodata[!complete.cases(herodata),]
      ```

      ```R
      # A tibble: 3 x 9
        Name       Alignment Intelligence Strength Speed Durability Power Combat Total
        <chr>      <chr>            <dbl>    <dbl> <dbl>      <dbl> <dbl>  <dbl> <dbl>
      1 Anti-Venom NA                  75       60    65         90    85     84   459
      2 Blackwulf  NA                  50       28     8         30    59     25   200
      3 Trickster  NA                   1        1     1          1     0      1     5
      ```

      There are three instances where characters don't have an alignment entry of "good" or "bad." Two of the characters (Anti-Venom and Blackwulf) seem to have legitimate data for the rest of the columns. This may be due to the fact that they truly don't have an alignment, or just a case of missing data. I will filter out this data for training the model, but maybe we can use the model to make predictions about the alignment of these characters later. One of the characters, however, has basically all 1s for his intelligence, strength, etc. This is peculiar and warrants further investigation. Since this results in a total of 5, we can search for other characters that have the same total.

      ```R
      # Let's use dplyr to find all values of 5 for the "total" column.
      herodata_NA <- herodata %>% 
        filter(Total == 5)
      head(herodata_NA)
      ```

      ```
      # A tibble: 6 x 9
        Name             Alignment Intelligence Strength Speed Durability Power Combat Total
        <chr>            <chr>            <dbl>    <dbl> <dbl>      <dbl> <dbl>  <dbl> <dbl>
      1 Adam Strange     good                 1        1     1          1     0      1     5
      2 Agent  13        good                 1        1     1          1     0      1     5
      3 Alex Woolsly     good                 1        1     1          1     0      1     5
      4 Allan Quatermain good                 1        1     1          1     0      1     5
      5 Ammo             bad                  1        1     1          1     0      1     5
      6 Ando Masahashi   good                 1        1     1          1     0      1     5
      ```

      There are six characcters with this same mistake - definitely makes sense to filter out of the data.

      ```R
      # Cleaned up data
      herodata_v2 <- herodata %>% 
        filter(Total != 5)
      ```

      Quick check for duplicate values.

      ```R
      # Check for duplicate values.
      sum(duplicated(herodata_v2))
      # No duplicate values! Good.
      ```

      

2. Perform a principal component analysis on the numerical columns of this data. How many components do we need to get 85% of the variation in the data set?

   1. ```R
      # Use prcomp(), exclude name and alignment
      pca <- prcomp(herodata_v2 %>% select(!c(1, 2)))
      summary(pca)
      # Visualize using fviz_eig()
      fviz_eig(pca)
      ```

      Most of the variation is from one component (PC1).

      ![q2.2_pca1](https://github.com/adulskiy/bios611-project1/blob/master/homeworks/HW5/q2.2_pca1.png)

      

      About 86% of the total variance can be explained by the first principal component.

      It is probably a good idea to normalize.

   2. Let's also try excluding the total.

      ```R
      pca_nototal <- prcomp(herodata_v2 %>% select(!c(1, 2, 8)))
      summary(pca_nototal)
      fviz_eig(pca_nototal)
      ```

      ![q2.2_pca_nototal](/Users/anadulskiy/storage/bios611-project1/homeworks/HW5/q2.2_pca_nototal.png)

      Same situation, although even more severe.

3. Do we need to normalize these columns or not?

   1. Yes, as one component is response for the vast amount of variation in our data.

   2. After normalizing, PC1 only accounts for ~ 53% of the variation in our data.

      ```R
      pca_norm <- prcomp(scale(herodata_v2 %>% select(!c(1,2))))
      summary(pca_norm)
      fviz_eig(pca_norm)
      
      # summary:
      Importance of components:
                                PC1    PC2    PC3     PC4     PC5     PC6       PC7
      Standard deviation     1.9211 1.0366 0.8695 0.78316 0.74661 0.55491 3.048e-16
      Proportion of Variance 0.5272 0.1535 0.1080 0.08762 0.07963 0.04399 0.000e+00
      Cumulative Proportion  0.5272 0.6807 0.7888 0.87638 0.95601 1.00000 1.000e+00
      ```

      Excluding the total column:

      ```
      Importance of components:
                                PC1    PC2    PC3    PC4     PC5     PC6
      Standard deviation     1.6412 1.0353 0.8695 0.7831 0.74653 0.55485
      Proportion of Variance 0.4489 0.1787 0.1260 0.1022 0.09289 0.05131
      Cumulative Proportion  0.4489 0.6276 0.7536 0.8558 0.94869 1.00000
      ```

      Also much better - ~45%.

4. Is the "total" column really the total of the values in the other columns?

   1. Yes, it looks like the "total" column is really the total of the values in the other columns.

      ```R
      # Create an additional column that represents the sum of the numeric columns ( excluding Total, of course).
      herodata_v2$sums <- rowSums(herodata_v2 %>% select(!c(Name, Alignment, Total)))
      
      # Looks good!
      ```

5. Should we have included total in the PCA? What do you expect about the largest principal components and the total column? Remember, a given principal component corresponds to a weighted combination of the original variables.

   1. No, we shouldn't include the total, as it is essentially repeating the other data already included in the analysis. 

6. Make a plot of the two largest components. Any insights?

   1. It looks like the two largest components explain a similar amount of variation in the data.

   2. ```R
      pca_ds <- prcomp(scale(herodata_v2 %>% select(c("Durability", "Strength"))))
      summary(pca_ds)
      fviz_eig(pca_ds)
      fviz_pca_var(pca_ds)
      ```

      ![q2.6_pca](/Users/anadulskiy/storage/bios611-project1/homeworks/HW5/q2.6_pca.png)



# Q3

Use Python/sklearn to perform a TSNE dimensionality reduction (to two dimensions) on the numerical columns from the set above. You'll need lines like this in your Dockerfile:

```
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh
```

Once you've performed the analysis in Python (feel free to use a Python notebook) write the results to a csv file and load them into R. In R, plot the results.

Color each point by the alignment of the associated character. Any insights?

See the aliases file in Lecture 16 for how to launch your Jupyter Lab.

1. Results plotted in R:

   ![tsneplot_R](/Users/anadulskiy/storage/bios611-project1/homeworks/HW5/tsneplot_R.png)

   ​	It looks like the TSNE dimensionality reduction does not do a good job of clustering by alignment.

# Q4

Reproduce your plot in Python with plotnine (or the library of your choice).

1. Results plotted in Python:

   ![tsneplot_python](/Users/anadulskiy/storage/bios611-project1/homeworks/tsneplot_python.png)

# Q5

Using the Caret library, train a GBM model which attempts to predict character alignment. What are the final parameters that caret determines are best for the model.

Hints: you want to use the "train" method with the "gbm" method. Use "repeatedcv" for the characterization method. If this is confusing, don't forget to read the Caret docs.

1. ```R
   install.packages('e1071', dependencies=TRUE)
   library(e1071)
   
   # Define train/test split.
   split = 0.80
   train <- herostats_tsne[trainIndex,]
   test <- herostats_tsne[-trainIndex,]
   trainControl <- trainControl(method = "repeatedcv", number = 5, repeats = 5)
   
   gbmFit <- train(Alignment ~ ., data = train,
                   method = "gbm",
                   trControl = trainControl,
                   verbose = FALSE)
   ```

   ```R
   > summary(gbmFit)
                                           var   rel.inf
   Intelligence                   Intelligence 18.606193
   Total                                 Total 18.242683
   X1                                       X1 12.839434
   X2                                       X2 12.542883
   Speed                                 Speed 10.238696
   Durability                       Durability  9.340207
   Combat                               Combat  6.429498
   Power                                 Power  6.262901
   Strength                           Strength  5.497504
   ...
   ```

# Q6

A conceptual question: why do we need to characterize our models using strategies like k-fold cross validation? Why can't we just report a single number for the accuracy of our model?

1. When we partition data into different sets, we reduce the numbers of samples which be used for learning the model, and so the results essentially depend on a random choice for the sets. Strategies like k-fold cross validation are a solution to this problem, as the validation set is no longer needed for the CV. 

# Q7

Describe in words the process of recursive feature elimination.

1. Feature selection refers to techniques that select a subset of the most relevant features, or columns, for a dataset. By using a smaller subset of features, machine learning algorithms can run more efficiently and may be at times more effective. Recursive feature elimination is a "wrapper-type" feature selection algorithm, which means that another ML algorithm is given and used in the core of the method, is wrapped by RFE, and used to help select features. It works by searching for a subset of features by starting with all features in the training dataset and successfully removing features until the desired number remains. The ML algorithm used in the model is fit, features are ranked by importance, least important features are discared, and then the model is refit. This process repeats until the desired number of features remains.