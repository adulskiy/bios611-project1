# Table of Contents

1. [Problem 1:](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw4.md#org9536f13)
2. [Problem 2:](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw4.md#orgb3c4748)
3. [Problem 3](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw4.md#orgc9fe25f)
4. [Problem 4](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw4.md#org16f5bba)
5. [Problem 5](https://github.com/Vincent-Toups/datasci611/blob/master/homeworks/hw4.md#org58c90e3)

This homework data set depends on this data set:

https://www.kaggle.com/yersever/500-person-gender-height-weight-bodymassindex?select=500_Person_Gender_Height_Weight_Index.csv

Please submit this homework by creating an RMD file in your project1 git repo. The RMD should run in the project1 docker environment. You may need to install the gbm package.



# Problem 1:

*Build a glm in R to classifier individuals as either Male or Female based on their weight and height.*

*What is the accuracy of the model?*

**The accuracy of the model is only 0.48. That's worse than it would be if it were just random.**

```R
library(tidyverse)
library(caret)
library(gbm)

data <- read_csv("homeworks/HW4/GenderHeightWeight.csv")

# check for missing values
sum(is.na(data))
# cool! no missing values.

# Question 1
# Build a glm in R to classifier individuals as either Male or Female based on
# their weight or height.

# Convert Gender to binary.
data$Gender[data$Gender == 'Female'] = 0
data$Gender[data$Gender == 'Male'] = 1
data$Gender = as.integer(data$Gender)

# Split into training and test data sets.

split = 0.80
trainIndex <- createDataPartition(data$Gender, p = split, list = FALSE)
train <- data[trainIndex,]
test <- data[-trainIndex,]

# glm time!
model <- glm(Gender ~ Height +
               Weight, family = binomial(link = 'logit'), data = train)
pred <- predict(model, newdata = test, type = "response");
sum((pred > 0.5) == test$Gender)/nrow(test)

summary(model)
# Accuracy is only 0.48! No good.
```



# Problem 2:

*Use the 'gbm' package to train a similar model. Don't worry about hyper parameter tuning for now.*

*What is the accuracy of the model?*

**The model's accuracy is 0.44, so actually worth than with the glm and still worse than random.**

```R
# Question 2: GBM
library(gbm)

# Split data this time using caret.
library(caret)

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



# Problem 3

*Filter the data set so that it contains only 50 Male examples. Create a new model for this data set. What is the F1 Score of the model?*

**The accuracy of the model is much better at 0.85. **

```R
# Filter for male, then randomly sample 50
# Remember female = 0, male = 1
male50 <- data %>%
  filter(Gender == 1) %>%
  sample_n(50)

# Filter for just female
female <- data %>%
  filter(Gender ==0)

# Join male50 and female.
q3 <- full_join(male50, female)

# Split data.
split = 0.80
trainIndex <- createDataPartition(q3$Gender, p = split, list = FALSE)
train <- q3[trainIndex,]
test <- q3[-trainIndex,]

# GLM

model <- glm(Gender ~ Height +
               Weight, family = binomial(link = 'logit'), data = train)
pred <- predict(model, newdata = test, type = "response");
sum((pred > 0.5) == test$Gender)/nrow(test)
```

Attemps to calculate the F1 score returned an error message - not sure why.

```R
# F1 score

library(MLmetrics)

# Convert to numeric so it'll work with F1_Score function.
test$Gender = as.numeric(test$Gender)
pred = as.numeric(pred)

f1 <- MLmetrics::F1_Score
f1(test$Gender, pred > 0.5)
# Returns error message.
```



# Problem 4

*For the model in the previous example plot an ROC curve. What does this ROC curve mean?*

An ROC curve plots the true positive rate against the false positive rate. The ROC curve produced for the model in problem 3 has a high false positive rate. The closer the area under the curve (AUC) is to 1, the better the model is (high true positive rate, low false positive rate). In this case, I haven't done a calculation of the AUC, but it is far below 1 and below 0.50, so there is a high false positivity rate.

![ROC](/Users/anadulskiy/storage/bios611-project1/homeworks/HW4/figures/ROC.png)

```R
roc <- do.call(rbind, Map(function(threshold){
  p <- pred > threshold;
  tp <- sum(p[test$Gender])/sum(test$Gender);
  fp <- sum(p[!test$Gender])/sum(!test$Gender);
  tibble(threshold=threshold,
         tp=tp,
         fp=fp)
},seq(100)/100))

ggplot(roc, aes(fp,tp)) + geom_line() + xlim(0,1) + ylim(0,1) +
  labs(title="ROC Curve",x="False Positive Rate",y="True Positive Rate")

```



# Problem 5

*Using K-Means, cluster the same data set. Can you identify the clusters with the known labels? Provide an interpretation of this result.*

![kmeans](/Users/anadulskiy/storage/bios611-project1/homeworks/HW4/figures/kmeans.png)

It looks like we have two distinct clusters above, but I am a bit confused. When I plot the height vs. weight gender data with ggplot2, I see no clear patterns (which is surprising to me). So it's not clear to me how K-means clustering is resulting in two distinct clusters. Also, when I calculate the averages for males and females for height and weight, there is very little different between the two. It makes me wonder if there are errors in the dataset or if I did something incorrectly.



Code for Q5:

```R
library(Rtsne)


data_k <- data %>%
  select(Height, Weight) %>%
  distinct()
  
cc <- kmeans(data_k, 2)  # 2 clusters
fit <- Rtsne(data_k, dims = 2)

ggplot(fit$Y %>% as.data.frame() %>% as_tibble() %>% mutate(label=cc$cluster),aes(V1,V2)) +
  geom_point(aes(color=factor(label)))
```

