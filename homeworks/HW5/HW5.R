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


# Q2.1 - Examine the dataset for any irregularities. 
# Make the case for filtering out a subset of rows (or for not doing so).

herodata <- read_csv("homeworks/characterstats.csv")

# check for nulls
sum(is.na(herodata))

herodata[!complete.cases(herodata),]
# There are three instances where there is no entry for alignment.
# Two of the characters (Anti-Venom and Blackwulf) seem to have legitimate data for 
#   the rest of the columns.
# Trickster, on the other hand, has basically all 1s for his intelligence, strength, etc.
# This is peculiar and warrants further investigation.

# Let's use dplyr to find all values of 5 for the "total" column.
herodata_NA <- herodata %>% 
  filter(Total == 5)
head(herodata_NA)

# Cleaned up data
herodata_v2 <- herodata %>% 
  filter(Total != 5)


write_csv(herodata_v2, "homeworks/herodata.csv");


# Check for duplicate values.
sum(duplicated(herodata_v2))
# No duplicate values! Good.

# Q2.2 - Perform a principal component analysis on the numerical columns of this data. 
# How many components do we need to get 85% of the variation in the data set?

# Use prcomp(), exclude name and alignment
pca <- prcomp(herodata_v2 %>% select(!c(1, 2)))
summary(pca)
fviz_eig(pca)

# First, let's check if removing totals improves things at all.
pca_nototal <- prcomp(herodata_v2 %>% select(!c(1, 2, 8)))
summary(pca_nototal)
fviz_eig(pca_nototal)
# Nope.

# Normalize the data using scale.
pca_norm <- prcomp(scale(herodata_v2 %>% select(!c(1,2))))
summary(pca_norm)
fviz_eig(pca_norm)

# For the data excluding the total.
pca_norm_nt <- prcomp(scale(herodata_v2 %>% select(!c("Name", "Alignment", "Total", "sums"))))
summary(pca_norm_nt)
fviz_eig(pca_norm_nt)
print(pca_norm_nt)
                  
# Q 2.4 - Is the "total" column really the total of the values in the other columns?
herodata_v2 <- herodata_v2 %>% select(-sums)
herodata_v2$sums <- rowSums(herodata_v2 %>% select(!c(Name, Alignment, Total)))
herodata_v2 %>% select(Total, sums)

# Q 2.6 - Make a plot of the two largest components. Any insights?
pca_norm_nt
# Looks like the largest components are durability and strength.

pca_ds <- prcomp(scale(herodata_v2 %>% select(c("Durability", "Strength"))))
summary(pca_ds)
fviz_eig(pca_ds)
fviz_pca_var(pca_ds)
fviz_pca(pca_ds, geom = "point")



# Q3
herostats_tsne <- read_csv("homeworks/herostats_tsne.csv")

tsneplot <- ggplot(herostats_tsne, aes(x = X1, y = X2, color = Alignment)) +
  geom_point()
?ggsave()

ggsave("homeworks/HW5/tsneplot_R.png", plot = tsneplot)



# Q5
# Using the Caret library, train a GBM model which attempts to predict character alignment. 
# What are the final parameters that caret determines are best for the model.

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
