---
title: "Prediction Assignment Writeup.rmd"
author: "Rahul"
date: "10/8/2020"
output: html_document
---
# Introduction

The goal of this project is to predict the manner in which they did the exercise. We are aiming to build a model which could help us predit this. In thsi report we mentioned how we created the model, ho we used the cross-validation, the expected out of sample error, and why certain choices were made.

## **Loading the library**
```{r, Echo=TRUE}
set.seed(12345)
library(caret)
library(ggplot2)
library(data.table)
library(randomForest)
```

## Dataset

### Loading the dataset
Loaded the dataset from the urls provided in the assignment page.
```{r, Echo=TRUE}
url_train <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
train_data <- read.csv(url_train, na.strings = c("", "NA"))
url_testing <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
test_data <- read.csv(url_testing, na.strings = c("", "NA"))
```

### cleaning the dataset
The dataset was cleaned for better results.
```{r, Echo=TRUE}
columnname <- colnames(train_data)[!colSums(is.na(train_data)) > 0] #removing columns with NA to avoid error
columnname
```

### Data slicing done which is related to the exercise
```{r, Echo=TRUE}
columnname <- columnname[8: length(columnname)]
data_NA <- train_data[columnname]

is.element(columnname, colnames(test_data))
```

### Exploration of the dataset

The exploration of the dataset was conducted to analyse whther it will affect any of the following decisions in modelling.

```{r, Echo=TRUE}
length(intersect(colnames(train_data),colnames(test_data)))
```

Checking which column names are common among testing and training, so as to exclude the ones which are not common. Checking the class balance in the training set to see whether there is anything in particular we should be concerned with. 

```{r, Echo=TRUE}
barplot(table(train_data$classe))
```

```{r, Echo=TRUE}
plot_2 <- splom(classe~train_data[1:5], data = train_data)
plot_2
```
159 variables in common, everyone except classe, and the target variable is fairly even blanances across the different classes.

## Split
Splitting the dataset
```{r, Echo=TRUE}
Training = createDataPartition(data_NA$classe, p = 3/4)[[1]]
train = data_NA[ Training,]
test = data_NA[-Training,]
```

## Selecting the model

### Model 1: Random Forest

```{r, Echo=TRUE}
# random forest with more time consuming model but higher accuracy 
model1_data <- train(classe ~ ., data = train, method = "rf")
predictor1_data <- predict(model1_data, test)
confusionMatrix(test$classe, predictor1_data)
```

### Model 2: Linear Discriminant Analysis

```{r, Echo=TRUE}
# LDA Model 
model2_data <- train(classe ~ ., data = train, method = "lda")
predictor2_data <- predict(model2_data, test)
confusionMatrix(test$classe, predictor2_data)
```

## Testing the model

Here we are testing the random forest model, it looks like the random forest model was the most acurate with highest value at 99.45.

Below is the prediction:
```{r, Echo=TRUE}
# Submitting the results from the model 1: Random forest
results_model1 <- predict(model1_data, test_data)
results_model1 
```