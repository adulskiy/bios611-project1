library(tidyverse)
library(caret)
library(gbm)

install.packages("caret")
install.packages("gbm")
install.packages("MLmetrics")

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




# Question 3: Filter the dataset so that it contains only 50 Male examples. 
# Create a new model for this dataset.

# Remember female = 0, male = 1
male50 <- data %>%
  filter(Gender == 1) %>%
  sample_n(50)

female <- data %>%
  filter(Gender ==0)

q3 <- full_join(male50, female)

# Split data.
split = 0.80
trainIndex <- createDataPartition(q3$Gender, p = split, list = FALSE)
train <- q3[trainIndex,]
test <- q3[-trainIndex,]

# GBM
model <- glm(Gender ~ Height +
               Weight, family = binomial(link = 'logit'), data = train)
pred <- predict(model, newdata = test, type = "response");
sum((pred > 0.5) == test$Gender)/nrow(test)


# F1 score

library(MLmetrics)

# Convert to numeric so it'll work with F1_Score function.
test$Gender = as.numeric(test$Gender)
pred = as.numeric(pred)

f1 <- MLmetrics::F1_Score
f1(test$Gender, pred > 0.5)
# Returns error message.


# Question 4 - For the model in Q3, plot an ROC curve.

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



# Question 5 - K means clustering
install.packages("Rtsne")
library(Rtsne)


data_k <- data %>%
  select(Height, Weight) %>%
  distinct()
  
cc <- kmeans(data_k, 2)  # 2 clusters
fit <- Rtsne(data_k, dims = 2)

ggplot(fit$Y %>% as.data.frame() %>% as_tibble() %>% mutate(label=cc$cluster),aes(V1,V2)) +
  geom_point(aes(color=factor(label)))

cc$centers

tapply(data$Height, data$Gender, mean)
