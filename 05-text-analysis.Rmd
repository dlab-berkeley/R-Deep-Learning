---
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)

library(dplyr)
library(rio)
library(ggplot2)
library(keras)
```

## Import data

Download data from https://github.com/bpb27/trump_tweet_data_archive

```{r import_data}
data_file = "data-raw/condensed_2018.json"

if (!file.exists(data_file)) {

  file_url = "https://github.com/bpb27/trump_tweet_data_archive/raw/master/condensed_2018.json.zip"
  (local_file = paste0("data-raw/", basename(file_url)))

  # Download the zip file if we don't already have it in our working directory.
  # It is 65kb in size.
  if (!file.exists(local_file)) {
    download.file(file_url, local_file)
  }

  unzip(local_file, exdir = "data-raw")
}  

data = rio::import(data_file)
```

## Explore data

```{r explore_data}
dplyr::glimpse(data)

summary(data$favorite_count)

# Which tweet had the most favorites?
data %>% arrange(desc(favorite_count)) %>% filter(row_number() == 1)

qplot(data$favorite_count)
qplot(log(data$favorite_count + 1))

qplot(data$retweet_count)

summary(data)
table(data$source, useNA = "ifany")
```

How about we try to predict the number of retweets a Trump tweet will receive?

## Data prep

Adapted in part from https://keras.rstudio.com/articles/examples/reuters_mlp.html

```{r data_prep}
max_words <- 5000
batch_size <- 32
epochs <- 5

cat('Loading data...\n')

text_col = "text"
outcome_col = "retweet_count"

data[[text_col]] = tolower(data[[text_col]])

# Divide into training and test.
set.seed(1)
data$train = 0L
data$train[sample(nrow(data), ceiling(nrow(data) * 0.8))] = 1L

table(data$train, useNA = "ifany")
prop.table(table(data$train, useNA = "ifany"))

train = data[data$train == 1, ]
test = data[data$train == 0, ]

x_train <- train[[text_col]]
y_train <- train[[outcome_col]]
x_test <- test[[text_col]]
y_test <- test[[outcome_col]]

cat(length(x_train), 'train sequences\n')
cat(length(x_test), 'test sequences\n')

cat('Vectorizing sequence data...\n')

x_train[[1]]

tokenizer <- text_tokenizer(num_words = max_words)
tokenizer$fit_on_texts(data[[text_col]])

# Total number of unique words (tokens) found.
length(tokenizer$word_index)

x_train_seq = texts_to_sequences(tokenizer, x_train)
x_train_seq[[1]]

str(x_train_seq)

# Review distribution of token length.
summary(sapply(x_train_seq, length))

maxlen = 61L

train_data <- pad_sequences(
  x_train_seq,
  #value = word_index_df %>% filter(word == "<PAD>") %>% select(idx) %>% pull(),
  padding = "post",
  maxlen = maxlen,
)

str(train_data)
train_data[1, ]

x_test_seq = texts_to_sequences(tokenizer, x_test)

test_data <- pad_sequences(
  x_test_seq,
#  value = word_index_df %>% filter(word == "<PAD>") %>% select(idx) %>% pull(),
  padding = "post",
  maxlen = maxlen,
)
```

## Build model

```{r}
#vocab_size <- 10000

(vocab_size = tokenizer$num_words)

model <- keras_model_sequential()
model %>% 
  layer_embedding(input_dim = vocab_size, output_dim = 16) %>%
  layer_global_average_pooling_1d() %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 1, activation = "linear")

model %>% summary()

model %>% compile(
  optimizer = optimizer_adam(lr = 0.005),
  loss = 'mean_squared_error'
)

```

## Train model

```{r train_model}
history <- model %>% fit(
  train_data,
  y_train,
  epochs = 50,
  batch_size = 4,
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(patience = 8L, restore_best_weights = TRUE),
    callback_reduce_lr_on_plateau(patience = 4L)
  )
)

history
plot(history)
```

## Evaluate model


```{r eval_model}
(eval_loss = model %>% evaluate(test_data, y_test, verbose = 0))

# We're typically off by 10,483 retweets
sqrt(eval_loss)

# Just predicting the mean would only be off by 11,519 retweets typically.
sd(y_test)

# Look at predictions.
preds = model %>% predict(test_data)
head(preds)
summary(preds)

mean(y_train)

qplot(preds)

qplot(preds, y_test) + geom_smooth() + theme_minimal()

# Correlation of 0.44, p is highly significant.
cor.test(preds, y_test)
# Spearman correlation of 0.575
cor.test(rank(preds), rank(y_test))
```

## Try another architecture

```{r model2}

(vocab_size = tokenizer$num_words)

model <- keras_model_sequential()
model %>% 
  layer_embedding(input_dim = vocab_size, output_dim = 32) %>%
  #layer_lstm(16) %>%
  layer_conv_1d(64, kernel_size = 1) %>%
  layer_global_average_pooling_1d() %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_dropout(0.3) %>%
  layer_dense(units = 1, activation = "linear")

model %>% summary()

model %>% compile(
  optimizer = optimizer_adam(lr = 0.001),
  loss = 'mean_squared_error'
)
```

## Train model2

```{r train_model}
history <- model %>% fit(
  train_data,
  y_train,
  epochs = 50,
  batch_size = 32,
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(patience = 6L, restore_best_weights = TRUE, verbose = 1),
    callback_reduce_lr_on_plateau(patience = 3L, verbose = 1))
)

plot(history)
```

## Evaluate model2


```{r eval_model2}
(eval_loss = model %>% evaluate(test_data, y_test, verbose = 0))

# We're typically off by 10,750 retweets
sqrt(eval_loss)

# Look at predictions.
preds = model %>% predict(test_data)
head(preds)
summary(preds)

# Starting to get some spread in our predictions
qplot(preds)
qplot(preds, y_test) + geom_smooth() + theme_minimal()

# Pearson linear correlation of 0.395
cor.test(preds, y_test)
# Spearman correlation of 0.563
cor.test(rank(preds), rank(y_test))
# Same thing:
cor.test(preds, y_test, method = "spearman", exact = FALSE)
# Kendall's tau 0.402
cor.test(preds, y_test, method = "kendall", exact = FALSE)
```

## Challenges

1. Adjust the hyperparameters to see if you can improve performance.
2. Swap out the pooling and convolution layer with `layer_lstm(16)` for comparison.
3. Adapt this code to predict the favorite count rather than retweet count.